public class CaseHelper{
    public void calculateOverage(list<Case> lstCaseUpdate){
        DateTime date1;
        Datetime date2;
        Datetime date3;
        Datetime date4;
        Datetime date5;
        set<string> setUstDateCodeType = new set<string>();
        setUstDateCodeType.add('CD');
        setUstDateCodeType.add('MD'); 
        setUstDateCodeType.add('SN');
        setUstDateCodeType.add('WB');
        list<Id> lstBHId = new list<Id>();
        set<string> setProdLine = new set<string>();
        Map<Case, String> mapCaseBH = new Map<Case, String>();
        integer pickUpPolicyWeeks ;
        
        for(Case c : lstCaseUpdate){
            lstBHId.add(c.Crc_Brand_Hierarchy_Code__c);
        }
        
        list<Brand_Hierarchy__c> lstBH = [Select Id, Pick_Up_Policy_Weeks__c From Brand_Hierarchy__c Where id in: lstBHId];
        
        List<OverageCalculationProductLine__c> lstProdLine = OverageCalculationProductLine__c.getAll().values();
        for(OverageCalculationProductLine__c ocpl : lstProdLine){
            setProdLine.add(ocpl.Name);
        }
        
        for(case issue : lstCaseUpdate){
            for(Brand_Hierarchy__c bh : lstBH){
                if(bh.Id == issue.Crc_Brand_Hierarchy_Code__c){
                    mapCaseBH.put(issue, bh.Pick_Up_Policy_Weeks__c);
                }
            }
        }
        
        for(case issue : lstCaseUpdate){ 
            pickUpPolicyWeeks = 0;
            if(mapCaseBH != null && mapCaseBH.get(issue) != null && mapCaseBH.get(issue) != 'NULL'){
                pickUpPolicyWeeks = Integer.valueof(mapCaseBH.get(issue));
            }
            
            if(setProdLine.contains(issue.Product_Line__c)){
                if(issue.Incident_Date__c != null){
                    date1 = issue.Incident_Date__c;
                }else if(issue.createddate != null){
                    date1 = issue.createddate;
                }else{
                    date1 = Datetime.newInstance(1900, 1, 1);
                } 
                
                if(issue.Date__c != null ){
                    date2 = issue.Date__c.addDays(0);
                    date3 = issue.Date__c.addDays(pickUpPolicyWeeks*7+4);
                }else{ 
                    date2 = Datetime.newInstance(1900, 1, 1);
                    date3 = Datetime.newInstance(1900, 1, 1);
                }
                
                if(issue.Date__c != null){
                    date4 = issue.Date__c;
                }else if(issue.createddate != null){
                    date4 = issue.createddate;
                }else{
                    date4 = issue.Incident_Date__c;
                }
                
                if(issue.createddate != null){
                    date5 = issue.createddate;
                }else{
                    date5 = issue.Incident_Date__c;
                }
                
                if((pickUpPolicyWeeks != null && pickUpPolicyWeeks == 0) || (issue.Date_Code__c != null && issue.Date_Code__c == 'N')|| (issue.Date_Type__c != null && issue.Date_Type__c == 'N') || (issue.Date__c != null) || (issue.Date_Code__c == 'WB')){
                    issue.Overage__c = '';
                }else if(issue.Date_Code__c == 'SB'){
                    if(issue.Date__c != NULL ){
                        issue.Overage__c = '';
                    }else if(date1 != null && date2 != null && date1 > date2){
                        issue.Overage__c = 'Y';
                    }else{
                        issue.Overage__c = 'N';
                    }
                }else{
                    if(issue.Date_Code__c != null && setUstDateCodeType.contains(issue.Date_Code__c)){
                        if(issue.Date__c == NULL){
                            issue.Overage__c = '';
                        }else if(date1 != null && date3 != null && date1 > date3){
                            issue.Overage__c = 'Y';
                        }else{
                            issue.Overage__c = 'N';
                        }
                    }else{
                        if(date4 != null && date5 != null && (Date.valueOf(date4)).daysBetween(Date.valueOf(date5)) > 0){
                            issue.Overage__c = 'Y';
                        }else{
                            issue.Overage__c = 'N';
                        }
                    }
                }
            }
        }
    }
}