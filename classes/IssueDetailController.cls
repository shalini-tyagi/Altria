/*
Issue detail page controller class.
07/18/2016 Infogain – Created.
*/

   public class IssueDetailController {
    // Global declaration of variables
    private Id issueId;
    public Id tranId {get;set;}
    public Case caseObj {get;set;}
    public boolean isReimbursed{get;set;}
    private ApexPages.StandardController standardController;
    public boolean isUpdateReasonVisible{get;set;}
    public boolean isAgeVerified{get;set;}
    public string isSurveyApplicable {get;set;}
    id contactid;
    public String tranName {get;set;}
    public String custName {get;set;} 
    public string custId{get;set;}
    public string country{get;set;}
    public string customertype{get;set;}
    public string customerRecType{get;set;}
    public List<Attachment> attachList{get;set;} 
    public Integer PageSize  {get;set;}
    public id currentTran {get;set;}
    public List<Survey_Issue__c> IssueSurvyeList{get;set;} 
    public boolean isRepeatCom{get;set;}

    
   // Constructor
    public IssueDetailController(ApexPages.StandardController controller) {
           this.standardController = controller;
           this.caseObj = (Case)controller.getRecord();
           issueId =  this.caseObj.id;  
           IssueSurvyeList = new List<Survey_Issue__c>();
           custName  = '';
           custId = '';
           Case cValue = new Case();
           Cookie counter = ApexPages.currentPage().getCookies().get('tranid');
           if(counter != null) {
                currentTran = counter.getValue();
           }
           if(this.caseObj.id != null){
               cValue =  [Select id, Transaction__c, Survey__c, Transaction__r.Name,ContactId, Contact.Name,contact.Zip_Code__c,contact.State__c,contact.Country__c,
                               contact.Birthdate,Contact.CustomerID__c, Consumer_Age_Verified__c, Contact.Customer_Type__c  from Case where id =: caseObj.id];
               country=cValue.Contact.Country__c;
               customertype = cValue.Contact.Customer_Type__c;
               if(cValue.Transaction__c != null ){
                   tranId = cValue.Transaction__c;
                   tranName = cValue .Transaction__r.Name;  
               }
               
               if(cValue.ContactId != null){
                   custName = cValue.Contact.Name;
                   custId = cValue.Contact.CustomerID__c;
                   
               }
               isAgeVerified = cValue.Consumer_Age_Verified__c;
               
               if(cValue.Survey__c != null){
                   isSurveyApplicable = cValue.Survey__c;
               }

           }
           isReimbursed = checkMultipleReimbursements();
        
           
           if(caseObj.Update_Reason__c!=null && caseObj.Update_Reason__c!=''){
               isUpdateReasonVisible = true;
           }else{
               isUpdateReasonVisible =false;
           }
           
           counter = ApexPages.currentPage().getCookies().get('customerRecType');
           if(counter != null) {
                customerRecType = counter.getValue();
           }
        
        attachmentList();
        IssueSurveyData();
       }
    
    
    // Method for validation to avoid more than one reimbursement on same issue
    public boolean checkMultipleReimbursements(){
        Case currIssue = [Select Id, Reimbursement_Count__c From Case Where Id =: caseObj.id limit 1];

        if(currIssue != null && currIssue.Reimbursement_Count__c > 0)
        {
            return true;
        }  
        return false;
    }
    
    // Button event to create new store from current issue
    public PageReference store()
    {
        issueId = ApexPages.currentPage().getParameters().get('id');
        PageReference pg = new PageReference('/apex/StoreEditPage?IssueId='+ issueId);
        return pg;
    }

    // Button event to create new reimbursement from current issue    
    public Pagereference reimbursementNew()
    {
        issueId = ApexPages.currentPage().getParameters().get('id');
        PageReference pg = new PageReference('/apex/ReimbursementEdit?issueId='+ issueId);
        return pg;
    }
   
    // Button event to edit current issue
    public PageReference edit()
    {
       PageReference pg = new Pagereference('/apex/IssueEntryPage?id='+issueId);
       return pg;
    }
    
    // Button event to detail reimbursement of current issue
    /*public PageReference reimbursement(){
        Id id=ApexPages.currentPage().getParameters().get('id');
        PageReference reimbursement= new PageReference('/apex/reimbursement_IssueList');
        reimbursement.getParameters().put('Issid',ApexPages.currentPage().getParameters().get('id'));
        reimbursement.getParameters().put('tranId',ApexPages.currentPage().getParameters().get('tranId')); 
        reimbursement.setRedirect(true);
        return reimbursement;
    }*/
    
    //Method to get the creatable fields of a object and create a dynamic soql query.
    public static string getCreatableFieldsSOQL(String objectName, String whereClause){
        String selects = '';
        if (whereClause == null || whereClause == ''){ return null; }
        // Get a map of field name and field token
        Map<String, Schema.SObjectField> fMap = Schema.getGlobalDescribe().get(objectName.toLowerCase()).getDescribe().Fields.getMap();
        list<string> selectFields = new list<string>();
         if (fMap != null)
         {
            for (Schema.SObjectField ft : fMap.values())
            { 
            // loop through all field tokens (ft)
                Schema.DescribeFieldResult fd = ft.getDescribe(); // describe each field (fd)
                if (fd.isCreateable() && fd.getName() != 'Update_Reason__c')
                { // field is creatable
                   selectFields.add(fd.getName());
                }
            }
        }
         
        if (!selectFields.isEmpty())
        {
            for (string s:selectFields)
            {
                selects += s + ',';
            }
            if (selects.endsWith(','))
            {
            selects = selects.substring(0,selects.lastIndexOf(','));
            }
             
        }
        return 'SELECT ' + selects + ' FROM ' + objectName + ' WHERE ' + whereClause;
        }
  
    // Button event to create clone of current issue
    public PageReference customClone()
    {
        PageReference pgRef;
        Id cloneIssueId = ApexPages.currentPage().getParameters().get('id');
        String soql = getCreatableFieldsSOQL('case','id=: cloneIssueId');
        Case issueOld = (Case)Database.query(soql);
        Case issueNew = issueOld.clone(false, true);
        insert issueNew;
        if(contactid !=  null && contactid != ''){
            pgRef = new Pagereference('/apex/IssueEntryClone?id='+issueNew.id+'&parentIssue='+cloneIssueId+'&contid='+contactid );
        }else{
            pgRef = new Pagereference('/apex/IssueEntryClone?id='+issueNew.id+'&parentIssue='+cloneIssueId);
        }
        
        return pgRef;
    }
       
    public Pagereference attachmentList(){           
       
       attachList=[select id,name,CreatedDate,LastModifiedDate,description from Attachment where ParentId=:caseObj.id];
       
       return null;
    }
       
    public Pagereference  IssueSurveyData() {        
          
       IssueSurvyeList = new List<Survey_Issue__c>( [SELECT id, Comment__c, Survey_Name__c, QuestionText__c ,AnswerText__c 
                        FROM Survey_Issue__c 
                        Where isActive__c = true
                        and Issue__c =:caseObj.id 
                        order by createddate asc limit 5] );
        
        return null;
    } 
       
    
    
    public Pagereference ConsumerDetails(){
        Case cValue = new Case();
        if(caseObj.id != null){
           cValue =  [Select id, Transaction__c,Survey__c , Transaction__r.Name,Contact.Country__c,ContactId, Contact.Name,Contact.CustomerID__c,Consumer_Age_Verified__c, Contact.Customer_Type__c
                      From Case Where id =: caseObj.id];
           if(cValue.Transaction__c != null ){
               tranId = cValue.Transaction__c;
               tranName = cValue .Transaction__r.Name;  
           }
           System.debug('test cValue.Survey__c '+cValue.Survey__c);
           if(cValue.Survey__c != null){
               isSurveyApplicable = cValue.Survey__c;
           }
           
           if(cValue.ContactId != null){
               custName = cValue.Contact.Name;
               custId = cValue.Contact.CustomerID__c;
               country=cValue.Contact.Country__c;
               customertype =  cValue.Contact.Customer_Type__c;
           }
            
            isAgeVerified = cValue.Consumer_Age_Verified__c;
         }
       if(!isReimbursed)   
           isReimbursed = checkMultipleReimbursements();  
           
       attachmentList(); 
       IssueSurveyData();
       return null;
    }
}