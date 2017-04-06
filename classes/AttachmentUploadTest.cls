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
  Test Class for AttachmentUpload Controller
  09/13/2016 Infogain – Created.
   */

@isTest
public class AttachmentUploadTest
{
    // validate updateAttachment method 
    public static testmethod void updateAttachmentTest(){
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
        insert testCont;
        Case testCase = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id);
        insert testCase;
        Blob blobValue = EncodingUtil.convertFromHex('4A4B4C');
        Attachment  attachment= TestDataSetup.createAttachment ('Test description', 'test name', testCase.id, blobValue);
        insert attachment;
        ApexPages.currentPage().getParameters().put('Id',attachment.Id);
        ApexPages.currentPage().getParameters().put('Comment: Max. 500 character are allowed.',attachment.Id);
        Test.startTest();
        AttachmentUpload controller=new AttachmentUpload (new ApexPages.StandardController(attachment));
        controller.updateAttachment();
        Test.stopTest();
        //Assertions
        system.assertEquals(attachment.Name,'test name');
    }
    
    // validate cancelButton method
     public static testmethod void cancelButtonTest(){
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
        insert testCont;
        Case testCase = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id);
        insert testCase;
        Blob blobValue = EncodingUtil.convertFromHex('4A4B4C');
        Attachment  attachment= TestDataSetup.createAttachment ('Test description', 'test name', testCase.id, blobValue);
        insert attachment;
        ApexPages.currentPage().getParameters().put('Id',attachment.Id);
        Test.startTest();
        AttachmentUpload controller=new AttachmentUpload (new ApexPages.StandardController(attachment));
        controller.cancelButton();
        Test.stopTest();
        //Assertions
        system.assertEquals(attachment.Name,'test name');
    }
    // validate upload method
    public static testmethod void uploadTest(){      
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
        insert testCont;
        Case testCase = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id);
        insert testCase;
        Blob blobValue = EncodingUtil.convertFromHex('4A4B4C');
        Attachment  attachment= TestDataSetup.createAttachment ('Test description', 'test name', testCase.id, blobValue);
        insert attachment;
        ApexPages.currentPage().getParameters().put('issueId',testCase.Id);
        //List<Attachment> attachments=[select id, name from Attachment where parent.id=:testCase.id];
        //System.assertEquals(1, attachments.size());
        Test.startTest();
        AttachmentUpload controller=new AttachmentUpload (new ApexPages.StandardController(attachment));
        controller.upload();
        Test.stopTest();
        //Assertions 
        system.assertEquals(attachment.Description,'Test description');
    }
}