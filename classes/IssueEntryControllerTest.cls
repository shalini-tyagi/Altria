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
test class of issue entry page
07/18/2016 Infogain – Created.
*/

@isTest(SeeAllData=true)
private class IssueEntryControllerTest{
    
    // Testing constructor of IssueEntryControllerTest controller
    static testMethod void validateIssueEntryController() {
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
        insert testCont;
        Classification__c testClsfy = TestDataSetup.createClassify('Test Classification');
        insert testClsfy;
        Product_Line__c testPL = TestDataSetup.createPL('Test Product Line');
        insert testPL;
        Issue_Type__c testIT = TestDataSetup.createIT('Test Cause');
        insert testIT;
        Group__c testGroup = TestDataSetup.createGroup('Test Group');
        insert testGroup;
        Cause__c testCause = TestDataSetup.createCause('Test Cause');
        insert testCause;
        Reason__c testReason = TestDataSetup.createReason('Test Reason');
        insert testReason;
        Issue_Hierarchy__c testIH = TestDataSetup.createIH(testClsfy, testPL, testIT, testGroup, testCause, testReason, true);
        insert testIH;
        Brand__c testBrand = TestDataSetup.createBrand('Test Brand');
        insert testBrand;
        Brand_Hierarchy__c testBH = TestDataSetup.createBH('Full Flavor', '100s', 'Soft Pack', 'Menthol', 'Filtered', 'Banded Paper Ny', 'Ready', '12345',testBrand, testPL);
        insert testBH;
        Case testCase = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id);
        testCase.Issue_Hierarchy_Code__c = testIH.Id;
        testCase.Crc_Brand_Hierarchy_Code__c = testBH.Id;
        insert testCase;
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
        insert testOpCo;
        TFN__c testTFN = TestDataSetup.createTFN(true, '1800', 45, testOpCo);
        insert testTFN;
        Transaction_Management__c testTM= TestDataSetup.createTM(testOpCo, testTFN);
        insert testTM;
        Cookie tranId = ApexPages.currentPage().getCookies().get('tranId');
    
        // If this is the first time the user is accessing the page, 
        // create a new cookie with name 'counter', an initial value of '1', 
        // path 'null', maxAge '-1', and isSecure 'false'. 
        
            tranId = new Cookie('tranId',testTM.id,null,-1,false);
        
