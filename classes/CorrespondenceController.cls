public class CorrespondenceController {

    public Correspondence__c codObj{get;set;}
    public List<Correspondence__c> codlst{get;set;}
    public Contact conObj{get;set;}
    public List<Case> caseObj{get;set;}
    public Id contid{get;set;}
    public Boolean showMasterID{get;set;}
    public string selectedId{get;set;}
    public Set<String>  pkgCodeSet = new Set<String>();
    public List<DocumentType__c> docObj{get;set;}
    public List<Brand__c> brandObj{get;set;}
    public string selectedBrand{get;set;}
    public string selectedLetter{get;set;}
    public List<SelectOption> OptionBrand{ get;set; }
    public List<SelectOption> letterList {get;set;}
    public List<SelectOption> MasterIssueList {get;set;}
    public String customerRecType{get;set;}
 
    public CorrespondenceController (ApexPages.StandardController stdController){  
        
        codObj = new Correspondence__c();
        codObj=(Correspondence__c)stdController.getRecord();       
        caseObj = new List<Case>();
        if(codObj.id == null){   
            contid=ApexPages.currentPage().getParameters().get('contid');
            Cookie counter = ApexPages.currentPage().getCookies().get('customerRecType');
            if(counter != null) {
                    customerRecType = counter.getValue();
            }
            codObj.contact__c=contid;        
            Date yourDate = Date.today();
            String dateOutput = yourDate.format();
            codObj.LetterDate__c=dateoutput;
        }else{
            codObj = [Select id,MasterId__c,DocType__c,Comments__c, Contact__c,DocType__r.Description__c,Brand_Corres__c from Correspondence__c where id =:codObj.id];
            contid = codObj.contact__c;
            id consumerRectype = Schema.SObjectType.contact.getRecordTypeInfosByName().get('Consumer').getRecordTypeId();
            Contact con = [select id, RecordTypeId from Contact where id =: codObj.contact__c];
            if(con != null && con.RecordTypeId != null && con.RecordTypeId == consumerRectype){
                customerRecType =  'consumer';
            }else{
                customerRecType =  'trade';
            }
            system.debug('-----codObj-constructor--'+codObj);
        }
        
        caseObj = new List<Case>();
        docObj=new List<DocumentType__c>();
        brandObj=new List<Brand__c>();
        OptionBrand = new List<SelectOption>();  
        letterList = new List<SelectOption>();  
        MasterIssueList = new List<SelectOption>();
        LetterData();   
        MasterIssueListData();
        OptionBrand.add(new SelectOption('--None--','--None--'));
        if(codObj.id != null){            
            selectedLetter = codObj.DocType__c;
            
            if(customerRecType != 'trade'){
                brandList();
                if(codObj.MasterId__c != null){
                    selectedId = '1-'+codObj.MasterId__c;   
                }
                selectedBrand = codObj.Brand_Corres__c;
            }else{
                if(codObj.MasterId__c != null){
                    selectedId = '1-'+codObj.MasterId__c;   
                }
            }
        }   
             
    }
    
    private void LetterData(){ 
        letterList = new List<SelectOption>();        
        letterList.add(new SelectOption('--None--','--None--'));  
        if(customerRecType != 'trade'){
            for(DocumentType__c docTyp:[select id,PkgCode__c,Description__c,showMasterField__c,OpCo__c from DocumentType__c Where IsActive__c =  true and isTrade__c = false]){            
                letterList.add(new SelectOption(docTyp.id,docTyp.Description__c));
            }
        }else{
             for(DocumentType__c docTyp:[select id,PkgCode__c,Description__c,showMasterField__c,OpCo__c from DocumentType__c Where IsActive__c =  true and isTrade__c = true limit 1]){            
                letterList.add(new SelectOption(docTyp.id,docTyp.Description__c));
                showMasterID = docTyp.showMasterField__c;
             }
        }
    }
    
    public PageReference brandList(){   
        system.debug('test '+selectedLetter);
         if(customerRecType != 'trade'){
             List<DocumentType__c> docObj1 =new List<DocumentType__c>([select id,OpCo__c,showMasterField__c from DocumentType__c where IsActive__c =  true and id=:selectedLetter]);
             
             if(docObj1!=null && !docObj1.isEmpty()){
                if(docObj1[0].showMasterField__c == true ){
                    showMasterID=true;  
                    MasterIssueListData(); 
                    if(caseObj.isEmpty()){
                        String name = customerRecType == 'trade' ? 'trade customer' :customerRecType;
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'The letter you have chosen requires an Issue/Master ID and the consumer does not have any issues'));
                    }              
                }
                else{
                    showMasterID=false;
                }            
             }
             selectedBrand = null; 
             OptionBrand = new List<SelectOption>();
             OptionBrand.add(new SelectOption('--None--','--None--'));
             brandObj=[select id,Name, Operating_Company__c from Brand__c where Operating_Company__c=:docObj1[0].OpCo__c and IsActive__c = true and IsCorrespondence__c= true limit 999];            
             
             for(Brand__c brandDesc:brandObj){                 
                 OptionBrand.add(new SelectOption(brandDesc.id,brandDesc.Name));                 
             }
        }else{
            selectedBrand = null;
        }
            
        return null;             
     }
    
     private void MasterIssueListData(){
        MasterIssueList = new List<SelectOption>();
        caseObj=[select id,CaseNumber,Transaction_Master__r.name,CreatedDate from case where Contact.id=:contid  order by CreatedDate desc limit 100];
        Set<String> setTran = new Set<String>();
        MasterIssueList.add(new SelectOption('--None--','--None--'));
        for(Case caseRecord:caseObj){ 
           if(!setTran.contains(caseRecord.Transaction_Master__r.name)) {
               MasterIssueList.add(new SelectOption('1-'+caseRecord.Transaction_Master__r.name,caseRecord.CaseNumber +' ( '+ caseRecord.CreatedDate.format('MM/dd/yyyy') +' )'));            
               setTran.add(caseRecord.Transaction_Master__r.name);
           }else{
               MasterIssueList.add(new SelectOption('2-'+caseRecord.Transaction_Master__r.name,caseRecord.CaseNumber +' ( '+ caseRecord.CreatedDate.format('MM/dd/yyyy') +' )'));            
           }
        }
    }

    public PageReference SaveRecord(){
        system.debug('Inside Saverecord'+codObj.Contact__c);
        if(codObj.Contact__c!=NULL){
            if(customerRecType != 'trade'){                
                if( selectedLetter=='--None--'|| selectedBrand=='--None--' || showMasterID==true && (selectedId=='--None--' ||selectedId==null )){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select required field.'));
                    if(caseObj.isEmpty() && showMasterID==true && (selectedId=='--None--' ||selectedId==null )){
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'The letter you have chosen requires an Issue/Master ID and the consumer does not have any issues'));
                    }
                    return null;
                }
            }else{
                if( selectedLetter=='--None--' || showMasterID==true && (selectedId=='--None--' ||selectedId==null )){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select required field.'));
                    if(caseObj.isEmpty() && showMasterID==true && (selectedId=='--None--' ||selectedId==null )){
                        String name = customerRecType == 'trade' ? 'trade customer' :customerRecType;
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'The letter you have chosen requires an Issue/Master ID and the '+name+' does not have any issues'));
                    }
                    return null;
                }
            }
            system.debug('-----selectedId---'+selectedId);
            if(selectedId != null){
                codObj.MasterId__c = selectedId.split('-')[1];
            }  
            codObj.DocType__c=selectedLetter;
            if(customerRecType != 'trade'){                
                codObj.Brand_Corres__c=selectedBrand;
            }            
        }
        system.debug('-----codObj---'+codObj);
        Database.UpsertResult upsRst = Database.upsert(codObj);
        system.debug('==upsRst==='+upsRst);
        PageReference pg = new PageReference('/' + codObj.Id);
        if(upsRst.isSuccess()){
            TransactionMgmtHelper mgmtHelper = new TransactionMgmtHelper();
            if(upsRst.isCreated()){
                mgmtHelper.createTransactionMgmtHistoryRecord('CORSP_OUTBOUND',String.valueOf(upsRst.getId()));
            }
        }        
        return pg;
    }
    
    public PageReference Clear() {
        PageReference pageRef = new PageReference(ApexPages.currentPage().getUrl());
        pageRef.setRedirect(true);
        return pageRef;
    }  
    
    public PageReference CancelRedirect(){
        //PageReference pageRef = new PageReference('/'+codObj.Id);
        PageReference pageRef = new PageReference('/apex/CorrespondenceDetail?id='+codObj.Id);
        pageRef.setRedirect(true);
        return pageRef;   
    }   
}