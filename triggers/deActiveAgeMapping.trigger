trigger deActiveAgeMapping on Age_Mapping__c (after update) {

    AgeMappingHandler ageObj = new AgeMappingHandler();
    
    ageObj.deActiveMapping(Trigger.newMap, Trigger.oldMap);
    
}