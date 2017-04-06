public without sharing class AcxiomCallout{
     
     Acxiom_Integration__c settings;
     private final String xxx_serviceBaseURL;
     private AcxiomClasses.TokenInfo currentToken;
     public string EndPointURL;     
     public IntegrationLog__c log;
     private Integer LogRequestMaxLength;
     private Integer LogResponseMaxLength;
     
     public AcxiomCallout(String strCalloutType){
        settings = Acxiom_Integration__c.getOrgDefaults();
        log = new IntegrationLog__c( Type__c = 'Acxiom', Callout__c = strCalloutType, Message__c = '');
        xxx_serviceBaseURL = settings.EndPointURL__c;        
     }
     
     public void transaction(String tranId){
         log.Transaction_Management__c =  TranId;
     }
     
     public void formName(String FormName){
         log.FormName__c = FormName;
     }
     
     public void customerCCN(String customerCCN){
         log.CustomerId__c = customerCCN;
     }
     
     public integer getTimeOut(){
         if(settings.RequestTimeOut__c == null || settings.RequestTimeOut__c > 60)
            return 6000;
         else
            return Integer.ValueOf(settings.RequestTimeOut__c * 1000) ;
     }
     
     public void log(String strMessage){
        if(String.isNotBlank(log.Message__c))
            log.Message__c += '\n';
        log.Message__c += strMessage; 
     }
     
     public void log(Exception ex){
         String strException = ex.getTypeName()  + ' ' + ex.getMessage() + '\n' + ex.getStackTraceString();
         log(strException);
         log.Success__c = false;
     }
     
     public void logRequest(String strRequest){
         if(LogRequestMaxLength == null)
            LogRequestMaxLength = IntegrationLog__c.Request__c.getDescribe().getLength();
         
         log.Request__c = strRequest.length() > LogRequestMaxLength ? strRequest.substring(LogRequestMaxLength - 100) + ' .... **Request JSON is truncated because it was exceeding the field size.' : strRequest;
     }
     
     public void logResponse(String strResponse){
         if(LogResponseMaxLength == null)
            LogResponseMaxLength = IntegrationLog__c.Response__c.getDescribe().getLength();
         
         log.Response__c = strResponse.length() > LogResponseMaxLength ? strResponse.substring(LogResponseMaxLength - 100) + ' .... **Response JSON is truncated because it was exceeding the field size.' : strResponse;
     }
     
     public AcxiomClasses.TokenInfo getAccessToken(){         
         
         HttpRequest req = new HttpRequest();
         EndPointURL = '/altria/test/token?grant_type=client_credentials&client_id='+settings.Client_Id__c+'&client_secret='+settings.Client_Secret__c;
        
         req.setEndpoint(xxx_serviceBaseURL + EndPointURL);
         req.setMethod('POST');
         req.setHeader('Content-Type', 'application/json');
         req.setTimeout(getTimeOut());
         
         
         Http http = new Http();
         HTTPResponse res = http.send(req);
         String strResponseBody = res.getBody();
         System.debug(strResponseBody);
         logResponse(strResponseBody);
         currentToken = (AcxiomClasses.TokenInfo)Json.deserialize(strResponseBody, AcxiomClasses.TokenInfo.class);
         log.Success__c = true;
         
         if(currentToken == null || String.isEmpty(currentToken.access_token))
            throw new AcxiomCalloutException('Unable to get access token from Acxiom');
            
         return currentToken;
     }
     
     
     public AcxiomClasses.ConsumerFinalResponse FullSearchLookupRequest(String strRequestBody){
        
        HttpRequest req = new HttpRequest();
        EndPointURL = '/altria/UAT/api/FullSearch';
        req.setEndpoint(xxx_serviceBaseURL + EndPointURL);
        
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('vendor-cd', settings.Vendor_cd__c);
        req.setHeader('Authorization', currentToken.token_type+' '+currentToken.access_token);
        req.setHeader('website-id',  settings.Website_Id__c);
        req.setHeader('access-type-cd', settings.Access_type_cd__c);
        req.setHeader('channel-type-cd', settings.Channel_type_cd__c);
        req.setHeader('Host', settings.Host__c);

        req.setTimeout(getTimeOut());
        
        Http http = new Http();
        req.setBody(strRequestBody);
        
        logRequest(strRequestBody);
        
        HTTPResponse res = http.send(req);
        String strResponse = res.getBody();
        logResponse(strResponse);
        
        AcxiomClasses.ConsumerFullSearchResponse response = (AcxiomClasses.ConsumerFullSearchResponse)Json.deserialize(strResponse, AcxiomClasses.ConsumerFullSearchResponse.class);
        System.debug('test response '+response);
        
        AcxiomClasses.ConsumerFinalResponse cObj = new AcxiomClasses.ConsumerFinalResponse();
        
            
        String strDevMessage = response.StatusData[0].StatusMessage;    
        
        cObj.StatusCode = response.StatusData[0].StatusCode;
        cObj.StatusMessage = response.StatusData[0].StatusMessage;
        cObj.ConsumerMessage =  response.StatusData[0].ConsumerMessage;
         cObj.RequestId = response.RequestId;
        log.Success__c = true;
            
        if(String.isNotEmpty(strDevMessage) && strDevMessage.contains('CCN FOUND')){     
        
            cObj.CCN = response.CCN;
            cObj.WinningCCN = response.WinningCCN;
           
            
            
            AcxiomClasses.FullSearchInner FullSearchInnerObj = new AcxiomClasses.FullSearchInner();
            AcxiomClasses.QualificationData QualificationDataObj = new AcxiomClasses.QualificationData();
            AcxiomClasses.ChannelData ChannelDataObj = new AcxiomClasses.ChannelData();
            AcxiomClasses.AuthenticationData AuthenticationDataObj = new AcxiomClasses.AuthenticationData();
            
            
            FullSearchInnerObj = response.FullSearch;
            
            
            AuthenticationDataObj  =  FullSearchInnerObj.objAuthenticationData;
            
            cObj.strLexisNexisId = AuthenticationDataObj.strLexisNexisId;
            cObj.strConsumerAuthCd = AuthenticationDataObj.strConsumerAuthCd;
            
            
            QualificationDataObj = FullSearchInnerObj.objQualificationData;
            
            List<AcxiomClasses.QualificationInner>  QualificationInnerObj = new List<AcxiomClasses.QualificationInner>();
            
            QualificationInnerObj = QualificationDataObj.aObjOpCoQualification;
            
            for(AcxiomClasses.QualificationInner inData :QualificationInnerObj){
                cObj.strOpCo = inData.strOpCo;
                cObj.dtDOB = inData.dtDOB;
                cObj.strAVCode = inData.strAVCode;
                cObj.strAVOwner = inData.strAVOwner;    
                break;
            }
            
            ChannelDataObj = FullSearchInnerObj.objChannelData;
            
            List<AcxiomClasses.Channel> ChannelObj = new List<AcxiomClasses.Channel>();
            ChannelObj = ChannelDataObj.aObjChannel;
            
            for(AcxiomClasses.Channel ch :ChannelObj){
                List<AcxiomClasses.ChannelLevel> ChannelLevelObj = new List<AcxiomClasses.ChannelLevel>();
                
                ChannelLevelObj = ch.aObjChannelLevel;
                
                if(!ChannelLevelObj.isEmpty() && ChannelLevelObj.size()>0){
                    for(AcxiomClasses.ChannelLevel chInner :ChannelLevelObj){
                        List<AcxiomClasses.AddressType> AddressTypeObj = new List<AcxiomClasses.AddressType>();
                        
                        AddressTypeObj = chInner.aObjAddressType;
                        
                        if(!AddressTypeObj.isEmpty() && AddressTypeObj.size()>0){
                            for(AcxiomClasses.AddressType  add :AddressTypeObj){
                                List<AcxiomClasses.contact> ContactInfoObj = new List<AcxiomClasses.contact>();
                                ContactInfoObj = add.aObjContactInfo;
                                
                                if(!ContactInfoObj.isEmpty() && ContactInfoObj.size()>0){
                                    for(AcxiomClasses.contact contactObj :ContactInfoObj){
                                        
                                        if(contactObj.strName == 'Title'){
                                            cObj.Title = contactObj.strValue;
                                        }else if(contactObj.strName == 'Fname'){
                                            cObj.Fname = contactObj.strValue;
                                        }else if(contactObj.strName == 'Lname'){
                                            cObj.Lname = contactObj.strValue;
                                        }else if(contactObj.strName == 'Addr1'){
                                            cObj.Addr1 = contactObj.strValue;
                                        }else if(contactObj.strName == 'City'){
                                            cObj.City = contactObj.strValue;
                                        }else if(contactObj.strName == 'State'){
                                            cObj.State = contactObj.strValue;
                                        }else if(contactObj.strName == 'Zip'){
                                            cObj.Zip = contactObj.strValue;
                                        }else if(contactObj.strName == 'Zip4'){
                                            cObj.Zip4 = contactObj.strValue;
                                        }                           
                                    }
                                }
                                break;
                                
                            }           
                        }
                        break;
                    
                    }
                }       
                break;
                
            }
        }else{
            log('devMessage: ' + strDevMessage);            
            
        }        
        System.debug('test cObj '+cObj);
        
        return cObj ;
     } 
     
     
     public AcxiomClasses.CCNLookupFinalResponse CCNLookupRequest(String strRequestBody){
        
        HttpRequest req = new HttpRequest();
        EndPointURL = '/altria/UAT/api/WebCCNLookup';
        req.setEndpoint(xxx_serviceBaseURL + EndPointURL);
        
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('vendor-cd', settings.Vendor_cd__c);
        req.setHeader('Authorization', currentToken.token_type+' '+currentToken.access_token);
        req.setHeader('website-id',  settings.Website_Id__c);
        req.setHeader('access-type-cd', settings.Access_type_cd__c);
        req.setHeader('channel-type-cd', settings.Channel_type_cd__c);
        req.setHeader('Host', settings.Host__c);

        req.setTimeout(getTimeOut());
        
        Http http = new Http();
        req.setBody(strRequestBody);
        
        logRequest(strRequestBody);
        
        HTTPResponse res = http.send(req);
        String strResponse = res.getBody();
        logResponse(strResponse);
        System.debug('test strResponse '+strResponse);
        AcxiomClasses.CCNLookupFinalResponse cObj = new AcxiomClasses.CCNLookupFinalResponse();
        
        AcxiomClasses.CCNLookupResponse response = (AcxiomClasses.CCNLookupResponse)Json.deserialize(strResponse, AcxiomClasses.CCNLookupResponse.class);
        System.debug('test response '+response);
        
        String strDevMessage = response.StatusData[0].StatusMessage;    
        
        cObj.StatusCode = response.StatusData[0].StatusCode;
        cObj.StatusMessage = response.StatusData[0].StatusMessage;
        cObj.ConsumerMessage =  response.StatusData[0].ConsumerMessage;
         cObj.RequestId = response.RequestId;
        log.Success__c = true;    
        if(String.isNotEmpty(strDevMessage) && strDevMessage.contains('SUCCESS')){   
        
            cObj.CCN = response.CCN;
            cObj.WinningCCN = response.WinningCCN;
                      
            
            AcxiomClasses.CCNLookupInner CCNLookupInnerObj = new AcxiomClasses.CCNLookupInner();
            AcxiomClasses.QualificationData QualificationDataObj = new AcxiomClasses.QualificationData();
            AcxiomClasses.ChannelData ChannelDataObj = new AcxiomClasses.ChannelData();
            AcxiomClasses.AuthenticationData AuthenticationDataObj = new AcxiomClasses.AuthenticationData();
            
            
            CCNLookupInnerObj = response.CcnLookup;
            
            
            AuthenticationDataObj  =  CCNLookupInnerObj.objAuthenticationData;
            
            cObj.strLexisNexisId = AuthenticationDataObj.strLexisNexisId;
            cObj.strConsumerAuthCd = AuthenticationDataObj.strConsumerAuthCd;
            
            
            QualificationDataObj = CCNLookupInnerObj.objQualificationData;
            
            List<AcxiomClasses.QualificationInner>  QualificationInnerObj = new List<AcxiomClasses.QualificationInner>();
            
            QualificationInnerObj = QualificationDataObj.aObjOpCoQualification;
            
            for(AcxiomClasses.QualificationInner inData :QualificationInnerObj){
                cObj.strOpCo = inData.strOpCo;
                cObj.dtDOB = inData.dtDOB;
                cObj.strAVCode = inData.strAVCode;
                cObj.strAVOwner = inData.strAVOwner;    
                break;
            }
            
            ChannelDataObj = CCNLookupInnerObj.objChannelData;
            
            List<AcxiomClasses.Channel> ChannelObj = new List<AcxiomClasses.Channel>();
            ChannelObj = ChannelDataObj.aObjChannel;
            
            for(AcxiomClasses.Channel ch :ChannelObj){
                List<AcxiomClasses.ChannelLevel> ChannelLevelObj = new List<AcxiomClasses.ChannelLevel>();
                
                ChannelLevelObj = ch.aObjChannelLevel;
                
                if(!ChannelLevelObj.isEmpty() && ChannelLevelObj.size()>0){
                    for(AcxiomClasses.ChannelLevel chInner :ChannelLevelObj){
                        List<AcxiomClasses.AddressType> AddressTypeObj = new List<AcxiomClasses.AddressType>();
                        
                        AddressTypeObj = chInner.aObjAddressType;
                        
                        if(!AddressTypeObj.isEmpty() && AddressTypeObj.size()>0){
                            for(AcxiomClasses.AddressType  add :AddressTypeObj){
                                List<AcxiomClasses.contact> ContactInfoObj = new List<AcxiomClasses.contact>();
                                ContactInfoObj = add.aObjContactInfo;
                                
                                if(!ContactInfoObj.isEmpty() && ContactInfoObj.size()>0){
                                    for(AcxiomClasses.contact contactObj :ContactInfoObj){
                                        
                                        if(contactObj.strName == 'Title'){
                                            cObj.Title = contactObj.strValue;
                                        }else if(contactObj.strName == 'Fname'){
                                            cObj.Fname = contactObj.strValue;
                                        }else if(contactObj.strName == 'Lname'){
                                            cObj.Lname = contactObj.strValue;
                                        }else if(contactObj.strName == 'Addr1'){
                                            cObj.Addr1 = contactObj.strValue;
                                        }else if(contactObj.strName == 'City'){
                                            cObj.City = contactObj.strValue;
                                        }else if(contactObj.strName == 'State'){
                                            cObj.State = contactObj.strValue;
                                        }else if(contactObj.strName == 'Zip'){
                                            cObj.Zip = contactObj.strValue;
                                        }else if(contactObj.strName == 'Zip4'){
                                            cObj.Zip4 = contactObj.strValue;
                                        }                           
                                    }
                                }
                                break;
                                
                            }           
                        }
                        break;
                    
                    }
                }       
                break;
                
            }
        }else{
            log('StatusMessage: ' + strDevMessage +' , ConsumerMessage:'+response.StatusData[0].ConsumerMessage);            
            
        }        
        System.debug('test cObj '+cObj);
        
        return cObj;
     }
     
     
    
    public class AcxiomCalloutException extends Exception{}    
    
}