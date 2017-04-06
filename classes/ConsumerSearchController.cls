//Search Page for Consumer

public class ConsumerSearchController {    
   
    public Id tranid{get;set;}    
    public string issueid {get;set;}
    public string tranSelectedValue {get;set;}
    public Contact conObj{get;set;}    
    public List<Contact> conlst{get;set;}
    public Boolean isConsumerBtnVisible{get;set;}
    public Boolean isIssueBtnVisible{get;set;}
    public Boolean RadioDisplay{get;set;}
    public Boolean isAgeZipMappingVerified{get;set;}
    public Boolean readOnlyCityState{get;set;}
    AcxiomClasses.ConsumerFinalResponse searchResponseData; 
    @TestVisible String FormName;
    public Boolean isSearch {get;set;}
    public Transaction_Management__c tranObj{get;set;}
    private string customerNumber;
    
    public ConsumerSearchController(ApexPages.StandardController stdController) {       
        isConsumerBtnVisible=true;
        isIssueBtnVisible = true;
        isSearch = false;
        RadioDisplay = false;
        isAgeZipMappingVerified = false;
        readOnlyCityState = true;
        conObj=(contact)stdController.getRecord();
        conObj.Country__c = 'United States';
        customerNumber = '';
        conlst=new List<Contact>();              
        Cookie counter = ApexPages.currentPage().getCookies().get('tranid');
        if(counter != null) {
            tranid = counter.getValue();
            tranObj = new Transaction_Management__c();
            tranObj = [Select id, Contact__c,Operating_Company__c from Transaction_Management__c where id =:tranid];           
            String RecordTypeidObj = customerRecordTypeHelper.getCustomerRecordType(tranid );               
            if(RecordTypeidObj != ''){
               conObj.RecordTypeId = RecordTypeidObj;
            }
            if(ApexPages.currentPage().getParameters().get('customerNumber') != null && ApexPages.currentPage().getParameters().get('customerNumber') != ''){
                customerNumber = ApexPages.currentPage().getParameters().get('customerNumber');
                conObj.Phone = customerNumber;
                conObj.Country__c = null;
                isConsumerBtnVisible = true;
                isIssueBtnVisible = true;
                Search();
            }
        }
        FormName='ConsumerSearch';        
    }
      
    //Acxiom Full Search.   
    public void getfullsearchList(){
        isAgeZipMappingVerified =false;
        AcxiomClasses.FullSearchLookupRequest searchRequest=new AcxiomClasses.FullSearchLookupRequest();
        searchRequest.OwnerCd='';
        searchRequest.ListCd='';
        searchRequest.Title='';
        searchRequest.FirstName=conObj.FirstName;
        searchRequest.MiddleName='';
        searchRequest.LastName=conObj.LastName;
        searchRequest.Suffix='';
        Datetime yourDate = conObj.BirthDate1__c;
        String dateOutput = yourDate.format('MM/dd/YYYY');
        searchRequest.DateOfBirth=dateOutput;        
        AcxiomClasses.AddressRequest addRequest=new AcxiomClasses.AddressRequest();
        addRequest.AddressLine1=conObj.Street_Address__c;
        addRequest.AddressLine2='';
        addRequest.City=conObj.city__c;
        addRequest.State=conObj.state__c;
        addRequest.Zip=conObj.Zip_Code__c;
        addRequest.ZipPlus4='';
        searchRequest.Address = addRequest;
        searchResponseData = new AcxiomClasses.ConsumerFinalResponse();
        searchResponseData=AcxiomServices.FullSearchLookupRequest(searchRequest,tranid,FormName);
        system.debug('FullSearchResponse----:'+searchResponseData);
        if(searchResponseData.RequestId == null || searchResponseData.RequestId == ''){
            ApexPages.addMessage(new ApexPages.Message(apexpages.severity.Error,'Server Error, Please try again'));
        }else if(searchResponseData.CCN == ''){
            ApexPages.addMessage(new ApexPages.Message(apexpages.severity.Error,searchResponseData.ConsumerMessage));
        }else{
             if(searchResponseData.StatusCode!=null && searchResponseData.StatusCode != ''){
                if(searchResponseData.StatusCode != '0000' && searchResponseData.StatusCode != '000'){
                    StatusCodeFullSearch__c code =StatusCodeFullSearch__c.getValues(searchResponseData.StatusCode);
                    AdminAlertEmail__c AEmail = AdminAlertEmail__c.getInstance('Admin1');
                    if(code != null){
                        if(AEmail!= Null){
                            String[] toAddresses = new String[] {AEmail.AdminEmail__c};
                            Messaging.SingleEmailMessage singleMail = new Messaging.SingleEmailMessage();
                            singleMail.setSubject('Full Search staus and description.');
                            singleMail.setToAddresses(toAddresses);        
                            string body = '<p> Please find the Full Search Status Code,Status Message and Description below: </p>';
                            body+='</br>Status Code:'+searchResponseData.StatusCode;                    
                            body+='</br>Status Message :'+code.Status__c;
                            body+='</br>Description:'+code.Description__c;                    
                            body +='</br>Thank you';
                            singleMail.setHtmlBody(body);
                            Messaging.sendEmailResult[] res = Messaging.sendEmail(new Messaging.singleEmailMessage[]{singleMail}); 
                        }
                    }
                }
            }            
        }
        
        TransactionMgmtHelper mgmtHelper = new TransactionMgmtHelper();
        mgmtHelper.createTransactionMgmtHistoryRecord('FULL_SEARCH','');
        searchResult(searchResponseData);
    }

