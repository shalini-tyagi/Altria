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
@isTest
private class ConsumerDetailControllerTest {
	
    static testMethod void ConsumerDetailConstructor() {
        // TO DO: implement unit test
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
        Date bdate = Date.newInstance(1973, 08, 01);
        Contact testCont = TestDataSetup.createContact('John','Cope',testAcc.Id,true,'94544',bdate,'511 SYCAMORE AVE', true, true);
        testCont.Email = 'test123@test.com';
        testCont.City__c = 'HAYWARD';
        testCont.State__c = 'CA';
        testCont.Title = 'Mr';
        insert testCont;
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','PMUSA',true);
        insert testOpCo;
        TFN__c testTFN = TestDataSetup.createTFN(true, '1800', 45, testOpCo);
        insert testTFN;
        Transaction_Management__c testTM= TestDataSetup.createTM(testOpCo, testTFN);
        insert testTM;
        ApexPages.currentPage().getParameters().put('from','Search');
        ApexPages.currentPage().getParameters().put('Lname',testCont.LastName);
        ApexPages.currentPage().getParameters().put('Title',testCont.Title);
        ApexPages.currentPage().getParameters().put('Addr1',testCont.Apt_Lot__c);
        ApexPages.currentPage().getParameters().put('add',testCont.Street_Address__c);
        ApexPages.currentPage().getParameters().put('City',testCont.City__c);
        ApexPages.currentPage().getParameters().put('State',testCont.State__c);
        ApexPages.currentPage().getParameters().put('dob',testCont.Birthdate__c);
        ApexPages.currentPage().getParameters().put('zip',testCont.Zip_Code__c);
        ApexPages.currentPage().getParameters().put('CCN',testCont.CCN__c);
        ApexPages.currentPage().getParameters().put('strAVCode',testCont.AV_Code__c);
        ApexPages.currentPage().getParameters().put('email',testCont.Email_Address__c);
        ApexPages.currentPage().getParameters().put('country',testCont.Country__c);
        ApexPages.currentPage().getParameters().put('phone',testCont.Phone);
        ApexPages.currentPage().getParameters().put('tranid', testTM.Id);
        ApexPages.currentPage().getParameters().put('Fname',testCont.Id);
        ApexPages.currentPage().getParameters().put('email',testCont.Email);
        
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
            //LexisNexisCallout serviceURL = new LexisNexisCallout('Age Verification','PMUSA');
        	ConsumerDetailController controller = new ConsumerDetailController(new ApexPages.StandardController(testCont));
            //controller.ageVerify();
        Test.stopTest();
          //System.assertEquals('Fname', controller.conObj.FirstName );
    
    }
    static testMethod void validateGetcitystate() {
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('John','Cope',testAcc.Id,true,'94544',bdate,'511 SYCAMORE AVE', true, true);
		testCont.Country__c = 'United States';
        testCont.City__c = 'Huntsville';
        insert testCont;
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
        	System.debug('**************Tran ID***************'+tranID);
        	ConsumerDetailController controller = new ConsumerDetailController(new ApexPages.StandardController(testCont));
            controller.FormName = 'Consumer Detail';
        	controller.getcitystate();
        Test.stopTest();
  
    }
    static testMethod void validateEditConsumer() {
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
		insert testCont;
         Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
        insert testOpCo;
        Test.startTest();
            ConsumerDetailController controller = new ConsumerDetailController(new ApexPages.StandardController(testCont));
            controller.editConsumer();
        Test.stopTest();
    }
   /* static testMethod void validateGetaddressverified() {
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('John','Cope',testAcc.Id,true,'94544',bdate,'511 SYCAMORE AVE', true, true);
		insert testCont;
         Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
        insert testOpCo;
        Test.startTest();
        	ConsumerDetailController controller = new ConsumerDetailController(new ApexPages.StandardController(testCont));
            controller.getaddressverified();
        Test.stopTest();
    }
    static testMethod void validateGetaddressverifiedUS() {
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('John','Cope',testAcc.Id,true,'94544',bdate,'511 SYCAMORE AVE', true, true);
		testCont.Country__c = 'United States';
        testCont.City__c = 'Grand Rapids';
        testCont.State__c = 'MI';
        insert testCont;
         Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
        insert testOpCo;
        Test.startTest();
        	System.debug('*********Contact Country**********'+testCont.Country__c);
        	System.debug('*********Label Country**********'+Label.Country);
            ConsumerDetailController controller = new ConsumerDetailController(new ApexPages.StandardController(testCont));
            controller.getaddressverified();
        Test.stopTest();
    }*/
    
