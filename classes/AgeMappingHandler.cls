public class AgeMappingHandler {
    
    public void deActiveMapping(Map<id, Age_Mapping__c>  newMap, Map<id, Age_Mapping__c>  oldmap){
        
        Map<String,Integer> stateList = new Map<String,Integer>();
        for(Age_Mapping__c  ageObj : newMap.values()){
            if(ageObj.Active__c && ageObj.Age__c != oldmap.get(ageObj.id).Age__c && (ageObj.Zip__c ==  null || ageObj.Zip__c == '')){
                if(!stateList.containsKey(ageObj.Name))
                	stateList.put(ageObj.Name,Integer.ValueOf(ageObj.Age__c));                
            }
        }
        
        if(!stateList.isEmpty()){
            List<Age_Mapping__c> ageList = new List<Age_Mapping__c>([Select id, age__c, name,Active__c from Age_Mapping__c where zip__c != null and zip__c != '' and Active__c = true and Name in :stateList.Keyset()]);
            List<Age_Mapping__c> ageUpdateList = new List<Age_Mapping__c>();
            if(!ageList.isEmpty()){
                for(Age_Mapping__c  ageObj  :ageList){
                    if(stateList.ContainsKey(ageObj.Name) && ageObj.Age__c >  stateList.get(ageObj.Name)){
                        ageObj.Active__c = false;
                        ageUpdateList.add(ageObj);
                    }
                }
            }
            
            if(!ageUpdateList.isEmpty()){
                update ageUpdateList;
            }
        }   
    }
}