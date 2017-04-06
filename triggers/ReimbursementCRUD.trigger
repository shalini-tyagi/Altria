trigger ReimbursementCRUD on Reimbursement__c (after insert) {
    if(Trigger.isInsert && Trigger.isAfter){
        //TBD- To create the fulfillment record for the Age Verfied Reimbursement records.
    }
}