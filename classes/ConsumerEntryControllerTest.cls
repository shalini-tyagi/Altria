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
test class of Consumer Entry
08/03/2016 Infogain – Created.
*/


  @isTest()
  private class ConsumerEntryControllerTest{
  //  Validate Constructor
   static testMethod void validateConsumerEntryController()
    {
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
        testCont.Email = 'test123@test.com';
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
         ApexPages.currentPage().getParameters().put('tranid', testTM.Id);
         ApexPages.currentPage().getParameters().put('Fname',testCont.Id);
         ApexPages.currentPage().getParameters().put('email',testCont.Email);
         Test.startTest();
         ConsumerEntryController controller = new ConsumerEntryController(new ApexPages.StandardController(testCont));
         controller.init();
         Test.stopTest();
         System.assertEquals('Fname', controller.conObj.FirstName );
     }
     // validate Getcitystate method
     static testMethod void validateGetcitystate() 
     {
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'35801',bdate,'Test Street', true, true);
        testCont.Country__c = 'United States';
        testCont.City__c = 'Huntsville';
        insert testCont;
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
        insert testOpCo;
        TFN__c testTFN = TestDataSetup.createTFN(true, '1800', 45, testOpCo);
        insert testTFN;
        Transaction_Management__c testTM= TestDataSetup.createTM(testOpCo, testTFN);
        insert testTM;
        ApexPages.currentPage().getParameters().put('tranid', testTM.Id);
        Test.startTest();
        ConsumerEntryController controller = new ConsumerEntryController(new ApexPages.StandardController(testCont));
        controller.getcitystate();
        Test.stopTest();
        //System.assertEquals(testTM.Id, controller.testTM.id );
      }
       // validate Getcitystate method
      static testMethod void validateGetcitystate1()
       {
         Account testAcc = TestDataSetup.createAccount('Test Account');
         insert testAcc ;
         Date bdate = Date.newInstance(1989, 06, 14);
         Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
         insert testCont;
         Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
         insert testOpCo;
         ApexPages.currentPage().getParameters().put('Fname',testCont.Id);
         Test.startTest();
         ConsumerEntryController controller = new ConsumerEntryController(new ApexPages.StandardController(testCont));
         controller.getcitystate();
         Test.stopTest();
          System.assertEquals('Fname', controller.conObj.FirstName );
         
       }
        // validate Getcitystate method
     static testMethod void validateGetcitystate2() 
      {
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
        insert testCont;
         Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
        insert testOpCo;
        ApexPages.currentPage().getParameters().put('Lname',testCont.Id);
        Test.startTest();
            ConsumerEntryController controller = new ConsumerEntryController(new ApexPages.StandardController(testCont));
            controller.getcitystate();
        Test.stopTest();
         System.assertEquals('Lname', controller.conObj.LastName );
     }
      // validate Getcitystate method
      static testMethod void validateGetcitystate3() 
      {
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
        insert testCont;
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
        insert testOpCo;
        ApexPages.currentPage().getParameters().put('Title',testCont.Id);
        Test.startTest();
        ConsumerEntryController controller = new ConsumerEntryController(new ApexPages.StandardController(testCont));
        controller.getcitystate();
        Test.stopTest();
        System.assertEquals('Title', controller.conObj.Title );
        
      }
       // validate Getcitystate method
       static testMethod void validateGetcitystate4() 
       {
         Account testAcc = TestDataSetup.createAccount('Test Account');
         insert testAcc ;
         Date bdate = Date.newInstance(1989, 06, 14);
         Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
         insert testCont;
         Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
         insert testOpCo;
         ApexPages.currentPage().getParameters().put('Addr1',testCont.Id);
         Test.startTest();
         ConsumerEntryController controller = new ConsumerEntryController(new ApexPages.StandardController(testCont));
         controller.getcitystate();
         Test.stopTest();
          //System.assertEquals('Addr1', controller.conObj.OtherAddress);
        
         
        }
         // validate Getcitystate method
        static testMethod void validateGetcitystate5() 
        {
         Account testAcc = TestDataSetup.createAccount('Test Account');
         insert testAcc ;
         Date bdate = Date.newInstance(1989, 06, 14);
         Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
         insert testCont;
         Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
         insert testOpCo;
         ApexPages.currentPage().getParameters().put('add',testCont.Id);
         Test.startTest();
         ConsumerEntryController controller = new ConsumerEntryController(new ApexPages.StandardController(testCont));
         controller.getcitystate();
         Test.stopTest();
         //System.assertEquals('add', controller.conObj.Address );
        }
         // validate Getcitystate method
        static testMethod void validateGetcitystate6() 
        {
         Account testAcc = TestDataSetup.createAccount('Test Account');
         insert testAcc ;
         Date bdate = Date.newInstance(1989, 06, 14);
         Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
         insert testCont;
         Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
         insert testOpCo;
         ApexPages.currentPage().getParameters().put('City',testCont.Id);
         Test.startTest();
         ConsumerEntryController controller = new ConsumerEntryController(new ApexPages.StandardController(testCont));
         controller.getcitystate();
         Test.stopTest();
         System.assertEquals('City', controller.conObj.City__c );

        }
         // validate Getcitystate method
        static testMethod void validateGetcitystate7()
         {
         Account testAcc = TestDataSetup.createAccount('Test Account');
         insert testAcc ;
         Date bdate = Date.newInstance(1989, 06, 14);
         Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
         insert testCont;
         Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
         insert testOpCo;
         ApexPages.currentPage().getParameters().put('State',testCont.Id);
         Test.startTest();
         ConsumerEntryController controller = new ConsumerEntryController(new ApexPages.StandardController(testCont));
         controller.getcitystate();
         Test.stopTest();
         System.assertEquals('State', controller.conObj.State__c );

         }
          // validate Getcitystate method
        static testMethod void validateGetcitystate8() 
        {
         Account testAcc = TestDataSetup.createAccount('Test Account');
         insert testAcc ;
         Date bdate = Date.newInstance(1989, 06, 14);
         Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
         insert testCont;
         Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
         insert testOpCo;
         ApexPages.currentPage().getParameters().put('dob',testCont.Birthdate__c);
         Test.startTest();
         ConsumerEntryController controller = new ConsumerEntryController(new ApexPages.StandardController(testCont));
         controller.getcitystate();
         Test.stopTest();
          System.assertEquals('dob', controller.conObj.Birthdate__c );
         }
          // validate Getcitystate method
        static testMethod void validateGetcitystate9() 
        {
          Account testAcc = TestDataSetup.createAccount('Test Account');
          insert testAcc ;
          Date bdate = Date.newInstance(1989, 06, 14);
          Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
          insert testCont;
          Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
         insert testOpCo;
         ApexPages.currentPage().getParameters().put('phone',testCont.Id);
         Test.startTest();
         ConsumerEntryController controller = new ConsumerEntryController(new ApexPages.StandardController(testCont));
         controller.getcitystate();
        Test.stopTest();
         System.assertEquals('phone', controller.conObj.Phone );
         }
          // validate Getcitystate method
        static testMethod void validateGetcitystate10() 
        {
         Account testAcc = TestDataSetup.createAccount('Test Account');
         insert testAcc ;
         Date bdate = Date.newInstance(1989, 06, 14);
         Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
         insert testCont;
         Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
         insert testOpCo;
         ApexPages.currentPage().getParameters().put('CCN',testCont.Id);
         Test.startTest();
         ConsumerEntryController controller = new ConsumerEntryController(new ApexPages.StandardController(testCont));
         controller.getcitystate();
         Test.stopTest();
          System.assertEquals('CCN', controller.conObj.CCN__c);
         }
          // validate Getcitystate method
        static testMethod void validateGetcitystate11()
         {
         Account testAcc = TestDataSetup.createAccount('Test Account');
         insert testAcc ;
         Date bdate = Date.newInstance(1989, 06, 14);
         Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
         insert testCont;
         Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
         insert testOpCo;
         ApexPages.currentPage().getParameters().put('strAVCode',testCont.Id);
         Test.startTest();
         ConsumerEntryController controller = new ConsumerEntryController(new ApexPages.StandardController(testCont));
         controller.getcitystate();
         Test.stopTest();
         System.assertEquals('strAVCode', controller.conObj.AV_Code__c);
         }
          // validate Getcitystate method
       static testMethod void validateGetcitystate12()
        {
         Account testAcc = TestDataSetup.createAccount('Test Account');
         insert testAcc ;
         Date bdate = Date.newInstance(1989, 06, 14);
         Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
         insert testCont;
         Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
         insert testOpCo;
         ApexPages.currentPage().getParameters().put('email',testCont.Id);
         Test.startTest();
         ConsumerEntryController controller = new ConsumerEntryController(new ApexPages.StandardController(testCont));
         controller.getcitystate();
         Test.stopTest();
          System.assertEquals('email', controller.conObj.Email);
        }
         // validate Getcitystate method
       static testMethod void validateGetcitystate13() 
       {
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
        insert testCont;
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
        insert testOpCo;
        ApexPages.currentPage().getParameters().put('country',testCont.Id);
        Test.startTest();
        ConsumerEntryController controller = new ConsumerEntryController(new ApexPages.StandardController(testCont));
        controller.getcitystate();
        Test.stopTest();
        System.assertEquals('country', controller.conObj.Country__c);
        }
         // validate Getcitystate method
      static testMethod void validateGetcitystate14()
       {
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
        insert testCont;
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
        insert testOpCo;
        ApexPages.currentPage().getParameters().put('Zip',testCont.Id);
        Test.startTest();
        ConsumerEntryController controller = new ConsumerEntryController(new ApexPages.StandardController(testCont));
        controller.getcitystate();
        Test.stopTest();
        System.assertEquals('Zip', controller.conObj.Zip_Code__c);
        }
       // validate GetaddressverifiedUS method
       static testMethod void validateGetaddressverifiedUS()
        {
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
        testCont.Country__c = 'United States';
        testCont.City__c = 'Grand Rapids';
        testCont.State__c = 'Michigan';
        insert testCont;
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','PMUSA',true);
        insert testOpCo;
        Test.startTest();
        ConsumerEntryController controller = new ConsumerEntryController(new ApexPages.StandardController(testCont));
        controller.getaddressverified();
        Test.stopTest();
        //System.assertEquals('PMUSA', controller.testOpCo.OperatingCompany__c);
        }
       // validate Getaddressverified method 
       static testMethod void validateGetaddressverified() 
        {
         Account testAcc = TestDataSetup.createAccount('Test Account');
         insert testAcc ;
         Date bdate = Date.newInstance(1989, 06, 14);
         Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
         insert testCont;
         Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
         insert testOpCo;
         Test.startTest();
         ConsumerEntryController controller = new ConsumerEntryController(new ApexPages.StandardController(testCont));
         controller.getaddressverified();
         Test.stopTest();
          //System.assertEquals('PMUSA', controller.testOpCo.OperatingCompany__c);
        }
        // validate Getglobaladdverify method
       static testMethod void validateGetglobaladdverify() 
       {
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
        insert testCont;
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
        insert testOpCo;
        Test.startTest();
        ConsumerEntryController controller = new ConsumerEntryController(new ApexPages.StandardController(testCont));
        //controller.getglobaladdverify();
        Test.stopTest();
        }
        // validate SaveNoContact method
       static testMethod void validateSaveNoContact() 
        {
         Account testAcc = TestDataSetup.createAccount('Test Account');
         insert testAcc ;
         Date bdate = Date.newInstance(1989, 06, 14);
         Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
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
        ApexPages.currentPage().getParameters().put('tranid',testTM.Id);
        Test.startTest();
        ConsumerEntryController controller = new ConsumerEntryController(new ApexPages.StandardController(testCont));
        controller.save();
        Test.stopTest();
       }
      // validate Save method
      static testMethod void validateSave()
       {
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20011',bdate,'Test Street', true, true);
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
            ConsumerEntryController controller = new ConsumerEntryController(new ApexPages.StandardController(testCont));
            controller.save();
        Test.stopTest();
       }
     // validate SaveNoAddrVerify method
     static testMethod void validateSaveNoAddrVerify()
      {
       Account testAcc = TestDataSetup.createAccount('Test Account');
       insert testAcc ;
       Date bdate = Date.newInstance(1989, 06, 14);
       Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
        //insert testCont;
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
        insert testOpCo;
        TFN__c testTFN = TestDataSetup.createTFN(true, '1800', 45, testOpCo);
        insert testTFN;
        Transaction_Management__c testTM= TestDataSetup.createTM(testOpCo, testTFN);
        insert testTM;
        ApexPages.currentPage().getParameters().put('tranid',testTM.Id);
        Test.startTest();
        ConsumerEntryController controller = new ConsumerEntryController(new ApexPages.StandardController(testCont));
        controller.save();
        Test.stopTest();
       }
  }