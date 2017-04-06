trigger ContactCRUD on Contact (after update) {
    if(trigger.isUpdate && trigger.isAfter){
        ContactHelper conHelperObj = new ContactHelper();
        conHelperObj.updateReimbursement(Trigger.newMap, Trigger.oldMap);
    }
}