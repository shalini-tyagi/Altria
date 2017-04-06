public class ConsumerDetailController {

    public contact conObj {get;set;}
    public Boolean Customershow {get;set;}  
    public Boolean isAgeVerificationReq{get;set;}
    private Id tranid;
    
    public ConsumerDetailController (ApexPages.StandardController stdController){
        conObj = new Contact();
        this.conObj=(Contact)stdController.getRecord();    
        Cookie counter = ApexPages.currentPage().getCookies().get('tranid');
        if(counter != null) {
            tranid = counter.getValue();
            id consumerRectype = Schema.SObjectType.contact.getRecordTypeInfosByName().get('Consumer').getRecordTypeId();
         
            if(conObj.RecordTypeId != null && conObj.RecordTypeId != consumerRectype){
                Customershow = false;
            }else{
                Customershow = true;   
            }
        }
     
        getCurrCountry();
    }
    
     
    
    //Method to display the Age verify button on the screen
    public void getCurrCountry(){
        if(conObj.Country__c == null || conObj.Country__c == '--None--' || conObj.Country__c == Label.Country){
            isAgeVerificationReq = true;
        }else{
            isAgeVerificationReq = false;
        }
        if(isAgeVerificationReq && conObj.Customer_Type__c != Label.CustomerType){
            isAgeVerificationReq = false;
        }
    }

    //Method to launch the consumer edit page on the Edit button
    public PageReference editConsumer(){
       PageReference pg1;
        if(conObj.id!=null){
         pg1=new PageReference ('/apex/ConsumerEntry?id='+conObj.id);    
        }
        return pg1;
       
    }
    
    //Method to refresh the detail page
    public PageReference refreshpage(){
        if(conObj.id!=null){
            PageReference pg1;
            pg1 = new PageReference('/apex/ConsumerDetailPage?id='+conObj.Id);
            pg1.setRedirect(true);
            return pg1;
        }
        return null;
    }
}