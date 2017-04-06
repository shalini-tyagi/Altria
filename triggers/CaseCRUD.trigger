trigger CaseCRUD on Case (before insert, before update) {
    if(trigger.isBefore && (trigger.isUpdate || trigger.isInsert)){
        CaseHelper helperObj = new CaseHelper();
        helperObj.calculateOverage(trigger.new);
    }
}