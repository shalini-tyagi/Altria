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
 Test Class for CaseHelper Controller
  09/02/2016 Infogain – Created.
 */

  @isTest
   public class CaseHelperTest{
    public  static date date1;
    // vaidate calculateOverage method
    public static testmethod void TestcalculateOverage(){  
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
        insert testCont;
        list<Case> lstCase = new list<Case>();
        Case caseobj1=TestDataSetup.createTestCase(testAcc, 112.3,testCont.Id);
        lstCase.add(caseobj1);
        caseobj1.Incident_Date__c=date1;   
        Case caseobj2=TestDataSetup.createTestCase(testAcc,105.3,testCont.Id);
        lstCase.add(caseobj2);
        insert lstCase;
        Product_Line__c testPL = TestDataSetup.createPL('Test Product Line');
        insert testPL;
        Brand__c testBrand = TestDataSetup.createBrand('Test Brand');
        insert testBrand;
        Brand_Hierarchy__c testBH=TestDataSetup.createBH('Full Flavor', '100s', 'Soft Pack', 'Menthol', 'Filtered', 'Banded Paper Ny', 'Ready','12345', testBrand, testPL);
        insert testBH;
        Test.startTest();
        CaseHelper controller = new CaseHelper();
        controller.calculateOverage(lstCase);
        Test.stopTest();
        system.assertEquals(caseobj1.Purchase_Price__c, 112.3 );
    }
}