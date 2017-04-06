public class ConsumerEntryController {
    public contact conObj {get;set;}
    public Boolean Customershow {get;set;}
    public Boolean readOnlyCityState{get;set;}
    public Id tranid {get;set;}
    public string message{get;set;}
    public string ziperror{get;set;}
    public string resultcode{get;set;}
    @TestVisible private string FormName;
    private Transaction_Management__c tranObj;
    public string fromPage{get;set;}
    public boolean isAgeVerificationReq{get;set;}
    public boolean dobEditable{get;set;}
    private boolean AVFFlag;
    Date currDOB;
    string oldZip;
    private Date oldDOB ; 
    
    public ConsumerEntryController (ApexPages.StandardController stdController){
        dobEditable = true;  
        isAgeVerificationReq = true;
        conObj = new Contact();
        fromPage = '';
        AVFFlag = false;
        this.conObj = (Contact)stdController.getRecord();
        Cookie counter = ApexPages.currentPage().getCookies().get('tranid');
        if(counter != null) {
            tranid = counter.getValue();
             if(conObj.id == null){
               String RecordTypeidObj = customerRecordTypeHelper.getCustomerRecordType(tranid);
               
               if(RecordTypeidObj != ''){
                   conObj.RecordTypeId = RecordTypeidObj;
               }
            }
       }
       
       id consumerRectype = Schema.SObjectType.contact.getRecordTypeInfosByName().get('Consumer').getRecordTypeId();
       if(conObj.RecordTypeId != consumerRectype){
            Customershow = false;
       }else{
            Customershow = true;
       }
        
       if(conObj.id == null){            
            if(conObj.RecordTypeId == consumerRectype)
                conObj.Customer_Type__c = 'CONSUMER';
       }
        
       init(); 
       if(conObj.id != null){
           Contact c = [Select id, Birthdate1__c,Zip_Code__c,Age_Verification_Source__c,AVF_GIID_Received__c from Contact where id =:conObj.id];
           if(c.Birthdate1__c != null){
               currDOB = c.Birthdate1__c;
           }
           if(c.Zip_Code__c !=  null && c.Zip_Code__c != ''){
               oldZip = c.Zip_Code__c;
           }
           AVFFlag = c.AVF_GIID_Received__c;
       }
            
       birthDate();
       getCurrCountry();
       
       
    }

     public void birthDate(){
        long age;
        if(conObj.id != null && currDOB != null){
           age = ((currDOB.daysBetween(system.TODAY())/365.2425)).round(System.RoundingMode.FLOOR);  
           if(age >= 18 && age <= 21){
                dobEditable = false;
           }else{
                dobEditable = true; 
           }
        }
     }
  
    
    //Metho to get the country for consumer.
    public void getCurrCountry(){
        if(conObj.Country__c == null || conObj.Country__c == '--None--' || conObj.Country__c == Label.Country){
            readOnlyCityState = true; 
            isAgeVerificationReq = true;
        }else{
            readOnlyCityState = false;   
            isAgeVerificationReq = false;
        }
        if(isAgeVerificationReq && conObj.Customer_Type__c != Label.CustomerType){
            isAgeVerificationReq = false;
        }
    }
    
   
    
    //Method to initialise all the parameters and fields for consumer record. 
    public void init(){
    
        if(ApexPages.currentPage().getParameters().get('from') != null && ApexPages.currentPage().getParameters().get('from') != '')
            fromPage =  ApexPages.currentPage().getParameters().get('from');  
        
        if(ApexPages.currentPage().getParameters().get('Fname') != null && ApexPages.currentPage().getParameters().get('Fname') != '')
            conObj.FirstName = ApexPages.currentPage().getParameters().get('Fname');            
        
        if(ApexPages.currentPage().getParameters().get('Lname') != null && ApexPages.currentPage().getParameters().get('Lname') != '')   
            conObj.LastName = ApexPages.currentPage().getParameters().get('Lname');
        
        if(ApexPages.currentPage().getParameters().get('Title') != null && ApexPages.currentPage().getParameters().get('Title') != '')
            conObj.Salutation = ApexPages.currentPage().getParameters().get('Title');
        
        if(ApexPages.currentPage().getParameters().get('Addr1') != null && ApexPages.currentPage().getParameters().get('Addr1') != '')
            conObj.Street_Address__c = ApexPages.currentPage().getParameters().get('Addr1');
        
        if(ApexPages.currentPage().getParameters().get('add') != null && ApexPages.currentPage().getParameters().get('add') != '')
            conObj.Street_Address__c = ApexPages.currentPage().getParameters().get('add');

        if(ApexPages.currentPage().getParameters().get('City') != null && ApexPages.currentPage().getParameters().get('City') != '')
            conObj.City__c = ApexPages.currentPage().getParameters().get('City');
    
        if(ApexPages.currentPage().getParameters().get('State') != null && ApexPages.currentPage().getParameters().get('State') != '')
            conObj.State__c = ApexPages.currentPage().getParameters().get('State');
        
        if(ApexPages.currentPage().getParameters().get('dob') != null && ApexPages.currentPage().getParameters().get('dob') != ''){
            string dob = ApexPages.currentPage().getParameters().get('dob');
            if(dob.indexOf('-') != -1){                
                String [] dobString = dob.split('T');
                String [] dobString1 = dobString[0].split('-');
                date d = Date.newInstance(Integer.ValueOf(dobString1[0]), Integer.ValueOf(dobString1[1]), Integer.ValueOf(dobString1[2]));
                conObj.Birthdate1__c = d;
                currDOB = d;
            }else{
                String [] dobString1 = dob.split('/'); 
                date d = Date.newInstance(Integer.ValueOf(dobString1[2]), Integer.ValueOf(dobString1[0]), Integer.ValueOf(dobString1[1]));
                conObj.Birthdate1__c = d;
                currDOB = d;
            }
        }
          
        if(ApexPages.currentPage().getParameters().get('zip') != null && ApexPages.currentPage().getParameters().get('zip') != '')
            conObj.Zip_Code__c = ApexPages.currentPage().getParameters().get('zip');
         
        if(ApexPages.currentPage().getParameters().get('CCN') != null && ApexPages.currentPage().getParameters().get('CCN') != '')
            conObj.CCN__c = ApexPages.currentPage().getParameters().get('CCN');
        
        if(ApexPages.currentPage().getParameters().get('avcode') != null && ApexPages.currentPage().getParameters().get('avcode') != '')
            conObj.AV_Code__c = ApexPages.currentPage().getParameters().get('avcode');
        
        if(conObj.id == null && conObj.AV_Code__c != null && conObj.AV_Code__c.trim() != '' && (conObj.AV_Code__c == '1' || conObj.AV_Code__c == '2' || conObj.AV_Code__c == '3')){
            conObj.Age_Verified_Date__c = date.today();  
            conObj.Age_Verification_Source__c = 'CCNLookup';
            conObj.AVF_GIID_Received__c = true;
            AVFFlag = true;
        }
        if(ApexPages.currentPage().getParameters().get('avowner') != null && ApexPages.currentPage().getParameters().get('avowner') != '')
            conObj.Operating_Company__c = ApexPages.currentPage().getParameters().get('avowner');
        
        
        if(ApexPages.currentPage().getParameters().get('email') != null && ApexPages.currentPage().getParameters().get('email') != '')
            conObj.Email = ApexPages.currentPage().getParameters().get('email');
        
        if(ApexPages.currentPage().getParameters().get('country') != null && ApexPages.currentPage().getParameters().get('country') != ''){
            conObj.Country__c = ApexPages.currentPage().getParameters().get('country');
        }
        
        if(ApexPages.currentPage().getParameters().get('phone') != null && ApexPages.currentPage().getParameters().get('phone') != '')
            conObj.Phone = ApexPages.currentPage().getParameters().get('phone');
            
        if(ApexPages.currentPage().getParameters().get('comName') != null && ApexPages.currentPage().getParameters().get('comName') != '')
            conObj.Company_Name__c =  ApexPages.currentPage().getParameters().get('comName'); 
        
        if(ApexPages.currentPage().getParameters().get('agentName') != null && ApexPages.currentPage().getParameters().get('agentName') != '')
            conObj.Company_Name__c =  ApexPages.currentPage().getParameters().get('agentName'); 
        
        if(ApexPages.currentPage().getParameters().get('DBA') != null && ApexPages.currentPage().getParameters().get('DBA') != '')
            conObj.DBA_Name__c =  ApexPages.currentPage().getParameters().get('DBA'); 
        
        if(ApexPages.currentPage().getParameters().get('accountNo') != null && ApexPages.currentPage().getParameters().get('accountNo') != '')
            conObj.Account_No__c =  ApexPages.currentPage().getParameters().get('accountNo'); 
        
        if(ApexPages.currentPage().getParameters().get('retail') != null && ApexPages.currentPage().getParameters().get('retail') != '')
            conObj.Retail_control__c =  ApexPages.currentPage().getParameters().get('retail'); 
        
        if(ApexPages.currentPage().getParameters().get('fSphone') != null && ApexPages.currentPage().getParameters().get('fSphone') != '')
            conObj.Phone =  ApexPages.currentPage().getParameters().get('fSphone'); 
        
        if(ApexPages.currentPage().getParameters().get('territory') != null && ApexPages.currentPage().getParameters().get('territory') != '')
            conObj.Territory__c =  ApexPages.currentPage().getParameters().get('territory'); 
        
        if(ApexPages.currentPage().getParameters().get('custType') != null && ApexPages.currentPage().getParameters().get('custType') != '')
            conObj.Customer_Type__c =  ApexPages.currentPage().getParameters().get('custType');
            
        if(tranid != null){
            tranObj = new Transaction_Management__c();
            tranObj = [Select id, Contact__c, Operating_Company__c, Operating_Company__r.OperatingCompany__c from Transaction_Management__c where id =:tranid];
            System.debug('test tranObj '+tranObj);
        }
       
    }
    
   //Get City and State based on postal code using Melissa webservice.
    public void getcitystate(){
        if(conObj.Country__c !=Label.Country){
            conObj.city__c = '';
            conObj.state__c = '';
        }
        if(conObj.Country__c ==Label.Country && conObj.Zip_Code__c!=null && oldZip != conObj.Zip_Code__c){
            conObj.city__c = '';
            conObj.state__c = '';
            if(conObj.Zip_Code__c.length() != 5 || !conObj.Zip_Code__c.isNumeric() || conObj.Zip_Code__c == '00000'){
                ApexPages.addMessage(new ApexPages.Message(apexpages.severity.Error, 'Please enter valid zip code.'));
                readOnlyCityState = true;
            }else {
                oldZip = conObj.Zip_Code__c;
                MelissaClasses.zipLookupResponse zipLookup = new MelissaClasses.zipLookupResponse();
                zipLookup = MelissaServices.ZipLookupServiceRequest(conObj.Zip_Code__c,tranid,FormName);
                
                if(zipLookup ==  null){
                    ApexPages.addMessage(new ApexPages.Message(apexpages.severity.Error, 'Server Error, Please enter the City and State'));
                    readOnlyCityState = false;
                }else{
                    if(zipLookup.ErrorString != null && zipLookup.ErrorString != ''){
                        ApexPages.addMessage(new ApexPages.Message(apexpages.severity.Error, 'Please enter valid zip code.'));
                        readOnlyCityState = true;
                      
                    }else{
                        if(!zipLookup.Results.isEmpty() && zipLookup.Results.size() >0){        
                        
                            conObj.city__c = zipLookup.Results[0].Address.City.toUpperCase();
                            conObj.state__c = zipLookup.Results[0].Address.State.toUpperCase();
                            
                            readOnlyCityState = true;
                            
                         }else{
                             ApexPages.addMessage(new ApexPages.Message(apexpages.severity.Error, 'Server Error, Please enter the City and State')); 
                             readOnlyCityState = false;                                               
                         }                        
                     }                     
                } 
            }
        } 
    }
    
    //Method to verify address using Melissa webservice.
    public void  getaddressverified(){
        if(conObj.Country__c == Label.Country){
            MelissaClasses.consumerAddressRequest addressdata = new MelissaClasses.consumerAddressRequest();
            addressdata.AddressLine1 = conObj.Street_Address__c;
            if(conObj.Apt_Lot__c != null && conObj.Apt_Lot__c != '')
                addressdata.AddressLine1 += ' ' +conObj.Apt_Lot__c;
            addressdata.AddressLine2 = '';
            addressdata.City = conObj.City__c;
            addressdata.State = conObj.State__c;
            addressdata.PostalCode = conObj.Zip_Code__c;
            addressdata.Country = conObj.Country__c;
            List<MelissaClasses.consumerAddressInnerResponse> addresp;
            addresp = MelissaServices.usaAddressRequest(addressdata,tranid,FormName);
            for(MelissaClasses.consumerAddressInnerResponse resultlist:addresp){
                message=resultlist.Message;
                resultcode=resultlist.ResultCode;
                if(resultcode=='Success'){
                    conObj.Address_Verified__c=true;
                    if(message!=''||message!=null){
                        ApexPages.addMessage(new ApexPages.Message(apexpages.severity.info, message));
                    }                        
                }else{
                    conObj.Address_Verified__c=false;
                    if(message!=''||message!=null){
                        ApexPages.addMessage(new ApexPages.Message(apexpages.severity.Error, message));
                    }else{
                        ApexPages.addMessage(new ApexPages.Message(apexpages.severity.Error, 'Server Error, Please try again!'));
                    }
                }
             }
        }
    }
    //fromPage
    public PageReference assignContactTransaction(){
        try{
            Cookie counter = ApexPages.currentPage().getCookies().get('tranid');
            if(counter != null) {
                tranid = counter.getValue();
                tranObj = [Select Id,Contact__c From Transaction_Management__c Where Id=: tranid];
                
                if(fromPage != null &&  fromPage == 'search'){
                    tranObj.Contact__c =  conObj.id;
                    update tranObj;
                    
                    List<Case> issueList = new List<Case>([Select id, ContactID,Contact_DOB__c,Contact_CCN_Number__c,Contact_Apt_Lot__c,Contact_Street_Address__c,
                                                           Contact_City__c,Contact_State__c, Contact_Country__c,Contact_Zip_Code__c   
                                                           from case 
                                                           where Transaction__c =:tranObj.id and ContactID = null]);
                    Contact conUpdateObj = [select id, BirthDate__c, CCN__c,Apt_Lot__c,City__c,Country__c,State__c,Street_Address__c,Zip_Code__c,Name,CustomerID__c from Contact where id = :conObj.id];    
                    if(!issueList.isEmpty() && issueList.size() >0){
                        for(case c :issueList){
                            c.ContactID = conObj.id;
                            
                            if(conUpdateObj.BirthDate__c != null && conUpdateObj.BirthDate__c != '')
                                c.Contact_DOB__c = conUpdateObj.BirthDate__c;
                            
                            if(conUpdateObj.CCN__c != null && conUpdateObj.CCN__c != '')    
                                c.Contact_CCN_Number__c = conUpdateObj.CCN__c; 
                            
                            if(conUpdateObj.Apt_Lot__c != null && conUpdateObj.Apt_Lot__c != ''){
                                c.Contact_Apt_Lot__c = conUpdateObj.Apt_Lot__c;
                            }   
                                        
                            if(conUpdateObj.Street_Address__c != null && conUpdateObj.Street_Address__c != ''){
                                c.Contact_Street_Address__c = conUpdateObj.Street_Address__c;                    
                            }
                            
                            if(conUpdateObj.City__c!= null && conUpdateObj.City__c != ''){
                                c.Contact_City__c = conUpdateObj.City__c;                    
                            }
                            
                            if(conUpdateObj.State__c != null && conUpdateObj.State__c!= ''){
                                c.Contact_State__c = conUpdateObj.State__c;                    
                            }
                              
                            if(conUpdateObj.Country__c != null && conUpdateObj.Country__c != ''){
                                c.Contact_Country__c = conUpdateObj.Country__c;                    
                            }
                            
                            if(conUpdateObj.Zip_Code__c  != null && conUpdateObj.Zip_Code__c != ''){
                                c.Contact_Zip_Code__c = conUpdateObj.Zip_Code__c ;                   
                            }
                        }
                        update issueList;
                        if(issueList.size() > 1){
                        conObj.Repeat_Complainer__c = true;
                        if(conObj.Repeat_Complainer_Date__c == null){
                            conObj.Repeat_Complainer_Date__c = System.today();
                        }
                        update conObj;
                        system.debug('---conObj.Repeat_Complainer__c----'+conObj.Repeat_Complainer__c);
                    }
                    }
                }
            }
            PageReference pg=new PageReference ('/apex/ConsumerDetailPage?id='+conObj.id);
            pg.setRedirect(true);
            return pg;
            
        }catch(DMLException e){
            ApexPages.addMessages(e);
            return null;
        }
    
    }   
    
    //Method to save the consumer record.
    public PageReference save(){
        try{
            Cookie counter = ApexPages.currentPage().getCookies().get('tranid');
            if(counter != null) {
                tranid = counter.getValue();
                tranObj = [Select Id,Contact__c From Transaction_Management__c Where Id=: tranid];
            }
            if(conObj.Country__c==Label.Country && conObj.Customer_Type__c   != Label.Field_Sales_Force){ 
                if(conObj.Zip_Code__c != null && conObj.Zip_Code__c != '' && (conObj.Zip_Code__c.length() != 5 || !conObj.Zip_Code__c.isNumeric() || conObj.Zip_Code__c == '00000')){ 
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter valid zip code'));
                    return null;
                }
                if(oldZip != conObj.Zip_Code__c){            
                    getcitystate();                
                    if(ApexPages.hasmessages(ApexPages.severity.ERROR)){
                            return null;
                    }           
                }                
            }
            
            if(conObj.Customer_Type__c  != null && !Customershow){
                conObj.FirstName = 'Trade';
                conObj.LastName = 'Customer'; 
                if(conObj.Customer_Type__c    == Label.Field_Sales_Force){
                    conObj.Street_Address__c = ' ';
                    conObj.City__c = ' ';
                    conObj.State__c = ' ';
                    conObj.Country__c = ' ';
                    conObj.Zip_Code__c = ' ';
               }   
            }
            
            if(Label.CustomerType != conObj.Customer_Type__c){
                conObj.Birthdate1__c = null;
                conObj.Birthdate__c = '';
                conObj.AVF_GIID_Received__c = false;
            }
            
            if(Customershow && conObj.id == null){
            
                if(conObj.AV_Code__c != null && conObj.AV_Code__c.trim() != '' && (conObj.AV_Code__c == '1' || conObj.AV_Code__c == '2' || conObj.AV_Code__c == '3')){
                    conObj.Age_Verified_Date__c = date.today();  
                    conObj.Age_Verification_Source__c = 'CCNLookup';
                    conObj.AVF_GIID_Received__c = true;
                    AVFFlag = true;
                }
                
                Transaction_Management__c tran = new Transaction_Management__c();
                tran =  [Select id, Operating_Company__c, Operating_Company__r.OperatingCompany__c from Transaction_Management__c where id =:tranid];
                
                if(tran.id != null && (conObj.Operating_Company__c == null || conObj.Operating_Company__c == ''))
                    conObj.Operating_Company__c = tran.Operating_Company__r.OperatingCompany__c;
            }
            
            if(conObj.Birthdate1__c !=NULL){
                String dateOutput = conObj.Birthdate1__c.format();
                conObj.Birthdate__c=dateOutput;
                
                if(!conObj.AVF_GIID_Received__c){
                    conObj.Age_Verification_Source__c = null;
                    conObj.Age_Verified_Date__c = null;
                }
                if(conObj.AVF_GIID_Received__c && !AVFFlag ){
                    conObj.Age_Verification_Source__c = 'GIID';
                    conObj.Age_Verified_Date__c = date.today();
                }
                if(currDOB != conObj.Birthdate1__c){
                    conObj.AVF_GIID_Received__c = false;
                    conObj.Age_Verification_Source__c = null;
                    conObj.Age_Verified_Date__c = null;
                }            
            }else{
                conObj.AVF_GIID_Received__c = false;
                conObj.Age_Verification_Source__c = null;
                conObj.Age_Verified_Date__c = null;
            }
            if(conObj.id==null){
                if(tranObj.Contact__c != null){
                    if(Customershow)
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Consumer already associated with current transaction.'));
                    else
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Trade Customer already associated with current transaction.'));
                    return null;
                }
            }else{
                if(tranObj.Contact__c != null && tranObj.Contact__c != conObj.id){
                    if(Customershow)
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Consumer already associated with current transaction.'));
                    else
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Trade Customer already associated with current transaction.'));
                    return null;
                }
            }
            if(conObj.id==null){ 
                system.debug('-------conObj insert-------'+conObj.RecordTypeId);
                 
                Database.SaveResult saveRst = Database.insert(conObj);
                tranObj.Contact__c =  conObj.id;
                update tranObj;
                if(saveRst.isSuccess()){
                    TransactionMgmtHelper mgmtHelper = new TransactionMgmtHelper();
                    mgmtHelper.createTransactionMgmtHistoryRecord('CREATECUST',String.valueOf(saveRst.getId()));
                }
                List<Case> issueList = new List<Case>([Select id, ContactID,Contact_DOB__c,Contact_CCN_Number__c,Contact_Apt_Lot__c,Contact_Street_Address__c,
                                                       Contact_City__c,Contact_State__c, Contact_Country__c,Contact_Zip_Code__c                
                                                       from case where Transaction__c =:tranObj.id and ContactID = null]);
                Contact conUpdateObj = [select id, BirthDate__c, CCN__c,Apt_Lot__c,City__c,Country__c,State__c,Street_Address__c,Zip_Code__c,Name,CustomerID__c from Contact where id = :conObj.id];
                if(!issueList.isEmpty() && issueList.size() >0){
                    for(case c :issueList){
                        c.ContactID = conObj.id;                         
           
                        if(conUpdateObj.BirthDate__c != null && conUpdateObj.BirthDate__c != '')
                            c.Contact_DOB__c = conUpdateObj.BirthDate__c;
                            
                        if(conUpdateObj.CCN__c != null && conUpdateObj.CCN__c != '')    
                            c.Contact_CCN_Number__c = conUpdateObj.CCN__c; 
                        
                        if(conUpdateObj.Apt_Lot__c != null && conUpdateObj.Apt_Lot__c != ''){
                            c.Contact_Apt_Lot__c = conUpdateObj.Apt_Lot__c;
                        }   
                                    
                        if(conUpdateObj.Street_Address__c != null && conUpdateObj.Street_Address__c != ''){
                            c.Contact_Street_Address__c = conUpdateObj.Street_Address__c;                    
                        }
                        
                        if(conUpdateObj.City__c!= null && conUpdateObj.City__c != ''){
                            c.Contact_City__c = conUpdateObj.City__c;                    
                        }
                        
                        if(conUpdateObj.State__c != null && conUpdateObj.State__c!= ''){
                            c.Contact_State__c = conUpdateObj.State__c;                    
                        }
                        
                        if(conUpdateObj.Country__c != null && conUpdateObj.Country__c != ''){
                            c.Contact_Country__c = conUpdateObj.Country__c;                    
                        }
                        
                        if(conUpdateObj.Zip_Code__c  != null && conUpdateObj.Zip_Code__c != ''){
                            c.Contact_Zip_Code__c = conUpdateObj.Zip_Code__c ;                   
                        }
                    }
                    update issueList;
                    system.debug('---issueList.size()----'+issueList.size());
                    if(issueList.size() > 1){
                        conObj.Repeat_Complainer__c = true;
                        if(conObj.Repeat_Complainer_Date__c == null){
                            conObj.Repeat_Complainer_Date__c = System.today();
                        }
                        update conObj;
                        system.debug('---conObj.Repeat_Complainer__c----'+conObj.Repeat_Complainer__c);
                    }
                }
            }else{ 
                system.debug('-------conObj update-------'+conObj.RecordTypeId);
                Database.UpsertResult upsRst = Database.upsert(conObj);
                
                if(upsRst.isSuccess()){
                    TransactionMgmtHelper mgmtHelper = new TransactionMgmtHelper();
                    if(upsRst.isCreated()){
                        mgmtHelper.createTransactionMgmtHistoryRecord('CREATECUST',String.valueOf(upsRst.getId()));
                    }else{
                        mgmtHelper.createTransactionMgmtHistoryRecord('UPDATECUST',String.valueOf(upsRst.getId()));
                    }
                }
            }    
            
            PageReference pg=new PageReference ('/apex/ConsumerDetailPage?id='+conObj.id);
            pg.setRedirect(true);
            return pg;
        }
        catch(DMLException e){
            ApexPages.addMessages(e);
            return null;
        }
    } 
    
    public PageReference cancelRedirect(){   
        PageReference pageRef = new PageReference('/apex/ConsumerDetailPage?id='+conObj.Id);
        pageRef.setRedirect(true);
        return pageRef;             
    } 
}