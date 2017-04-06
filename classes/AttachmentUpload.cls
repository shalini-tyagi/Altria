/* Created on 02-Sep-2016*/

public class AttachmentUpload{

    public Id attID {get;set;}
    private Attachment att;
    private Attachment_Detail__c AttachmentDetailObj;
    
    public Attachment attachment {
        get {
            if (att == null)
                att = new Attachment();
            return att;
        }
        set{
            att = value;
        }
    }
    
    public AttachmentUpload(ApexPages.StandardController stdController){
        attachment = (Attachment)stdController.getRecord();
        attID = ApexPages.currentPage().getParameters().get('id');
        
        AttachmentDetailObj = new Attachment_Detail__c();  
        
        if(attachment != null && attachment.id != null){
            List<Attachment_Detail__c> AttachmentDetailList = new List<Attachment_Detail__c>([Select id, File_Type__c,AttachmentId__c,Description__c, File_Name__c, 
                                                                                             Issue__c
                                                                                             From Attachment_Detail__c
                                                                                             Where AttachmentId__c =: attID and IsActive__c = true limit 1]);
            if(!AttachmentDetailList.isEmpty() && AttachmentDetailList.size() >0)
                    AttachmentDetailObj = AttachmentDetailList[0];
        }    
    }
  
    public PageReference updateAttachment(){
        
        if(attachment != null && attachment.id != null){
            
            if(attachment.description!=null && attachment.description.length() >= 500){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Comment: Max. 500 characters are allowed.'));
                return null;
            }
            update attachment;
            AttachmentDetailObj.File_Name__c = attachment.Name;
            AttachmentDetailObj.Description__c = attachment.description;
            update AttachmentDetailObj;
        }
        
        PageReference pg=new PageReference('/apex/AttachmentDetailPage?id='+attID);   
        
        pg.setRedirect(true); 
        return pg;
    }
    
    public PageReference cancelButton(){
        PageReference pg1=new PageReference('/apex/AttachmentDetailPage?id='+attID);  
        return pg1;
    }
    
    public PageReference upload() {
        
        attachment.OwnerId = UserInfo.getUserId();
        attachment.ParentId = ApexPages.currentPage().getParameters().get('issueId'); // the record the file is attached to
        attachment.IsPrivate = true;
        
        if(attachment.body == null){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please attach a valid File before upload.'));            
            return null;
        }
        
        try{
            
            insert attachment;
            if(ApexPages.currentPage().getParameters().get('issueId') != null){
                string issueId = ApexPages.currentPage().getParameters().get('issueId');
                Case currIssue = [Select Id, IsReviewed__c From Case Where Id =: issueId limit 1];
                if(currIssue != null){
                    AttachmentDetailObj.isReviewed__c = currIssue.IsReviewed__c;
                }
            }            
            AttachmentDetailObj.AttachmentId__c =  attachment.id;
            AttachmentDetailObj.Description__c = attachment.description;
            AttachmentDetailObj.File_Name__c = attachment.Name;
            AttachmentDetailObj.Issue__c = ApexPages.currentPage().getParameters().get('issueId');
            AttachmentDetailObj.IsActive__c = true;                                                                                 
             
            insert AttachmentDetailObj;
             
            PageReference pg2=new PageReference('/apex/AttachmentDetailPage?id='+attachment.id);    
            pg2.setRedirect(true);   
            return pg2;
            
        }catch(Exception e){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error uploading attachment.'));
            return null;
        }
    }
}