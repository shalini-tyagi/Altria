/* Issue New/Edit Page Controller
   07/19/2016 - Infogain---Created
*/

 public class IssueEntryController {
  //Global declaration of variables
    public Case caseObj{get;set;}
    public contact conObj {get;set;}
    public Boolean tradeCustomershow{get;set;}    
    public ApexPages.StandardController standController{get;set;}
    public string selectedProductLine {get; set;}    
    public List<SelectOption> productLineList {get; set;}    
    public boolean isUpdateReasonEntry{get;set;}
    public boolean isUpdateReasonClone{get;set;}
    public string brand{get;set;}
    public string selectedTraceCodeLocation{get;set;}
    public string productionDate {get;set;}
    public string customerRecType{get;set;}
    public string dateCodeDate {get;set;}
    public string traceCodeErrorMessage {get;set;}
    public boolean traceCodeError {get;set;}
    public string dateCodeError {get;set;}
    public string productLineId {get;set;}
    public boolean isRepeatCom{get;set;}
    
    @TestVisible private Id cloneIssueId;
    private Id tranId;
    private Id contactId;
    private Map<String,Product_Line__c> productLineMap; 
    private id oldIssueHierarchy;
    
    /* Display all the fields on page and lookup for operating company */
    public IssueEntryController (ApexPages.StandardController controller) 
    {        
        isUpdateReasonEntry=false;
        isUpdateReasonClone=false;
        traceCodeError = false;
        traceCodeErrorMessage = '';
        caseObj = new Case();
        isRepeatCom = false;
        this.standController = controller;
        
        this.caseObj = (Case)controller.getRecord();
        System.debug('test this.caseObj '+this.caseObj);
        tradeCustomershow = false;
        conObj  = new Contact();
        productLineMap  = new Map<String,Product_Line__c>();
        Cookie counter = ApexPages.currentPage().getCookies().get('tranid');
        
        if(counter != null) {
            tranid = counter.getValue();
        }
        
        contactId = ApexPages.currentPage().getParameters().get('contid');
        cloneIssueId = ApexPages.currentPage().getParameters().get('parentIssue');
        if(cloneIssueId != null){
            String soql = getCreatableFieldsSOQL('case','id=: cloneIssueId');
            Case issueOld = (Case)Database.query(soql);
            System.debug('test this.caseObj '+this.caseObj);
            System.debug('test issueOld '+issueOld);
            this.caseObj =  issueOld.clone(false, true);
            System.debug('test contactId '+contactId);
            if(contactId == null && this.caseObj.Contactid != null){
                contactId = this.caseObj.Contactid;
                System.debug('test contactId 1 '+contactId);
            }
            
        }
        if(caseObj.id != null){
            Case cvalue = [select Contactid,Transaction__c,Production_date__c,Date__c,Trace_Code_Location__c,Survey__c,Issue_Hierarchy_Code__c  from Case where id =:caseObj.id];
               if(cvalue.Production_date__c != null) 
                   productionDate = cvalue.Production_date__c.format();
               if(cvalue.Issue_Hierarchy_Code__c != null)    
                   oldIssueHierarchy = cvalue.Issue_Hierarchy_Code__c;    
    
               caseObj.Survey__c = cvalue.Survey__c;      
               if(cvalue.Date__c != null)    
                   dateCodeDate  =  cvalue.Date__c.format();
               if(cvalue.Trace_Code_Location__c != null && cvalue.Trace_Code_Location__c != '')    
                   selectedTraceCodeLocation = cvalue.Trace_Code_Location__c;
                   
            if(cvalue.contactId != null){
                conObj = [select id, Repeat_Complainer__c, Repeat_Complainer_Date__c,BirthDate__c, CCN__c,Apt_Lot__c,City__c,Country__c,State__c,Street_Address__c,Zip_Code__c,Name,CustomerID__c from Contact where id = :cvalue.contactId  ];
            }
            isUpdateReasonEntry=true;
            caseObj.Transaction__c=tranId;            
        }else{            
            caseObj.Transaction__c=tranId;
            
            if(caseObj.Transaction_Master__c == null){
                caseObj.Transaction_Master__c = tranId;
            }
        }  
        
        if(contactId != null  && (caseObj.contactId == null || cloneIssueId != null)){
            caseObj.contactId = contactId;            
            conObj = [select id, BirthDate__c, Repeat_Complainer__c, CCN__c,Apt_Lot__c,City__c,Country__c,State__c,Street_Address__c,Zip_Code__c,Name,CustomerID__c from Contact where id = :contactId];
           
            if(conObj.BirthDate__c != null && conObj.BirthDate__c != '')
                caseObj.Contact_DOB__c = conObj.BirthDate__c;
                
            if(conObj.CCN__c != null && conObj.CCN__c != '')    
                caseObj.Contact_CCN_Number__c = conObj.CCN__c; 
            
            if(conObj.Apt_Lot__c != null && conObj.Apt_Lot__c != ''){
                caseObj.Contact_Apt_Lot__c = conObj.Apt_Lot__c;
            }   
                        
            if(conObj.Street_Address__c != null && conObj.Street_Address__c != ''){
                caseObj.Contact_Street_Address__c = conObj.Street_Address__c;                    
            }
            
            if(conObj.City__c!= null && conObj.City__c != ''){
                caseObj.Contact_City__c = conObj.City__c;                    
            }
            
            if(conObj.State__c != null && conObj.State__c!= ''){
                caseObj.Contact_State__c = conObj.State__c;                    
            }
            
            if(conObj.Country__c != null && conObj.Country__c != ''){
                caseObj.Contact_Country__c = conObj.Country__c;                    
            }
            
            if(conObj.Zip_Code__c  != null && conObj.Zip_Code__c != ''){
                caseObj.Contact_Zip_Code__c = conObj.Zip_Code__c ;                   
            }
        }       
        Cookie counter1 = ApexPages.currentPage().getCookies().get('customerRecType');
           if(counter1 != null) {
                customerRecType = counter1.getValue();
               system.debug('----customerRecType----'+customerRecType);
           }
        productLineListData();
        
        if(caseObj.id == null && conObj.id != null){
            if(!conObj.Repeat_Complainer__c){
                isRepeatCom = checkMutipleIssue();
            }else{
                isRepeatCom = true;
            }
        }
    }
    
     //Check whether Repeat Complainer or not
     public boolean checkMutipleIssue(){
        list<Case> issueOnCurrCon = [Select Id, Contactid From Case Where Contactid =: conObj.id limit 1];
        if(issueOnCurrCon != null && issueOnCurrCon.size() > 0)
        {
            return true;
        }  
        return false;
    }
    //Get brand name. 
    public String getbrandData()
    {
        Brand_Hierarchy__c brandhirObj=new Brand_Hierarchy__c();
        if(caseObj.Crc_Brand_Hierarchy_Code__c!=null)
        { 
            brandhirObj = [select id, Brand_Code__r.Name
                         FROM Brand_Hierarchy__c 
                         WHERE id=:caseObj.Crc_Brand_Hierarchy_Code__c];
            if(brandhirObj.Brand_Code__r.Name=='COPENHAGEN')
            {
                brand=brandhirObj.Brand_Code__r.Name;
            }else{
                brand='';
            }   
        }
        return brand;
    }
    
    // Button event to Save and Update the current issue
    public PageReference save() {
        List<Survey_Issue__c> oldSurveyIssue = new List<Survey_Issue__c>();
        try {
           // System.debug('test caseObj.Production_date__c '+caseObj.Production_date__c);
           
           if(productLineMap.ContainsKey(selectedProductLine)){
               Product_Line__c ProductLineCode = productLineMap.get(selectedProductLine);
               caseObj.Product_Line_Code__c  =ProductLineCode.id;
            
            }
            Issue_Hierarchy__c issuehObj= new Issue_Hierarchy__c(); 
            if(caseObj.Issue_Hierarchy_Code__c!=null){
                issuehObj = [select id,Issue_Type__r.Description__c,Product_Line__r.Name,Group__r.Description__c,Reason__r.Description__c,Cause__r.Description__c,
                             Classification__r.Description__c 
                             FROM Issue_Hierarchy__c 
                             WHERE id=:caseObj.Issue_Hierarchy_Code__c];
                 
                caseObj.Product_Line__c=issuehObj.Product_Line__r.Name;
                caseObj.Issue_Type__c=issuehObj.Issue_Type__r.Description__c;
                caseObj.Reasontxt__c=issuehObj.Reason__r.Description__c;
                caseObj.Causetxt__c=issuehObj.Cause__r.Description__c;
                caseObj.Group_Code__c=issuehObj.Group__r.Description__c;
                caseObj.Classificationtxt__c=issuehObj.Classification__r.Description__c;
                
                 if(oldIssueHierarchy != caseObj.Issue_Hierarchy_Code__c){
                     oldSurveyIssue = new List<Survey_Issue__c>([Select id,isActive__c 
                                                                              From Survey_Issue__c 
                                                                              Where isActive__c =  true
                                                                              and Issue__c =: caseObj.id 
                                                                              ]);
                  
                     if(!oldSurveyIssue.isEmpty() && oldSurveyIssue.size() >0){
                         for(Survey_Issue__c surObj : oldSurveyIssue){
                             surObj.isActive__c = false;
                         }                     
                     }
                     
                     caseObj.Survey__c = null;
                 }
                
                 if(caseObj.id == null){
                     issueSurveyRequired survey = new issueSurveyRequired();
                
                     Boolean surApplicable = survey.surveyRequired(caseObj.Issue_Hierarchy_Code__c);                     
                     
                     if(surApplicable){
                         caseObj.Survey__c = 'Required';
                     }else{
                         caseObj.Survey__c = 'Not Applicable';
                     }
                 }                
                 else{
                     if(caseObj.Survey__c == null || (caseObj.Survey__c != null && caseObj.Survey__c != 'Completed' && caseObj.Survey__c != 'Incomplete')){
                         issueSurveyRequired survey = new issueSurveyRequired();
                
                         Boolean surApplicable = survey.surveyRequired(caseObj.Issue_Hierarchy_Code__c);                     
                         
                         if(surApplicable){
                             caseObj.Survey__c = 'Required';
                         }else{
                             caseObj.Survey__c = 'Not Applicable';
                         }
                     } 
                 }                
                 
            }
            Brand_Hierarchy__c brandhObj= new Brand_Hierarchy__c();
            if(caseObj.Crc_Brand_Hierarchy_Code__c!=null)
            { 
                brandhObj = [select id, UPC__c,Taste__c,Packaging__c,Cut__c,Filter__c,Brand_Code__r.Name,Length__c,Flavor__c,PaperType__c
                            FROM Brand_Hierarchy__c WHERE id=:caseObj.Crc_Brand_Hierarchy_Code__c];
            
                caseObj.UPC_code__c=brandhObj.UPC__c;
                caseObj.Filter__c=brandhObj.Filter__c;
                caseObj.Taste__c=brandhObj.Taste__c;
                caseObj.Packaging__c=brandhObj.Packaging__c;
                caseObj.Brandcode__c=brandhObj.Brand_Code__r.Name;
                caseObj.Length_Code__c=brandhObj.Length__c;
                caseObj.Flavor__c=brandhObj.Flavor__c;
                caseObj.Paper_Type__c=brandhObj.PaperType__c;
                caseObj.Cut__c=brandhObj.Cut__c;    
            }
            
            updateTraceCodeData();
            //isRepeatCom = checkMultipleIssue();
            caseObj.IsReviewed__c = false;
            Database.UpsertResult upsRst = Database.upsert(caseObj);
            system.debug('-------upsRst-----'+upsRst);
            if(upsRst.isSuccess()){
                if(!oldSurveyIssue.isEmpty() && oldSurveyIssue.size() >0)
                    update oldSurveyIssue; 
                    
                TransactionMgmtHelper mgmtHelper = new TransactionMgmtHelper();
                system.debug('----inside success-----');
                Transaction_Management__c tranObj = [Select Id, Contact__c From Transaction_Management__c Where id =: tranId limit 1];
                if(upsRst.isCreated()){
                    mgmtHelper.createTransactionMgmtHistoryRecord('CREATEISSUE',String.valueOf(upsRst.getId()));
                }else{
                    mgmtHelper.createTransactionMgmtHistoryRecord('UPDATEISSUE',String.valueOf(upsRst.getId()));
                }
                system.debug('------conObj----'+conObj);
                if(conObj.id != null && isRepeatCom == true && !conObj.Repeat_Complainer__c){
                    system.debug('------isRepeatCom----'+isRepeatCom);               
                    conObj.Repeat_Complainer__c = true;
                    system.debug('--272---'+conObj.Repeat_Complainer_Date__c);
                    if(conObj.Repeat_Complainer_Date__c == null){
                        conObj.Repeat_Complainer_Date__c = System.today();
                    }
                    update conObj;
                }
            }
            

            PageReference pageRef = new PageReference('/apex/Issue_Detail?id='+caseObj.Id);
            pageRef.setRedirect(true);
            return  pageRef ;
        }catch(DMLException e){// Validation rule PurchaseQty_and_Affected_Qty and PurchaseQty_and_Exp_Qty will be effective
            String errMsg = e.getMessage();
            ApexPages.addMessages(e);
            return null;
        }
    } 
    
    private void updateTraceCodeData(){
        if(productLineMap.ContainsKey(selectedProductLine)){
            Product_Line__c ProductLineCode = productLineMap.get(selectedProductLine);
            caseObj.PLCode__c = ProductLineCode.Code__c;
            
            String ProductLineCode1 = '';
            if(ProductLineCode.Code__c != null){
                ProductLineCode1 = ProductLineCode.Code__c;
            }
            
            String TraceCodeObj = '';   
            if(caseObj.Mfg_Trace_code__c != null){
                TraceCodeObj = caseObj.Mfg_Trace_code__c;
            }
            
            
            String TraceCodeLocation = '';
            if(selectedTraceCodeLocation  != null){
                TraceCodeLocation = selectedTraceCodeLocation;
                caseObj.Trace_Code_Location__c =  selectedTraceCodeLocation;
            }
            
            String OpCompany = '';
            if(ProductLineCode.Operating_Company__c != null){
                OpCompany = ProductLineCode.Operating_Company__c;
            }                
            
            String UstDateCodeType = '';
            if(caseObj.Date_Type__c != null){
                UstDateCodeType= caseObj.Date_Type__c;
            }
            
            String UstDateCode = '';            
            if(caseObj.Date_Code__c != null){
                UstDateCode= caseObj.Date_Code__c;
            }   
            
            String ProductionDate = '';
            if(caseObj.Production_date__c != null)
                ProductionDate = caseObj.Production_date__c.format();
                
            
            TraceCodesDetailsHelper traceCodeHelpObj = new TraceCodesDetailsHelper();
            TraceCodesDetailsHelper.TraceCodeClass TraceCodeClassObj = new TraceCodesDetailsHelper.TraceCodeClass();
            
            try{
                System.debug('testing data '+ProductLineCode1 +' ,'+  TraceCodeObj +' ,'+ OpCompany +' ,'+  TraceCodeLocation +' ,'+ 
                                                                        UstDateCodeType +' ,'+ UstDateCode  +' ,'+ 
                                                                        ProductionDate);
                TraceCodeClassObj = traceCodeHelpObj.getAllTraceCodeValues(ProductLineCode1, TraceCodeObj,OpCompany, TraceCodeLocation, 
                                                                        UstDateCodeType,UstDateCode);
                if(ProductLineCode1 == 'EV'){    
                    caseObj.Production_date__c = null;
                }                                                        
                system.debug('test TraceCodeClassObj '+TraceCodeClassObj );                                                       
                caseObj.DateCodeProductionDate__c = TraceCodeClassObj.DateCodeProductionDate; 
                caseObj.DateCodeLocation__c = TraceCodeClassObj.DateCodeLocation;
                caseObj.DateCodeShift__c = TraceCodeClassObj.DateCodeShift;
                caseObj.DateCodeUnit__c = TraceCodeClassObj.DateCodeUnit;
                caseObj.DateCodeColdStorage__c = TraceCodeClassObj.DateCodeColdStorage;
                caseObj.DateCodeRptBay__c = TraceCodeClassObj.DateCodeRptBay;
                caseObj.DateCodeRptFactory__c = TraceCodeClassObj.DateCodeRptFactory;
                caseObj.DateCodeMilitaryTime__c = TraceCodeClassObj.DateCodeMilitaryTime;
                caseObj.SpUstDateCode__c = TraceCodeClassObj.SpUstDateCode;
                
                
            } catch(exception e){
        
            }   
        }
        
        system.debug('test caseObj '+caseObj);
    
    } 
     
    // Replace the Cancel button on IssueEntry page to redirect the page.     
    public PageReference Cancel()
     {
        PageReference pageRef;
        if(caseObj.Id !=null) {
            pageRef = new PageReference('/apex/Issue_Detail?id='+caseObj.Id);
        }else{
            pageRef = new PageReference('/500');
        }
        return pageRef;
    }   
    
    // Replace the Cancel button on IssueClone page to redirect the page.
    public PageReference customCancel() {
        cloneIssueId = ApexPages.currentPage().getParameters().get('parentIssue');
        delete caseObj;
        PageReference pageRef = new PageReference('/apex/Issue_Detail?id='+cloneIssueId);
        return pageRef;
        
    }  
    
    //Product line list.
    public void productLineListData(){
        productLineList = new List<SelectOption>(); 
        productLineMap = new Map<String,Product_Line__c>(); 
        selectedProductLine =  '0';
        productLineList.add(new SelectOption('0', '--Select Product Line--',false)); 
        
        List<Product_Line__c> productLineObj = new List<Product_Line__c>([Select id, Name,code__c,Trace_Code_Location__c,Operating_Company__c,isValidDateCode__c from Product_Line__c  where isActive__c = true order by Name asc]);  
           for(Product_Line__c pl :productLineObj){
            productLineList.add(new SelectOption(pl.name, pl.name));            
            productLineMap.put(pl.name,pl);
        }     
        if(caseObj.id!=null){
           Case issue = [Select Id,Product_Line__c From Case Where Id =: caseObj.id limit 1];
           selectedProductLine=issue.Product_Line__c;            
        }else{
            if(cloneIssueId != null){
                selectedProductLine=caseObj.Product_Line__c; 
            }
        }
    }
 
    // Save method for cloning current issue. Here it is saving some existing informations of current issue.
    public PageReference customSave(){
    try{
        cloneIssueId = ApexPages.currentPage().getParameters().get('parentIssue');
        //Case issueNew = (Case)standController.getRecord();
        
        if(productLineMap.ContainsKey(selectedProductLine)){
           Product_Line__c ProductLineCode = productLineMap.get(selectedProductLine);
           caseObj.Product_Line_Code__c  =ProductLineCode.id;
        }
            
        Issue_Hierarchy__c issuehObj= new Issue_Hierarchy__c(); // Capturing Issue Hierarchy related data on clone issue
        if(caseObj.Issue_Hierarchy_Code__c!=null){
            issuehObj = [select id,Issue_Type__r.Description__c,Product_Line__r.Name,Group__r.Description__c,Reason__r.Description__c,Cause__r.Description__c,
                             Classification__r.Description__c 
                             FROM Issue_Hierarchy__c 
                             WHERE id=:caseObj.Issue_Hierarchy_Code__c];
            caseObj.Product_Line__c=issuehObj.Product_Line__r.Name;
            caseObj.Issue_Type__c=issuehObj.Issue_Type__r.Description__c;
            caseObj.Reasontxt__c=issuehObj.Reason__r.Description__c;
            caseObj.Causetxt__c=issuehObj.Cause__r.Description__c;
            caseObj.Group_Code__c=issuehObj.Group__r.Description__c;
            caseObj.Classificationtxt__c=issuehObj.Classification__r.Description__c;
            issueSurveyRequired survey = new issueSurveyRequired();
        
             Boolean surApplicable = survey.surveyRequired(caseObj.Issue_Hierarchy_Code__c);
             
             if(surApplicable){
                 caseObj.Survey__c = 'Required';
             }else{
                 caseObj.Survey__c = 'Not Applicable';
             }
        }
            
        Brand_Hierarchy__c brandhObj= new Brand_Hierarchy__c();  // Capturing Brand Hierarchy related data on clone issue
        if(caseObj.Crc_Brand_Hierarchy_Code__c!=null){ 
            brandhObj = [select id, UPC__c,Taste__c,Cut__c,Packaging__c,Filter__c,Brand_Code__r.Name,Length__c,Flavor__c,PaperType__c
                         FROM Brand_Hierarchy__c 
                         WHERE id=:caseObj.Crc_Brand_Hierarchy_Code__c];
            
            caseObj.UPC_code__c=brandhObj.UPC__c;
            caseObj.Filter__c=brandhObj.Filter__c;
            caseObj.Taste__c=brandhObj.Taste__c;
            caseObj.Packaging__c=brandhObj.Packaging__c;
            caseObj.Brandcode__c=brandhObj.Brand_Code__r.Name;
            caseObj.Length_Code__c=brandhObj.Length__c;
            caseObj.Flavor__c=brandhObj.Flavor__c;
            caseObj.Paper_Type__c=brandhObj.PaperType__c;
            caseObj.Cut__c=brandhObj.Cut__c;
                
        }
        updateTraceCodeData();
        
        Database.SaveResult insRst = Database.insert(caseObj);
        if(insRst.isSuccess()){
            /*if(!oldSurveyIssue.isEmpty() && oldSurveyIssue.size() >0)
            update oldSurveyIssue; */
            TransactionMgmtHelper mgmtHelper = new TransactionMgmtHelper();
            Transaction_Management__c tranObj = [Select Id, Contact__c From Transaction_Management__c Where id =: tranId limit 1];
            mgmtHelper.createTransactionMgmtHistoryRecord('CREATEISSUE',String.valueOf(insRst.getId()));
            if(conObj.id != null && isRepeatCom == true && !conObj.Repeat_Complainer__c){
                conObj.Repeat_Complainer__c = true;
                system.debug('--463---'+conObj.Repeat_Complainer_Date__c);
                if(conObj.Repeat_Complainer_Date__c == null){
                    conObj.Repeat_Complainer_Date__c = System.today();
                }
                update conObj;
            }
        }
        list<Store__c> lstStoreClone = new list<Store__c>(); // Capturing store related data on clone issue
        list<Store__c> lstStore = [Select Transaction_Management__c, Store_Zip__c, Store_Type__c, Store_State__c, Store_Comment__c, Store_City__c, Store_Address2__c, Store_Address1__c, 
                                   Name, Issue__c, Id From Store__c Where Issue__c =: cloneIssueId];
        for(Store__c store : lstStore){
            Store__c newStore = new Store__c();
            newStore = store.clone(false, true);
            newStore.Issue__c = caseObj.id;
            newStore.Transaction_Management__c = tranId;
            lstStoreClone.add(newStore);
        }
        if(lstStoreClone != null && lstStoreClone.size() > 0){
            insert lstStoreClone;
        }
            
        PageReference pageRef = new PageReference('/apex/Issue_Detail?id='+caseObj.Id);
        return pageRef;
        }
        catch(DMLException e){// Validation rule PurchaseQty_and_Affected_Qty and PurchaseQty_and_Exp_Qty will be effective
            String errMsg = e.getMessage();
            ApexPages.addMessages(e);   
            return null;
        }
    }
    public PageReference DateCodeValidation(){
        System.debug('test caseObj.Brandcode__c '+caseObj.Brandcode__c);
        caseObj.Date_Type__c = '';
        caseObj.Date__c = null;
        dateCodeDate = '';
        caseObj.ValidUstdateCode__c  = false;
        dateCodeError = '';
        Product_Line__c ProductLineCode;
        if(productLineMap.ContainsKey(selectedProductLine)){
            ProductLineCode = productLineMap.get(selectedProductLine);
        }
        if(ProductLineCode.isValidDateCode__c){
            caseObj.Date_Type__c = '';
            caseObj.Date__c = null;
            dateCodeDate = '';
            String BH = caseObj.Crc_Brand_Hierarchy_Code__c;
            if(BH != null && BH != ''){
                
                if(caseObj.Date_Code__c == null ||  caseObj.Date_Code__c == ''){
                    return null;
                }
                caseObj.Trace_Code_Location__c =  selectedTraceCodeLocation;
                if(caseObj.Trace_Code_Location__c == null || caseObj.Trace_Code_Location__c == ''){
                    dateCodeError = 'Please choose Trace Code Location before entering Date Code.';
                    ApexPages.addMessage(new ApexPages.Message(apexpages.severity.Error, dateCodeError ));
                    caseObj.Date_Code__c = '';
                    return null;
                }            
                if(productLineMap.ContainsKey(selectedProductLine)){
                    ProductLineCode = productLineMap.get(selectedProductLine);                
                    
                    
                    if(ProductLineCode.Code__c != null && ProductLineCode.Operating_Company__c != null){                         
                        caseObj.PLCode__c = ProductLineCode.Code__c;             
                        UstDateCodeValidationHelper.ustTraceCode traceCodeObj = new UstDateCodeValidationHelper.ustTraceCode();
                        
                        UstDateCodeValidationHelper  ustHelper = new UstDateCodeValidationHelper();
                        traceCodeObj = ustHelper.ustTraceCodeValidation(ProductLineCode.Code__c,caseObj.Date_Code__c,ProductLineCode.Operating_Company__c, caseObj.Trace_Code_Location__c, caseObj.Crc_Brand_Hierarchy_Code__c);
                        system.debug('test traceCodeObj '+traceCodeObj);
                        if(traceCodeObj.ProductionDate != null && traceCodeObj.ProductionDate !=  '' && traceCodeObj.ProductionDate != 'fail'){
                            caseObj.Date__c =  date.parse(traceCodeObj.ProductionDate);
                            dateCodeDate = traceCodeObj.ProductionDate;
                            caseObj.ValidUstdateCode__c = true;
                            if(traceCodeObj.FinalUstTraceCode != null && traceCodeObj.FinalUstTraceCode != ''){
                                caseObj.Date_Type__c =  traceCodeObj.FinalUstTraceCode;
                            }
                        }else{
                            dateCodeError = 'You have entered an invalid date code';
                            ApexPages.addMessage(new ApexPages.Message(apexpages.severity.Error, dateCodeError ));
                            
                            return null;                         
                        }        
                    }
                
                }else{
                    dateCodeError = 'Please choose Product Line before entering Date Code.';            
                    ApexPages.addMessage(new ApexPages.Message(apexpages.severity.Error, dateCodeError ));
                    caseObj.Date_Code__c = '';
                    return null;            
                }            
            }else{
                dateCodeError = 'Please choose Brand Hierarchy before entering Date Code.';
                ApexPages.addMessage(new ApexPages.Message(apexpages.severity.Error, dateCodeError));
                caseObj.Date_Code__c = '';
                return null;
            }
        }
        return null;
    }
    
    
    public PageReference TraceCodeValidation(){
    
        caseObj.Production_date__c  = null;
        traceCodeErrorMessage = '';
        productLineId = '';
        traceCodeError = false;
        productionDate = null;
        caseObj.ValidTraceCode__c = false;
        if(caseObj.Mfg_Trace_code__c == null || caseObj.Mfg_Trace_code__c ==  ''){
            caseObj.Production_date__c = null;
            productionDate = '';
            return null;
        }
        caseObj.Trace_Code_Location__c =  selectedTraceCodeLocation;
        if((caseObj.Mfg_Trace_code__c != null && caseObj.Mfg_Trace_code__c !=  '') && caseObj.Trace_Code_Location__c == null || caseObj.Trace_Code_Location__c == ''){
            traceCodeErrorMessage = 'Please choose Trace Code  Location before entering Trace code.'; 
            ApexPages.addMessage(new ApexPages.Message(apexpages.severity.Error, traceCodeErrorMessage ));
            caseObj.Mfg_Trace_code__c = '';
            
            return null;
        }
        
        if(productLineMap.ContainsKey(selectedProductLine)){
                Product_Line__c ProductLineCode = productLineMap.get(selectedProductLine);
                
                if(ProductLineCode != null){
                    caseObj.PLCode__c = ProductLineCode.Code__c;
                    Boolean counterFeit  = TraceCodeHelper.checkCounterfeitTraceCode(caseObj.Mfg_Trace_code__c);
                    if(counterFeit){
                        caseObj.Suspected_Counterfiet__c = true;
                        traceCodeErrorMessage = 'Suspected Counterfeit. Please request product return and check Suspected Counterfeit box.'; 
                        ApexPages.addMessage(new ApexPages.Message(apexpages.severity.Error, traceCodeErrorMessage ));
                    }else{
                         caseObj.Suspected_Counterfiet__c = false;
                    }
                
                TraceCodeHelper traceHelper = new TraceCodeHelper();
                String productionDate1 = traceHelper.traceCodeValidation(ProductLineCode.Code__c,caseObj.Mfg_Trace_code__c,ProductLineCode.Operating_Company__c, caseObj.Trace_Code_Location__c);
                System.debug('pd date '+productionDate);
                if(productionDate1 != null &&  productionDate1 !=  '' && productionDate1 != 'fail'){
                    productionDate1 = productionDate1.replace('C','').replace('null','');
                    if(caseObj.Suspected_Counterfiet__c){
                        if(productionDate1 != null && productionDate1 != 'null' && productionDate1 !=  ''){
                            caseObj.Production_date__c = date.parse(productionDate1);
                        }
                    }else{
                        caseObj.Production_date__c = date.parse(productionDate1);
                        caseObj.ValidTraceCode__c = true;
                    }
                    productionDate = productionDate1;
                    ApexPages.getMessages().clear();
                }else{
                    if(!caseObj.Suspected_Counterfiet__c){
                        productLineId = ProductLineCode.id;
                        traceCodeErrorMessage = 'You have entered an invalid trace code. Please validate it before proceeding'; 
                        ApexPages.addMessage(new ApexPages.Message(apexpages.severity.Error, traceCodeErrorMessage ));
                        traceCodeError = true;
                    }
                }
            }                
         }else{            
            ApexPages.addMessage(new ApexPages.Message(apexpages.severity.Error, 'Please choose Product Line before entering Date Code.'));
            caseObj.Mfg_Trace_code__c = '';
            caseObj.Production_date__c = null;
            traceCodeErrorMessage  = '';
            return null;            
        }  
              
        return null;
    }
    
    public List<SelectOption> getTraceCodeLocation(){
    
        List<SelectOption> options=new List<SelectOption>();
        options.add(new SelectOption('','--None--'));
        if(productLineMap.ContainsKey(selectedProductLine)){
            Product_Line__c ProductLineCode = productLineMap.get(selectedProductLine);
            
            if(ProductLineCode.Trace_Code_Location__c != null && ProductLineCode.Trace_Code_Location__c != ''){
                String[] locations = ProductLineCode.Trace_Code_Location__c.split(';');
                
                if(!locations.isEmpty() && locations.size() >0){
                    for(integer i=0; i< locations.size()  ;i++){
                        options.add(new SelectOption(locations[i],locations[i]));
                    }
                }
                  
            }                
        }        
        return options;
    }
    
    // Reset blank if there is no Issue Hierarchy Code and Brand Hierarchy Code
    public PageReference resetHierarchy(){
        caseObj.Issue_Hierarchy_Code__c = null;
        caseObj.Crc_Brand_Hierarchy_Code__c = null;
        return null;
    }
    
    public PageReference cancelRedirect(){   
        PageReference pageRef = new PageReference('/apex/Issue_Detail?id='+caseObj.Id);
        pageRef.setRedirect(true);
        return pageRef;             
    }
    
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
}