    //Display Search Result, retrieved from Acxiom full search.
    public List<contact> searchResult( AcxiomClasses.ConsumerFinalResponse searchResponseData1){
        Contact con=new Contact();
        con.RequestId__c=searchResponseData1.RequestId;
        con.StatusCode__c=searchResponseData1.StatusCode;
        con.StatusMessage__c=searchResponseData1.StatusMessage;     
        conlst.add(con);
        if(searchResponseData1.CCN == null || searchResponseData1.CCN == ''){          
            conlst.clear(); 
        }else{
            con.FirstName=searchResponseData1.Fname;
            con.LastName=searchResponseData1.Lname;
            con.City__c=searchResponseData1.city;
            con.State__c=searchResponseData1.state;
            con.Zip_Code__c=searchResponseData1.zip;
            con.Street_Address__c=searchResponseData1.Addr1;
            con.ccn__c=searchResponseData1.CCN;
            if(searchResponseData1.dtDOB != null && searchResponseData1.dtDOB != ''){
                String [] dobString= searchResponseData1.dtDOB.split('T');
                String [] dobString1 =dobString[0].split('-'); 
                date d = Date.newInstance(Integer.ValueOf(dobString1[0]), Integer.ValueOf(dobString1[1]), Integer.ValueOf(dobString1[2]));
                con.Birthdate1__c = d;
            }
        }  
        return conlst;
    }
    
    //clear Search result.
    public PageReference Clear() {
        issueid = '';
        isConsumerBtnVisible = true;
        isIssueBtnVisible  = true;
        isSearch  = false;
        RadioDisplay = false;
        tranSelectedValue  = '';
        conObj = new Contact();
        conlst.clear(); 
        conObj.Country__c = 'United States'; 
        readOnlyCityState = true; 
        return null;
    }
    
