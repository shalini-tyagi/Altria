/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
/*
test class of issue detail page
07/18/2016 Infogain – Created.
*/


@isTest
private class IssueDetailControllerTest{

    // Testing constructor and checkMultipleReimbursements method when there is no reimbursement record created for the Issue
    // of IssueDetailControllerTest controller
    static testMethod void validateIssueDetailControllerNoReimbursement() {
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
        insert testCont;
        Case testCase = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id);
        insert testCase;
        ApexPages.currentPage().getParameters().put('issueId',testCase.Id); 
        Test.startTest();
            IssueDetailController controller = new IssueDetailController(new ApexPages.StandardController(testCase));
        Test.stopTest();
        system.assertEquals(false,controller.isReimbursed);
    }
    
    // Testing constructor and checkMultipleReimbursements method when there is a reimbursement record created for the Issue
    // of IssueDetailControllerTest controller
    static testMethod void validateIssueDetailController() {
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
        insert testCont;
        Case testCase = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id);
        insert testCase;
        Reimbursement__c testReimb = TestDataSetup.createReimbursement(testCase, 12);
        insert testReimb;
        Case tempIssue = new Case();
        ApexPages.currentPage().getParameters().put('issueId',testCase.Id); 
        Test.startTest();
            IssueDetailController controller = new IssueDetailController(new ApexPages.StandardController(testCase));
        Test.stopTest();
        system.assertEquals(true,controller.isReimbursed);
    }
    
    // Testing Store method of IssueDetailControllerTest controller
    static testMethod void validateStore() {
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
        insert testCont;
        Case testCase = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id);
        insert testCase;
        Case tempIssue = new Case();
        ApexPages.currentPage().getParameters().put('issueId',testCase.Id); 
        ApexPages.currentPage().getParameters().put('id',testCase.Id);
        Test.startTest();
            IssueDetailController controller = new IssueDetailController(new ApexPages.StandardController(testCase));
            Pagereference pgRef = controller.store();
        Test.stopTest();
        string expectedURL = '/apex/StoreEditPage?IssueId='+testCase.Id;
        system.assertEquals(expectedURL,pgRef.getUrl());
    }
   
    // Testing reimbursementNew method of IssueDetailControllerTest controller
    static testMethod void validateReimbursementNew() {
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
        insert testCont;
        Case testCase = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id);
        insert testCase;
        Case tempIssue = new Case();
        ApexPages.currentPage().getParameters().put('issueId',testCase.Id); 
        ApexPages.currentPage().getParameters().put('id',testCase.Id);
        Test.startTest();
            IssueDetailController controller = new IssueDetailController(new ApexPages.StandardController(testCase));
            Pagereference pgRef = controller.reimbursementNew();
        Test.stopTest();
        string expectedURL = '/apex/ReimbursementEdit?issueId='+testCase.Id;
        system.assertEquals(expectedURL,pgRef.getUrl());
    }
    
    // Testing edit method of IssueDetailControllerTest controller
    static testMethod void validateEdit() {
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
        insert testCont;
        Case testCase = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id);
        insert testCase;
        Case tempIssue = new Case();
        ApexPages.currentPage().getParameters().put('issueId',testCase.Id); 
        ApexPages.currentPage().getParameters().put('id',testCase.Id); 
        Test.startTest();
            IssueDetailController controller = new IssueDetailController(new ApexPages.StandardController(testCase));
            Pagereference pgRef = controller.edit();
        Test.stopTest();
        string expectedURL = '/apex/IssueEntryPage?id='+testCase.Id+'&tranId=null';
        system.assertEquals(expectedURL,pgRef.getUrl());
    }
    
    // Testing custom clone method of IssueDetailControllerTest controller
    static testMethod void validateCustomClone() {
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
        insert testCont;
        Case testCase = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id);
        insert testCase;
        ApexPages.currentPage().getParameters().put('id',testCase.Id); 
        Test.startTest();
            IssueDetailController controller = new IssueDetailController(new ApexPages.StandardController(testCase));
            controller.customClone();
        Test.stopTest();
        //system.assertEquals(testCase.purchase_price__c,1200);
    }
    
    static testMethod void validateConsumerDetails() {
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
        insert testCont;
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','PMUSA',true);
        insert testOpCo;
        TFN__c testTFN = TestDataSetup.createTFN(true, '1800', 45, testOpCo);
        insert testTFN;
        Transaction_Management__c testTM= TestDataSetup.createTM(testOpCo, testTFN);
        insert testTM;
        Case testCase = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id);
        testCase.ContactId = testCont.Id;
        testCase.Transaction__c = testTM.Id;
        insert testCase;
        ApexPages.currentPage().getParameters().put('id',testCase.Id); 
        Test.startTest();
            IssueDetailController controller = new IssueDetailController(new ApexPages.StandardController(testCase));
            controller.consumerDetails();
        Test.stopTest();
        //system.assertEquals(testCase.purchase_price__c,1200);
    }
}