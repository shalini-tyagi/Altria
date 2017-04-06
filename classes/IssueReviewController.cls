public class IssueReviewController{
    
    public Case issueObj {get; set;}
    public Integer PageSize{get;set;}
    
    public IssueReviewController(ApexPages.StandardController controller) {
        pageInit();
    }
    
    private void pageInit(){
                
        //issueObj = [select id,caseNumber from case where id=:ApexPages.currentPage().getParameters().get('Id')];
        if(ApexPages.currentPage().getParameters().get('pageSize') != null){
            PageSize = Integer.valueOf(ApexPages.currentPage().getParameters().get('pageSize'));
        }else{
            PageSize = 25;
        }
    }
    
     public ApexPages.StandardSetController setQun {
         
        get {
            if(setQun == null) {
                setQun = new ApexPages.StandardSetController(Database.getQueryLocator(
                    [SELECT id, CaseNumber, Issue_Type__c, Comment__c, ContactId, Brandcode__c, Product_Line__c, 
                     Classificationtxt__c, Reasontxt__c, Causetxt__c, Contact.Name 
                        FROM Case 
                        Where IsReviewed__c = false 
                        order by createddate asc] ));
                
                setQun.setPageSize(PageSize);
 
            }
            return setQun;
        }
        set;
    }
        
    public Boolean hasNext {
        get {
            return setQun.getHasNext();
        }
        set;
    }
    public Boolean hasPrevious {
        get {
            return setQun.getHasPrevious();
        }
        set;
    }
    
    public void previous() {
         setQun.previous();
     }
    
    public void next() {
         setQun.next();
     }
    
    
    // Wrapper list  
    public List<Case> getIssueReviewList() {        
          
        List<Case> issueList = new List<Case>();
        issueList =setQun.getRecords();
        
        return issueList ;
    } 
       
     public pagereference cancel(){
          return new PageReference('/'+issueObj.id);
     }
    
}