    //Method to call Melissa webservice to get state and city for a zip.
    public PageReference getCityState(){
        conObj.city__c = '';
        conObj.state__c = '';
        if(conObj.Country__c != Label.Country){
            readOnlyCityState = false;
        }
        if(conObj.Country__c == Label.Country && conObj.Zip_Code__c != null && conObj.Zip_Code__c != ''){
            if(conObj.Zip_Code__c.length() != 5 || !conObj.Zip_Code__c.isNumeric() ||  conObj.Zip_Code__c == '00000'){
                ApexPages.addMessage(new ApexPages.Message(apexpages.severity.Error, 'Please enter valid zip code.'));
                readOnlyCityState = true;
                return null;   
            }
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
                        if(conObj.Zip_Code__c != null && conObj.Zip_Code__c != '' && conObj.State__c != null && conObj.State__c != '' && conObj.Birthdate1__c != null){
                            ageVerifyZipMap(); 
                        }
                    }else{
                        ApexPages.addMessage(new ApexPages.Message(apexpages.severity.Error, 'Server Error, Please enter the City and State')); 
                        readOnlyCityState = false;                                               
                    }                        
                }                     
            } 
        }                
        return null;   
    }
    
    //Method to verify the Consumer based on the Age-Zip mapping.
    public void ageVerifyZipMap(){
        if(conObj.Zip_Code__c != null && conObj.State__c != null && conObj.State__c != '' && conObj.Birthdate1__c != null){
            ageMapping obj = new ageMapping();
            ageMapping.ageData ageObj = new ageMapping.ageData();
            ageObj = obj.FetchDataZip(conObj.Zip_Code__c, conObj.State__c, conObj.Birthdate1__c); 
            if(!ageObj.AgeVerify){                
               if(ageObj.StateAge == null)
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Age Zip/State Mapping Missing'));
               else
                   ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Consumer did not meet minimum age requirement. Consumer  age is '+ageObj.ConsumerAge +', the age restriction for the state/zip code is '+ ageObj.StateAge +'.  No action should be taken in the system.')); 
               isConsumerBtnVisible=true;
               isIssueBtnVisible = true;        
            }else{
                if(isSearch){
                    isConsumerBtnVisible=false;
                }               
                isIssueBtnVisible = false;            
            }
        }
    }
    
    //Method to perform local search.
    public PageReference Search(){
        conlst.clear(); 
        RadioDisplay = false;
        try{
        if(checkContact()){
            return null;
        }
        
        if(conObj.Country__c != null && conObj.Country__c == Label.Country && conObj.Zip_Code__c != null && conObj.Zip_Code__c != '' && (conObj.Zip_Code__c.length() != 5 || !conObj.Zip_Code__c.isNumeric() ||  conObj.Zip_Code__c == '00000')){
            ApexPages.addMessage(new ApexPages.Message(apexpages.severity.Error, 'Please enter valid zip code.'));
            readOnlyCityState = true;
            return null;   
        }        
        
        if(conObj.LastName != null && conObj.LastName != '' && conObj.LastName.length()< 3){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please Enter at least 3 characters for Last Name.'));
            return null;
        }
        
        if(conObj.CCN__c != null && conObj.CCN__c!='' && conObj.CCN__c.length()<3){
           ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter valid CCN #.'));
            return null; 
        }
        
        if(conObj.Phone != null && conObj.Phone.length()<10 && conObj.Phone!=''){            
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Not a valid 10-digit phone number.'));
            return null;            
        }
        
        if(conObj.email != null &&  conObj.email!='' && !Pattern.matches('[a-zA-Z0-9._-]+@[a-zA-Z]+.[a-zA-Z]{2,4}[.]{0,1}[a-zA-Z]{0,2}', conObj.email))
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Please enter valid email')); 
            return null;
        }
        
        String query = 'select id,Name,CustomerID__c, Email,FirstName,LastName,ccn__c,phone,MobilePhone,OtherPhone,zip_code__c,Street_Address__c,State__c, City__c,Country__c,BirthDate1__c from Contact ';    
        String queryCondition = '';
        if((conObj.CustomerID__c == null || conObj.CustomerID__c == '') && (conObj.ccn__c == null || conObj.ccn__c == '') && (conObj.Email == null || conObj.Email == '')&&(conObj.Phone == null || conObj.Phone == '') && (issueid == null || issueid == '') && (tranSelectedValue == null || tranSelectedValue == '')&& (conObj.LastName == null || conObj.LastName == '' || conObj.BirthDate1__c == null) && (conObj.LastName == null || conObj.LastName == '' || conObj.Zip_Code__c == null || conObj.Zip_Code__c == '')){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Missing Mandatory Fields: Please enter LN-Zip Code, LN-DOB, Issue #, CCN #, Customer ID, Phone #,Transaction #, or Email Address'));
            return null;
        }else{
            isSearch = true;
            if(conObj.Country__c == Label.Country){
                ageVerifyZipMap();
            }else if(conObj.Country__c != null){
                isConsumerBtnVisible = false;
                isIssueBtnVisible = false;
            }
            String ConsumerId = '';
            String ConName = '';
            string soslCondition = '';
            if(issueid != null && issueid != ''){
                List<Case> caseObj = new List<Case>([Select id, Contactid, Contact.Name, Contact.CustomerID__c from Case where CaseNumber like: '%'+issueid]);
                if(!caseObj.isEmpty() && caseObj.size() >0 && caseObj[0].Contactid != null){
                   ConsumerId = caseObj[0].Contact.CustomerID__c;
                   ConName = caseObj[0].Contact.Name;
                }            
            }
            
            if(tranSelectedValue != null && tranSelectedValue != ''){
                List<Transaction_Management__c> transactionObj = new List<Transaction_Management__c>([Select id, Contact__c, Contact__r.Name, Contact__r.CustomerID__c from Transaction_Management__c where Name like: '%'+tranSelectedValue]);
                if(!transactionObj.isEmpty() && transactionObj.size() >0 && transactionObj[0].Contact__c != null){
                   ConsumerId = transactionObj[0].Contact__r.CustomerID__c;
                   ConName = transactionObj[0].Contact__r.Name;
                }                
            }
            string whereCondition = '';
            if(ConsumerId != null && ConsumerId != ''){
                soslCondition = ConName; 
                whereCondition = ' Where CustomerID__c = \'' + ConsumerId+ '\'';
            }           
        
            if(conObj.ccn__c != null && conObj.ccn__c != ''){
                if(soslCondition != '') {soslCondition += ' AND '+conObj.ccn__c;}
                else{soslCondition = conObj.ccn__c;}
            }            
            
            if(conObj.Phone != null && conObj.Phone != ''){
                if(soslCondition != '') {soslCondition += ' AND '+conObj.phone;}
                else {soslCondition += conObj.phone;}
            }
            
            if(conObj.FirstName  != null && conObj.FirstName  != ''){
                if(soslCondition != '') {soslCondition += ' AND '+conObj.FirstName+'%';}
                else {soslCondition = conObj.FirstName+'%';}
            }
            
            if(conObj.LastName  != null && conObj.LastName  != ''){
                if(soslCondition != '') {soslCondition += ' AND '+conObj.LastName+'%';}
                else {soslCondition = conObj.LastName+'%';}
            }
            
            if(conObj.Zip_Code__c != null && conObj.Zip_Code__c != ''){
                if(soslCondition != '') {soslCondition += ' AND '+conObj.Zip_Code__c ;}
                else {soslCondition += conObj.Zip_Code__c ;}
            }
            
            if(conObj.Street_Address__c != null && conObj.Street_Address__c != ''){
                if(soslCondition != '') {soslCondition += ' AND '+conObj.Street_Address__c ;}
                else {soslCondition += conObj.Street_Address__c ;}
            }
            
            if(conObj.Email != null && conObj.Email != ''){
                if(soslCondition != '') {soslCondition += ' AND '+conObj.Email ;}
                else {soslCondition += conObj.Email ;}
            }
            
            if(conObj.Country__c != null && conObj.Country__c != ''){
                if(whereCondition != '') {whereCondition +=  ' and Country__c = \'' + conObj.Country__c + '\'';}
                else {whereCondition =  ' Where Country__c = \'' + conObj.Country__c + '\'';}
            }
            if(conObj.BirthDate1__c != null){
                Date yourDate = conObj.Birthdate1__c;
                String dateOutput = yourDate.format();
                if(soslCondition != '') {soslCondition += ' AND '+dateOutput ;}
                else {soslCondition += dateOutput  ;}
            }
            
            if(conObj.CustomerID__c != null && conObj.CustomerID__c != '' ){
                if(soslCondition == null || soslCondition == ''){
                    List<Contact> conObj = new List<Contact>([Select Name from Contact where CustomerID__c like : '%'+conObj.CustomerID__c]);
                    if(!conObj.isEmpty() && conObj.size() >0){
                       soslCondition = conObj[0].Name;
                    }
                }             
                string customeridstr = '%'+conObj.CustomerID__c;
                if(whereCondition != '') {whereCondition +=  ' and CustomerID__c like \'' + customeridstr + '\'';}
                else {whereCondition =  ' Where CustomerID__c like \'' + customeridstr + '\'';}
            }
            
            if(whereCondition != ''){
                whereCondition +=  ' and RecordType.Name = \'Consumer\' and Active__c = true ';
            }else{
                whereCondition =  ' Where RecordType.Name = \'Consumer\' and Active__c = true ';
            }

            if(soslCondition != null && soslCondition != ''){
                if(soslCondition.trim().length() < 3 ){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter valid data'));
                    return null;
                }
                System.debug('test soslCondition 1'+soslCondition);
                soslCondition = escapeMetaCharacters(soslCondition); 
                System.debug('test soslCondition 2'+soslCondition);
                string searchQuery = 'FIND {'+ soslCondition +'} IN ALL FIELDS ';
                searchQuery += 'RETURNING Contact(id,Name,CustomerID__c,Email,CCN__c,Customer_Type__c,FirstName,LastName,phone,MobilePhone,OtherPhone,zip_code__c,Street_Address__c,State__c, City__c,Country__c,Birthdate1__c';
                if(whereCondition  != null && whereCondition != '')
                    searchQuery += whereCondition ; 
                searchQuery += ')';
                System.debug('test '+searchQuery );
                List<List <sObject>> searchList = search.query(searchQuery);
                List<Contact> contactData= ((List<contact>)searchList[0]);      
                 System.debug('test '+contactData);        
                if(!contactData.isEmpty()){
                    for(Contact con :contactData){
                        Contact conInner = con;
                        if(conObj.FirstName  != null && conObj.FirstName  != ''){
                            if(conObj.FirstName == conInner.FirstName)
                                conInner = con;
                            else
                                conInner = new Contact();
                        }
                        
                        if(conObj.LastName  != null && conObj.LastName  != '' && conInner.id != null){
                            if(conObj.LastName == conInner.LastName)
                                conInner = con;
                            else
                                conInner = new Contact();
                        }
                        
                        if(conObj.Country__c  != null && conObj.Country__c  != '' && conInner.id != null){
                            if(conObj.Country__c == conInner.Country__c)
                                conInner = con;
                            else
                                conInner = new Contact();
                        }
                        
                        if(conObj.Email  != null && conObj.Email  != '' && conInner.id != null){
                            if(conObj.Email == conInner.Email)
                                conInner = con;
                            else
                                conInner = new Contact();
                        }
                        
                        if(conObj.Street_Address__c  != null && conObj.Street_Address__c  != '' && conInner.id != null){
                            if(conObj.Street_Address__c == conInner.Street_Address__c)
                                conInner = con;
                            else
                                conInner = new Contact();
                        }
                        
                        if(conObj.Zip_Code__c  != null && conObj.Zip_Code__c  != '' && conInner.id != null){
                            if(conObj.Zip_Code__c == conInner.Zip_Code__c)
                                conInner = con;
                            else
                                conInner = new Contact();
                        }
                        
                        if(conObj.Phone  != null && conObj.Phone  != '' && conInner.id != null){
                           // if(conInner.Phone != null)
                             //   conInner.Phone = conInner.Phone.replaceAll('[^0-9]','');
                            //if(conObj.Phone == conInner.Phone)
                                conInner = con;
                            //else
                               //conInner = new Contact();
                        }
                        
                        if(conObj.ccn__c  != null && conObj.ccn__c  != '' && conInner.id != null){
                            if(conObj.ccn__c == conInner.ccn__c)
                                conInner = con;
                            else
                                conInner = new Contact();
                        }
                        
                        if(conObj.BirthDate1__c != null && conInner.id != null){
                            if(conObj.BirthDate1__c == conInner.BirthDate1__c)
                                conInner = con;
                            else
                                conInner = new Contact();
                        }
                        
                        if(conInner.id != null){
                            conlst.add(conInner);
                        }
                    }
                }
            }
            if(conlst.isEmpty() || conlst.Size() == 0){               
                if(conObj.Country__c == 'United States'){
                    if(conObj.FirstName == null || conObj.FirstName == ''  || conObj.LastName == null || conObj.LastName == '' || conObj.Zip_Code__c == null || conObj.Zip_Code__c == '' ||  conObj.Street_Address__c ==  null || conObj.Street_Address__c == '' || conObj.BirthDate1__c == null || conObj.city__c == null || conObj.city__c == '' || conObj.state__c == null || conObj.state__c == ''){
                        ApexPages.addMessage(new ApexPages.Message(apexpages.severity.Error, 'No Consumer Information found in Local CRC Database. Please enter FN, LN, DOB, Zip Code, Street Address, City, and State for an Extended Search.'));
                    }else{
                        conlst.clear();   
                        getfullsearchList();
                        if(conlst.isEmpty() || conlst.Size() == 0){
                            RadioDisplay=false;                    
                            ApexPages.addMessage(new ApexPages.Message(apexpages.severity.info, 'No record found, Please create new consumer.'));
                        }else{
                            RadioDisplay=false;
                        }
                    }  
                }else{
                     ApexPages.addMessage(new ApexPages.Message(apexpages.severity.info, 'No record found, Please create new consumer.'));
                }              
                return null;
            }
            else if (conlst.Size() > 999){
                conlst.clear();
                RadioDisplay=false;
                ApexPages.addMessage(new ApexPages.Message(apexpages.severity.info, 'Too many search results found (over 1,000), please enter in more search criteria to narrow search results'));
                return null;
            }else{
                RadioDisplay=true;
                return null;
            }
        }
        }catch(Exception ex){
            System.debug('test '+ex.getLineNumber());
        }
        return null;
    }
    
    public String escapeMetaCharacters(String inputString){
        
        List<String> metaCharacters = new List<String>();
        
        metaCharacters.add('\\');metaCharacters.add('^');
        metaCharacters.add('$');metaCharacters.add('{');
        metaCharacters.add('}');metaCharacters.add('.');
        metaCharacters.add('[');metaCharacters.add(']');
        metaCharacters.add('(');metaCharacters.add(')');
        metaCharacters.add('*');metaCharacters.add('+');
        metaCharacters.add('?');metaCharacters.add('|');
        metaCharacters.add('<');metaCharacters.add('>');
        metaCharacters.add('-');metaCharacters.add('&');
        
        for (Integer i = 0 ; i < metaCharacters.size(); i++){
            if(inputString.contains(metaCharacters[i])){
                inputString= inputString.replace(metaCharacters[i],'\\'+metaCharacters[i]);
            }
        }
        return inputString;
    }
    
    //Method that is called remotely to call the CCN Lookup service to get the consumer details from Axciom.
    @RemoteAction
    public static AcxiomClasses.CCNLookupFinalResponse CCNLookup(string CCNNumber, string tranidData){
        
        AcxiomClasses.CCNLookupRequest cc = new AcxiomClasses.CCNLookupRequest();
        cc.CCN = CCNNumber;
        System.debug('CCNNumber'+CCNNumber);
        AcxiomClasses.CCNLookupFinalResponse responseCNN = new AcxiomClasses.CCNLookupFinalResponse();
        responseCNN =  AcxiomServices.CCNLookupRequest(cc,CCNNumber,tranidData,'ConsumerSearch');
        responseCNN.showLocalData = false;        
        if(responseCNN.StatusCode!=null && responseCNN.StatusCode != ''){
            if(responseCNN.StatusCode != '0000' && responseCNN.StatusCode != '000' && responseCNN.StatusCode != '010'){
                StatusCodeCCN__c code =StatusCodeCCN__c.getValues(responseCNN.StatusCode);
                System.debug('test code '+code);
                AdminAlertEmail__c AEmail = AdminAlertEmail__c.getInstance('Admin1');
                if(code != null){
                    if(AEmail!= Null){
                        String[] toAddresses = new String[] {AEmail.AdminEmail__c};
                        Messaging.SingleEmailMessage singleMail = new Messaging.SingleEmailMessage();
                        singleMail.setSubject('CCN Lookup staus and description.');
                        singleMail.setToAddresses(toAddresses);        
                        string body = '<p> Please find the CCN Status Code,Status Message and Description below: </p>';
                        body+='</br>Status Code:'+responseCNN.StatusCode;  
                        if(code.Status__c !=  null && code.Status__c !=  '')                  
                        body+='</br>Status Message :'+code.Status__c;
                        if(code.Description__c !=  null && code.Description__c !=  '')   
                        body+='</br>Description:'+code.Description__c;                    
                        body +='</br>Thank you';
                        singleMail.setHtmlBody(body);
                        Messaging.sendEmailResult[] res = Messaging.sendEmail(new Messaging.singleEmailMessage[]{singleMail}); 
                    }
                    if(code.ShowLocalData__c){
                        responseCNN.showLocalData = true; 
                    }
                }
            }
            
            TransactionMgmtHelper mgmtHelper = new TransactionMgmtHelper();
            mgmtHelper.createTransactionMgmtHistoryRecord('CCNLOOKUP',tranidData);
        }
        return responseCNN;        
    }
    
    public PageReference CCNLookupSearch(){
        string CCNNumberValue = ApexPages.currentPage().getParameters().get('CCNNumberId');
        conlst.clear(); 
        System.debug('CCNNumber '+CCNNumberValue);
        if(CCNNumberValue != null && CCNNumberValue.trim() != '' && CCNNumberValue.length()>3){
             string soslCondition = CCNNumberValue;
             String whereCondition =  ' Where RecordType.Name = \'Consumer\' and Active__c = true';
            
             string searchQuery = 'FIND {'+ soslCondition +'} IN ALL FIELDS ';
             searchQuery += 'RETURNING Contact(id,Name,CustomerID__c,Email,CCN__c,Customer_Type__c,FirstName,LastName,phone,MobilePhone,OtherPhone,zip_code__c,Street_Address__c,State__c, City__c,Country__c,Birthdate1__c';
             if(whereCondition  != null && whereCondition != '')
                 searchQuery += whereCondition ; 
             searchQuery += ')';
             
             List<List <sObject>> searchList = search.query(searchQuery);
             List<Contact> contactData= ((List<contact>)searchList[0]);              
             if(!contactData.isEmpty()){
                for(Contact con :contactData){
                    Contact conInner = con;
                    
                    if(CCNNumberValue  != null && CCNNumberValue  != '' && conInner.id != null){
                        if(CCNNumberValue == conInner.ccn__c)
                            conInner = con;
                        else
                            conInner = new Contact();
                    }
                    
                    if(conInner.id != null){
                        conlst.add(conInner);
                    }
                }
            }
            RadioDisplay=true;
            System.debug('CCNNumber conlst'+conlst);
            if(conlst.isEmpty() || conlst.Size() == 0){ 
                RadioDisplay=false;                    
                ApexPages.addMessage(new ApexPages.Message(apexpages.severity.info, 'No record found, Please create new consumer.'));
            }             
        }else{
            RadioDisplay=false;                    
            ApexPages.addMessage(new ApexPages.Message(apexpages.severity.info, 'No record found, Please create new consumer.'));
        }
        return null;
    }
    
    //Method to check if a consumer is associated to the transaction.
    public Boolean checkContact(){
        Boolean checkContact = false;        
        if(tranObj.Contact__c == null){
            Transaction_Management__c tranData = [Select id,Contact__c from Transaction_Management__c where id =:tranObj.id];
            if(tranData.Contact__c != null){
                tranObj.Contact__c = tranData.Contact__c;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Consumer already associated with current transaction.'));
                checkContact = true;
            }
        }else{
            checkContact = true;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Consumer already associated with current transaction.'));
        }
        System.debug('test checkContact  '+checkContact );
        return checkContact ;
    }
    
    //Method to refresh the tab.
    public PageReference RefreshContact(){        
        if(checkContact()){
            Clear();
            isConsumerBtnVisible =false;            
        }
        return null;
    }
}