    static testMethod void validateSave() {
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('John','Cope',testAcc.Id,true,'94544',bdate,'511 SYCAMORE AVE', true, true);
      	insert testCont;
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
        insert testOpCo;
        TFN__c testTFN = TestDataSetup.createTFN(true, '1800', 45, testOpCo);
        insert testTFN;
        Transaction_Management__c testTM= TestDataSetup.createTM(testOpCo, testTFN);
        insert testTM;
        Case testCase = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id);
       	testCase.Transaction__c = testTM.Id;
        insert testCase;
        ApexPages.currentPage().getParameters().put('from','Search');
        /*ApexPages.currentPage().getParameters().put('Fname',testCont.FirstName);
        ApexPages.currentPage().getParameters().put('Lname',testCont.LastName);
        ApexPages.currentPage().getParameters().put('Title',testCont.Title);
        ApexPages.currentPage().getParameters().put('Addr1',testCont.Apt_Lot__c);
        ApexPages.currentPage().getParameters().put('add',testCont.Street_Address__c);
        ApexPages.currentPage().getParameters().put('City',testCont.City__c);
        ApexPages.currentPage().getParameters().put('State',testCont.State__c);
        ApexPages.currentPage().getParameters().put('dob',testCont.Birthdate__c);
        ApexPages.currentPage().getParameters().put('zip',testCont.Zip_Code__c);
        ApexPages.currentPage().getParameters().put('CCN',testCont.CCN__c);
        ApexPages.currentPage().getParameters().put('strAVCode',testCont.AV_Code__c);
        ApexPages.currentPage().getParameters().put('email',testCont.Email_Address__c);
        ApexPages.currentPage().getParameters().put('country',testCont.Country__c);
        ApexPages.currentPage().getParameters().put('phone',testCont.Phone);*/
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
            ConsumerDetailController controller = new ConsumerDetailController(new ApexPages.StandardController(testCont));
        	controller.save();
        Test.stopTest();
    }
    static testMethod void validateSaveElse() {
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('John','Cope',testAcc.Id,true,'94544',bdate,'511 SYCAMORE AVE', true, true);
      	insert testCont;
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
        insert testOpCo;
        TFN__c testTFN = TestDataSetup.createTFN(true, '1800', 45, testOpCo);
        insert testTFN;
        Transaction_Management__c testTM= TestDataSetup.createTM(testOpCo, testTFN);
        insert testTM;
        Case testCase = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id);
       	testCase.Transaction__c = testTM.Id;
        insert testCase;
        ApexPages.currentPage().getParameters().put('from','Search');
        /*ApexPages.currentPage().getParameters().put('Fname',testCont.FirstName);
        ApexPages.currentPage().getParameters().put('Lname',testCont.LastName);
        ApexPages.currentPage().getParameters().put('Title',testCont.Title);
        ApexPages.currentPage().getParameters().put('Addr1',testCont.Apt_Lot__c);
        ApexPages.currentPage().getParameters().put('add',testCont.Street_Address__c);
        ApexPages.currentPage().getParameters().put('City',testCont.City__c);
        ApexPages.currentPage().getParameters().put('State',testCont.State__c);
        ApexPages.currentPage().getParameters().put('dob',testCont.Birthdate__c);
        ApexPages.currentPage().getParameters().put('zip',testCont.Zip_Code__c);
        ApexPages.currentPage().getParameters().put('CCN',testCont.CCN__c);
        ApexPages.currentPage().getParameters().put('strAVCode',testCont.AV_Code__c);
        ApexPages.currentPage().getParameters().put('email',testCont.Email_Address__c);
        ApexPages.currentPage().getParameters().put('country',testCont.Country__c);
        ApexPages.currentPage().getParameters().put('phone',testCont.Phone);*/
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
            ConsumerDetailController controller = new ConsumerDetailController(new ApexPages.StandardController(testCont));
        	controller.save();
        Test.stopTest();
    }
    static testMethod void validateSaveNoContact() {
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('John','Cope',testAcc.Id,true,'94544',bdate,'511 SYCAMORE AVE', true, true);
      	//insert testCont;
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
        insert testOpCo;
        TFN__c testTFN = TestDataSetup.createTFN(true, '1800', 45, testOpCo);
        insert testTFN;
        Transaction_Management__c testTM= TestDataSetup.createTM(testOpCo, testTFN);
        insert testTM;
        Case testCase = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id);
       	testCase.Transaction__c = testTM.Id;
        insert testCase;
        ApexPages.currentPage().getParameters().put('from','Search');
        /*ApexPages.currentPage().getParameters().put('Fname',testCont.FirstName);
        ApexPages.currentPage().getParameters().put('Lname',testCont.LastName);
        ApexPages.currentPage().getParameters().put('Title',testCont.Title);
        ApexPages.currentPage().getParameters().put('Addr1',testCont.Apt_Lot__c);
        ApexPages.currentPage().getParameters().put('add',testCont.Street_Address__c);
        ApexPages.currentPage().getParameters().put('City',testCont.City__c);
        ApexPages.currentPage().getParameters().put('State',testCont.State__c);
        ApexPages.currentPage().getParameters().put('dob',testCont.Birthdate__c);
        ApexPages.currentPage().getParameters().put('zip',testCont.Zip_Code__c);
        ApexPages.currentPage().getParameters().put('CCN',testCont.CCN__c);
        ApexPages.currentPage().getParameters().put('strAVCode',testCont.AV_Code__c);
        ApexPages.currentPage().getParameters().put('email',testCont.Email_Address__c);
        ApexPages.currentPage().getParameters().put('country',testCont.Country__c);
        ApexPages.currentPage().getParameters().put('phone',testCont.Phone);*/
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
        	ConsumerDetailController controller = new ConsumerDetailController(new ApexPages.StandardController(testCont));
        	controller.save();
        Test.stopTest();
    }
    static testMethod void validateNewIssue() {
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('John','Cope',testAcc.Id,true,'94544',bdate,'511 SYCAMORE AVE', true, true);
		insert testCont;
       	Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
        insert testOpCo;
        Test.startTest();
            ConsumerDetailController controller = new ConsumerDetailController(new ApexPages.StandardController(testCont));
            controller.newIssue();
        Test.stopTest();
    }
    
    /*static testMethod void AgeVerifyTest() {
        // TO DO: implement unit test
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
        Date bdate = Date.newInstance(1973, 08, 01);
        Contact testCont = TestDataSetup.createContact('John','Cope',testAcc.Id,true,'94544',bdate,'511 SYCAMORE AVE', true, true);
        testCont.Email = 'test123@test.com';
        testCont.City__c = 'HAYWARD';
        testCont.State__c = 'CA';
        insert testCont;
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','PMUSA',true);
        insert testOpCo;
        TFN__c testTFN = TestDataSetup.createTFN(true, '1800', 45, testOpCo);
        insert testTFN;
        Transaction_Management__c testTM= TestDataSetup.createTM(testOpCo, testTFN);
        insert testTM;
        ApexPages.currentPage().getParameters().put('tranid', testTM.Id);
        ApexPages.currentPage().getParameters().put('Fname',testCont.Id);
        ApexPages.currentPage().getParameters().put('email',testCont.Email);
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
            LexisNexisCallout serviceURL = new LexisNexisCallout('Age Verification','PMUSA');
        	ConsumerDetailController controller = new ConsumerDetailController(new ApexPages.StandardController(testCont));
            controller.ageVerify();
        Test.stopTest();
          //System.assertEquals('Fname', controller.conObj.FirstName );
    
    }*/
}