        // If this isn't the first time the user is accessing the page
        // create a new cookie, incrementing the value of the original count by 1
        // Set the new cookie for the page
        ApexPages.currentPage().setCookies(new Cookie[]{tranId});
        Test.startTest();
            IssueEntryController controller = new IssueEntryController(new ApexPages.StandardController(testCase));
            controller.save();
        Test.stopTest();
        system.assertEquals(true,(controller.productLineList).size() > 0);
    }
    
    // Testing save method of IssueEntryControllerTest controller
    static testMethod void validateSave() {
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
        insert testCont;
        Classification__c testClsfy = TestDataSetup.createClassify('Test Classification');
        insert testClsfy;
        Product_Line__c testPL = TestDataSetup.createPL('Test Product Line');
        insert testPL;
        Issue_Type__c testIT = TestDataSetup.createIT('Test Cause');
        insert testIT;
        Group__c testGroup = TestDataSetup.createGroup('Test Group');
        insert testGroup;
        Cause__c testCause = TestDataSetup.createCause('Test Cause');
        insert testCause;
        Reason__c testReason = TestDataSetup.createReason('Test Reason');
        insert testReason;
        Issue_Hierarchy__c testIH = TestDataSetup.createIH(testClsfy, testPL, testIT, testGroup, testCause, testReason, true);
        insert testIH;
        Brand__c testBrand = TestDataSetup.createBrand('Test Brand');
        insert testBrand;
        Brand_Hierarchy__c testBH = TestDataSetup.createBH('Full Flavor', '100s', 'Soft Pack', 'Menthol', 'Filtered', 'Banded Paper Ny', 'Ready','12345', testBrand, testPL);
        insert testBH;
        Case testCase = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id);
        testCase.Issue_Hierarchy_Code__c = testIH.Id;
        testCase.Crc_Brand_Hierarchy_Code__c = testBH.Id;
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
        insert testOpCo;
        TFN__c testTFN = TestDataSetup.createTFN(true, '1800', 45, testOpCo);
        insert testTFN;
        Transaction_Management__c testTM= TestDataSetup.createTM(testOpCo, testTFN);
        insert testTM;
        /* checking issueid should not be null*/
        ApexPages.currentPage().getParameters().put('issueId',testCase.Id); 
        Test.startTest();
         IssueEntryController controller = new IssueEntryController(new ApexPages.StandardController(testCase));
         controller.save();
        Test.stopTest();
        Issue_Hierarchy__c issuehObj = [Select Id,Product_Line__r.name From Issue_Hierarchy__c Where Id =: testIH.id limit 1];
        system.assertEquals(issuehObj.Product_Line__r.name, controller.caseObj.Product_Line__c);
        system.assertEquals(testBH.Filter__c, controller.caseObj.Filter__c);
    }
    
    /* Testing Cancel method for if condition of IssueEntryController */
    static testMethod void validateCancel() {
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
        insert testCont;
        Case testCase = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id);
        insert testCase;
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
        insert testOpCo;
        TFN__c testTFN = TestDataSetup.createTFN(true, '1800', 45, testOpCo);
        insert testTFN;
        Transaction_Management__c testTM= TestDataSetup.createTM(testOpCo, testTFN);
        insert testTM;
        PageReference pagereftest = new PageReference('/apex/Issue_Detail?id='+testCase.Id);
        ApexPages.currentPage().getParameters().put('issueId',testCase.Id); 
        Test.startTest();
            IssueEntryController controller = new IssueEntryController(new ApexPages.StandardController(testCase));
            System.assertEquals(pagereftest.getUrl(),controller.Cancel().getUrl());
        Test.stopTest();     
    }
    
    // Testing Cancel method for else condition of IssueEntryControllerTest controller
    static testMethod void validateCancel1() {
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
        insert testCont;
        Case testCase = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id);
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
        insert testOpCo;
        TFN__c testTFN = TestDataSetup.createTFN(true, '1800', 45, testOpCo);
        insert testTFN;
        Transaction_Management__c testTM= TestDataSetup.createTM(testOpCo, testTFN);
        insert testTM;
        PageReference pagereftest = new PageReference('/500');
        Test.startTest();
           IssueEntryController controller = new IssueEntryController(new ApexPages.StandardController(testCase));
           PageReference pageref = controller.Cancel();
        Test.stopTest();
        system.assertEquals(pagereftest.getUrl(),pageref.getUrl());
    }
    
    // Testing customSave method for if condition of IssueEntryControllerTest controller
    static testMethod void validateCustomSave() {
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
        insert testCont;
        Case testCase = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id);
        insert testCase;
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
        insert testOpCo;
        TFN__c testTFN = TestDataSetup.createTFN(true, '1800', 45, testOpCo);
        insert testTFN;
        Transaction_Management__c testTM= TestDataSetup.createTM(testOpCo, testTFN);
        insert testTM;
        Store_Type__c testStoretype = TestDataSetup.createStoreType('ST10','Other');
        insert testStoretype;
        Store__c testStore = TestDataSetup.createStore('WallMart',testStoretype);
        testStore.Issue__c = testCase.id;
        insert testStore;
        ApexPages.currentPage().getParameters().put('issueId',testCase.Id); 
        ApexPages.currentPage().getParameters().put('parentIssue',testCase.Id); 
        Test.startTest();
            IssueEntryController controller = new IssueEntryController(new ApexPages.StandardController(testCase));
            PageReference pageref = controller.customSave();
            PageReference pagereftest = new PageReference('/apex/Issue_Detail?id='+testCase.Id);
        Test.stopTest();
        system.assertEquals(pagereftest.getUrl(),pageref.getUrl());
    }
    
    // Testing customCancel method of IssueEntryControllerTest controller
    static testMethod void validateCustomCancel() {
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
        insert testCont;
        Case testCase = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id);
        insert testCase;
        ApexPages.currentPage().getParameters().put('parentIssue',testCase.Id);
        Test.startTest();
            IssueEntryController controller = new IssueEntryController(new ApexPages.StandardController(testCase));
             PageReference pageref = controller.customSave();
           PageReference pagereftest = new PageReference('/apex/Issue_Detail?id='+controller.cloneIssueId);
        Test.stopTest();
        system.assertEquals(pagereftest.getUrl(),pageref.getUrl());
    }
    
    // Testing resetHierarchy method of IssueEntryControllerTest controller
    static testMethod void validateResetHierarchy() {
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
        insert testCont;
        Case testCase = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id);
        insert testCase;
        Test.startTest();
            IssueEntryController controller = new IssueEntryController(new ApexPages.StandardController(testCase));
            controller.resetHierarchy();
        Test.stopTest();
        system.assertEquals(controller.caseObj.Issue_Hierarchy_Code__c,controller.caseObj.Crc_Brand_Hierarchy_Code__c);
    }
           
    // Testing customSave method for else condition of IssueEntryControllerTest controller
    static testMethod void validatecustomSave1() {
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
        insert testCont;
        Classification__c testClsfy = TestDataSetup.createClassify('Test Classification');
        insert testClsfy;
        Product_Line__c testPL = TestDataSetup.createPL('Test Product Line');
        insert testPL;
        Issue_Type__c testIT = TestDataSetup.createIT('Test Cause');
        insert testIT;
        Group__c testGroup = TestDataSetup.createGroup('Test Group');
        insert testGroup;
        Cause__c testCause = TestDataSetup.createCause('Test Cause');
        insert testCause;
        Reason__c testReason = TestDataSetup.createReason('Test Reason');
        insert testReason;
        Issue_Hierarchy__c testIH = TestDataSetup.createIH(testClsfy, testPL, testIT, testGroup, testCause, testReason, true);
        insert testIH;
        Brand__c testBrand = TestDataSetup.createBrand('Test Brand');
        insert testBrand;
        Brand_Hierarchy__c testBH = TestDataSetup.createBH('Full Flavor', '100s', 'Soft Pack', 'Menthol', 'Filtered', 'Banded Paper Ny', 'Ready','12345', testBrand, testPL);
        insert testBH;
        Case testCase = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id);
        insert testCase;
        testCase.Issue_Hierarchy_Code__c = testIH.Id;
        testCase.Crc_Brand_Hierarchy_Code__c = testBH.Id;
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
        insert testOpCo;
        TFN__c testTFN = TestDataSetup.createTFN(true, '1800', 45, testOpCo);
        insert testTFN;
        Transaction_Management__c testTM= TestDataSetup.createTM(testOpCo, testTFN);
        insert testTM;
        ApexPages.currentPage().getParameters().put('issueId',testCase.Id);
        ApexPages.currentPage().getParameters().put('parentIssue',testCase.Id);  
        Test.startTest();
            IssueEntryController controller = new IssueEntryController(new ApexPages.StandardController(testCase));
            controller.customSave();
        Test.stopTest();
        Issue_Hierarchy__c issuehObj = [Select Id,Product_Line__r.name From Issue_Hierarchy__c Where Id =: testIH.id limit 1];
        system.assertEquals(issuehObj.Product_Line__r.name, controller.caseObj.Product_Line__c);
        system.assertEquals(testBH.Filter__c, controller.caseObj.Filter__c);
    }
}