public class ConsumerAgeVerificationController {
    
    public contact conObj {get;set;}
    public Id tranid {get;set;}
    public boolean readOnlyCityState{get;set;}
    string oldZip;
    @TestVisible private string FormName;
    public Id contactId{get;set;}
    
    public ConsumerAgeVerificationController (ApexPages.StandardController stdController){
        conObj = new Contact();
        contactId = stdController.getId();
        conObj = [Select Id, Customer_Type__c, Salutation, FirstName, Suffix__c, LastName, Street_Address__c, City__c, Apt_Lot__c, State__c, Zip_Code__c, Birthdate1__c
                  From Contact Where id =: contactId];
        Cookie counter = ApexPages.currentPage().getCookies().get('tranid');
        if(counter != null) {
            tranid = counter.getValue(); 
        }
        system.debug('------counter-----'+counter);
        system.debug('------tranid-----'+tranid);
    }
       //Get City and State based on postal code using Melissa webservice.
    public void getcitystate(){
        if(conObj.Zip_Code__c!=null && oldZip != conObj.Zip_Code__c){
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
                            conObj.city__c = zipLookup.Results[0].Address.City;
                            conObj.state__c = zipLookup.Results[0].Address.State;
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
    //Method to reset the fields on the page
    public PageReference reset(){
        conObj = [Select Id, Customer_Type__c, Salutation, FirstName, Suffix__c, LastName, Street_Address__c, City__c, Apt_Lot__c, State__c, Zip_Code__c, Birthdate1__c
                  From Contact Where id =: contactId];
        return null;
    }
    //Method for calling age verification via lexis nexis web service
    public PageReference ageVerify(){
        PageReference pgRef;
        if(tranId != null){
            Transaction_Management__c calldetails = [select id, name, Operating_Company__c, Operating_Company__r.OperatingCompany__c from Transaction_Management__c where id =:tranid];
            
            LexisNexisClasses.AgeVerificationRequest ageVerificationRequest = new LexisNexisClasses.AgeVerificationRequest();
            ageVerificationRequest.Prefix = conObj.Salutation;
            ageVerificationRequest.FirstName = conObj.FirstName;
            ageVerificationRequest.MiddleName = '';//conObj.Middle_Name__c;
            ageVerificationRequest.LastName = conObj.LastName;
            ageVerificationRequest.Suffix = conObj.Suffix__c;
            string dob;
            if(conObj.Birthdate1__c != null){
                dob = conObj.Birthdate1__c.format();
            }else{
                dob = '';
            }
            string month;
            string year;
            string day;
            if(dob != null && dob != ''){
                string[] dobString = dob.split('/');
                month = dobString[0];
                year = dobString[2];
                day = dobString[1];
            }else{
                month = '';
                year = '';
                day = '';   
            }
            ageVerificationRequest.DOBYear = year;
            ageVerificationRequest.DOBMonth = month;
            ageVerificationRequest.DOBDay = day;
            ageVerificationRequest.AddressLine1 = conObj.Street_Address__c;
            ageVerificationRequest.AddressLine2 = conObj.Apt_Lot__c;
            ageVerificationRequest.City = conObj.City__c;
            ageVerificationRequest.State = conObj.State__c;
            ageVerificationRequest.Zip = conObj.Zip_Code__c;
            system.debug('------ageVerificationRequest----'+ageVerificationRequest);
            system.debug('------tranid-1----'+tranid);
            system.debug('------calldetails.Operating_Company__r.OperatingCompany__c----'+calldetails.Operating_Company__r.OperatingCompany__c);
            LexisNexisClasses.AgeVerificationResponse ageVerificationResponse = LexisNexisServices.AgeVerificationRequest(ageVerificationRequest,tranid,'Consumer Age verification',calldetails.Operating_Company__r.OperatingCompany__c);
            system.debug('-----ageVerificationResponse----'+ageVerificationResponse);
            if(ageVerificationResponse != null){
                if(ageVerificationResponse.Status != null && ageVerificationResponse.Status == 'PASS'){
                    conObj.AVF_GIID_Received__c = true;
                    ApexPages.addMessage(new ApexPages.Message(apexpages.severity.info, ageVerificationResponse.Message));
                    Contact conUpd = [Select Id, AVF_GIID_Received__c, Birthdate1__c,Age_Verification_Source__c,Age_Verified_Date__c   From Contact Where Id =: conObj.Id];
                    conUpd.Birthdate1__c = conObj.Birthdate1__c;
                    conUpd.AVF_GIID_Received__c = conObj.AVF_GIID_Received__c;
                    conUpd.Age_Verification_Source__c = 'Lexis Nexis'; 
                    //conUpd.Age_Verified_Date__c = date.today(); 
                    Database.SaveResult saveRst = Database.update(conUpd);
                }else{
                    //conObj.Age_Verified__c = false;
                    if(ageVerificationResponse.Status != null && ageVerificationResponse.Status.trim() == 'Error'){
                        ApexPages.addMessage(new ApexPages.Message(apexpages.severity.Error, 'Server Error, Please try again!'));
                    }else{
                        ApexPages.addMessage(new ApexPages.Message(apexpages.severity.Error, ageVerificationResponse.Message));
                    }
                }
            }   
            TransactionMgmtHelper mgmtHelper1 = new TransactionMgmtHelper();
            mgmtHelper1.createTransactionMgmtHistoryRecord('AGE_VERIFICATION_REQUEST',conObj.Id);
            
            TransactionMgmtHelper mgmtHelper2 = new TransactionMgmtHelper();
            mgmtHelper2.createTransactionMgmtHistoryRecord('AGE_VERIFY',String.valueOf(conObj.Id));
        }
        return null;   
     }
}