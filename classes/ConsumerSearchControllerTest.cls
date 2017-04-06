/*
test class of Consumer Search
08/02/2016 Infogain – Created.
*/
@isTest(SeeAllData=true)
private class ConsumerSearchControllerTest{
     // validate constructor
    static testMethod void validateConsumerSearchConstructor() {
 
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
        insert testCont;
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','PMUSA',true);
        insert testOpCo;
        Case testCase = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id);
        insert testCase;
        TFN__c testTFN= TestDataSetup.createTFN(True,'0001',1,testOpCo);
        insert testTFN;
        Transaction_Management__c testTM= TestDataSetup.createTM(testOpCo,testTFN);
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
        ApexPages.currentPage().getParameters().put('hideIsssue',testCase.Id);
        Test.StartTest();
        ConsumerSearchController controller = new ConsumerSearchController(new ApexPages.StandardController(testCont));
        Test.StopTest();
    }
       // validate Clear method
        static testMethod void validateClear() {
 
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
        insert testCont;
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','PMUSA',true);
        insert testOpCo;
        Case testCase = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id);
        insert testCase;
        TFN__c testTFN= TestDataSetup.createTFN(True,'0001',1,testOpCo);
        insert testTFN;
        Transaction_Management__c testTM= TestDataSetup.createTM(testOpCo,testTFN);
        insert testTM;
        ApexPages.currentPage().getParameters().put('tranId',testTM.Id);
        ApexPages.currentPage().getParameters().put('hideIsssue',testCase.Id);
        Test.StartTest();
        ConsumerSearchController controller = new ConsumerSearchController(new ApexPages.StandardController(testCont));
        controller.Clear();
        Test.StopTest();
    }
    
   /* static testMethod void validateConsumerSearchCreateTranIf() {
 
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
        insert testCont;
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','PMUSA',true);
        insert testOpCo;
        Case testCase = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id);
        insert testCase;
        TFN__c testTFN= TestDataSetup.createTFN(True,'0001',1,testOpCo);
        insert testTFN;
        Transaction_Management__c testTM= TestDataSetup.createTM(testOpCo,testTFN);
        insert testTM;
        //ApexPages.currentPage().getParameters().put('tranid',testTM.Id);
        Test.startTest();
            ConsumerSearchController controller = new ConsumerSearchController(new ApexPages.StandardController(testCont));
        Test.stopTest();
    }
            
        static testMethod void validateConsumerSearchCreateTranElse() {
 
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
        insert testCont;
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','PMUSA',true);
        insert testOpCo;
        Case testCase = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id);
        insert testCase;
        TFN__c testTFN= TestDataSetup.createTFN(True,'0001',1,testOpCo);
        insert testTFN;
        Transaction_Management__c testTM= TestDataSetup.createTM(testOpCo,testTFN);
        insert testTM;
        ApexPages.currentPage().getParameters().put('tranid',testTM.Id);
        Test.startTest();
            ConsumerSearchController controller = new ConsumerSearchController(new ApexPages.StandardController(testCont));
        Test.stopTest();
    }
    
    static testMethod void validateConsumerSearchUpdateTranContact() {
 
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
        insert testCont;
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','PMUSA',true);
        insert testOpCo;
        Case testCase = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id);
        insert testCase;
        TFN__c testTFN= TestDataSetup.createTFN(True,'0001',1,testOpCo);
        insert testTFN;
        Transaction_Management__c testTM= TestDataSetup.createTM(testOpCo,testTFN);
        testTM.Contact__c = testCont.Id;
        insert testTM;
        ApexPages.currentPage().getParameters().put('selectedContactId',testCont.Id);
        ApexPages.currentPage().getParameters().put('tranid',testTM.Id);
        Test.startTest();
            ConsumerSearchController controller = new ConsumerSearchController(new ApexPages.StandardController(testCont));
        controller.updateTranContact();
        Test.stopTest();
    }*/
    
    /*static testMethod void validateConsumerSearchUpdateTranContactIfNull() {
 
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
        insert testCont;
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','PMUSA',true);
        insert testOpCo;
        TFN__c testTFN= TestDataSetup.createTFN(True,'0001',1,testOpCo);
        insert testTFN;
        Transaction_Management__c testTM= TestDataSetup.createTM(testOpCo,testTFN);
        //testTM.Contact__c = testCont.Id;
        insert testTM;
        Case testCase = TestDataSetup.createTestCase(testAcc, 1200, null);
        testCase.Transaction__c = testTM.Id;
        insert testCase;
        ApexPages.currentPage().getParameters().put('selectedContactId',testCont.Id);
        ApexPages.currentPage().getParameters().put('tranid',testTM.Id);
        Test.startTest();
            ConsumerSearchController controller = new ConsumerSearchController(new ApexPages.StandardController(testCont));
        Test.stopTest();
    }*/
    
    /*static testMethod void validateGetfullsearchList() {
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
        insert testCont;
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
        insert testOpCo;
        Case testCase = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id);
        insert testCase;
        TFN__c testTFN= TestDataSetup.createTFN(True,'0001',1,testOpCo);
        insert testTFN;
        Transaction_Management__c testTM= TestDataSetup.createTM(testOpCo,testTFN);
        insert testTM;
        Test.startTest();
            ConsumerSearchController controller = new ConsumerSearchController(new ApexPages.StandardController(testCont));
            controller.getfullsearchList();
        Test.stopTest();
    }*/
    // validate GetCityState method
    static testMethod void validateGetCityState() {
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
        testCont.Country__c = 'Canada';
        testCont.City__c = 'Huntsville';
        testCont.State__c = 'MI';
        insert testCont;
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
        insert testOpCo;
        Case testCase = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id);
        insert testCase;
        TFN__c testTFN= TestDataSetup.createTFN(True,'0001',1,testOpCo);
        insert testTFN;
        Transaction_Management__c testTM= TestDataSetup.createTM(testOpCo,testTFN);
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
        ConsumerSearchController controller = new ConsumerSearchController(new ApexPages.StandardController(testCont));
        controller.getCityState();
        Test.stopTest();
    }
    // validate GetCityState method else condition 
     static testMethod void validateGetCityStateElse() {
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
        testCont.Country__c = 'United States';
        testCont.City__c = 'Huntsville';
        testCont.State__c = 'MI';
        insert testCont;
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
        insert testOpCo;
        Case testCase = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id);
        insert testCase;
        TFN__c testTFN= TestDataSetup.createTFN(True,'0001',1,testOpCo);
        insert testTFN;
        Transaction_Management__c testTM= TestDataSetup.createTM(testOpCo,testTFN);
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
        //MelissaClasses.zipLookupResponse zipLookup = new MelissaClasses.zipLookupResponse();
        //zipLookup = MelissaServices.ZipLookupServiceRequest(testCont.Zip_Code__c,testTM.Id,'Consumer Search');
        //zipLookup.ErrorString = 'Test Error';
        Test.startTest();
        ConsumerSearchController controller = new ConsumerSearchController(new ApexPages.StandardController(testCont));
        controller.FormName = 'Search';
        controller.getCityState();
        Test.stopTest();
    }
    // validate Search method
     static testMethod void validateSearch() {
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('John','Cope',testAcc.Id,true,'94544',bdate,'511 SYCAMORE AVE', true, true);
        testCont.ccn__c = '123'; 
        testCont.Phone = '1234567890';
        testCont.Email = 'test@test.com';
        insert testCont;
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','PMUSA',true);
        insert testOpCo;
        Case testCase = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id);
        insert testCase;
        TFN__c testTFN= TestDataSetup.createTFN(True,'0001',1,testOpCo);
        insert testTFN;
        Transaction_Management__c testTM= TestDataSetup.createTM(testOpCo,testTFN);
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
        ApexPages.currentPage().getParameters().put('issueid',testCase.Id);
        Test.startTest();
        ConsumerSearchController controller = new ConsumerSearchController(new ApexPages.StandardController(testCont));
        controller.Search();
        Test.stopTest();
    }
    // validate SearchNullData method
    static testMethod void validateSearchNullData() {
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
        testCont.FirstName= '1234566';
        testCont.Street_Address__c = '125';
        testCont.Country__c = 'India';
        insert testCont;
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
        insert testOpCo;
        Case testCase = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id);
        insert testCase;
        TFN__c testTFN= TestDataSetup.createTFN(True,'0001',1,testOpCo);
        insert testTFN;
        Transaction_Management__c testTM= TestDataSetup.createTM(testOpCo,testTFN);
        insert testTM;
        ApexPages.currentPage().getParameters().put('issueid',testCase.Id);
        Test.startTest();
        ConsumerSearchController controller = new ConsumerSearchController(new ApexPages.StandardController(testCont));
        controller.Search();
        Test.stopTest();
    }
        // validate search method
         static testMethod void validateSearch3() {
         Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
         Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
        insert testCont;
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
        insert testOpCo;
        Case testCase = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id);
        insert testCase;
        TFN__c testTFN= TestDataSetup.createTFN(True,'0001',1,testOpCo);
        insert testTFN;
        Transaction_Management__c testTM= TestDataSetup.createTM(testOpCo,testTFN);
        insert testTM;
        Test.startTest();
        ConsumerSearchController controller = new ConsumerSearchController(new ApexPages.StandardController(testCont));
        controller.getfullsearchList();
        controller.Search();
        Test.stopTest();
    }
    // validate AgeVerifyZipMap method
    static testMethod void validateAgeVerifyZipMap() {
       Account testAcc = TestDataSetup.createAccount('Test Account');
       insert testAcc ;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
        testCont.Country__c = 'United States';
        testCont.City__c = 'Huntsville';
        testCont.State__c = 'MI';
        insert testCont;
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
        insert testOpCo;
        Case testCase = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id);
        insert testCase;
        TFN__c testTFN= TestDataSetup.createTFN(True,'0001',1,testOpCo);
        insert testTFN;
        Transaction_Management__c testTM= TestDataSetup.createTM(testOpCo,testTFN);
        insert testTM;
        Test.startTest();
        ConsumerSearchController controller = new ConsumerSearchController(new ApexPages.StandardController(testCont));
        controller.ageVerifyZipMap();
        Test.stopTest();
    }
    // validate AgeVerifyZipMap method else condition 
    static testMethod void validateAgeVerifyZipMapElse() {
         Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
         Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
        testCont.Country__c = 'United States';
        testCont.City__c = 'Huntsville';
        testCont.State__c = 'MI';
        insert testCont;
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
        insert testOpCo;
        Case testCase = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id);
        insert testCase;
        TFN__c testTFN= TestDataSetup.createTFN(True,'0001',1,testOpCo);
        insert testTFN;
        Transaction_Management__c testTM= TestDataSetup.createTM(testOpCo,testTFN);
        insert testTM;
        Test.startTest();
        ConsumerSearchController controller = new ConsumerSearchController(new ApexPages.StandardController(testCont));
        controller.ageVerifyZipMap();
        Test.stopTest();
    }
    // validate CheckContact method
    static testMethod void validateCheckContact() {
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
        insert testCont;
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
        insert testOpCo;
        Case testCase = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id);
        insert testCase;
        TFN__c testTFN= TestDataSetup.createTFN(True,'0001',1,testOpCo);
        insert testTFN;
        Transaction_Management__c testTM= TestDataSetup.createTM(testOpCo,testTFN);
        testTM.Contact__c = testCont.Id;
        insert testTM;
        Test.startTest();
        ConsumerSearchController controller = new ConsumerSearchController(new ApexPages.StandardController(testCont));
        controller.checkContact();
        Test.stopTest();
    }
    
    // validate CCNLookup method
    static testMethod void validateCCNLookup() {
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
        insert testCont;
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
        insert testOpCo;
        Case testCase = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id);
        insert testCase;
        TFN__c testTFN= TestDataSetup.createTFN(True,'0001',1,testOpCo);
        insert testTFN;
        Transaction_Management__c testTM= TestDataSetup.createTM(testOpCo,testTFN);
        insert testTM;
        
        Test.startTest();
        ConsumerSearchController controller = new ConsumerSearchController(new ApexPages.StandardController(testCont));
        ConsumerSearchController.CCNLookup('3239771',''+testTM.id);
        Test.stopTest();
    }
    }