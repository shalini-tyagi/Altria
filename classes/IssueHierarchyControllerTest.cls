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
Test Class for Issue Hierarchy Controller
07/19/2016 Infogain – Created.
*/

@isTest
    private class IssueHierarchyControllerTest {
    
        //Validate Reset method
        static testMethod void validateReset() {
            Classification__c testClsfy = TestDataSetup.createClassify('Test Classification');
            insert testClsfy;
            Product_Line__c testPL = TestDataSetup.createPL('');
            insert testPL;
            Issue_Type__c testIT = TestDataSetup.createIT('');
            insert testIT;
            Group__c testGroup = TestDataSetup.createGroup('Test Group');
            insert testGroup;
            Cause__c testCause = TestDataSetup.createCause('');
            insert testCause;
            Reason__c testReason = TestDataSetup.createReason('');
            insert testReason;
            Issue_Hierarchy__c testIH = TestDataSetup.createIH(testClsfy, testPL, testIT, testGroup, testCause, testReason,false);
            insert testIH;
            //ApexPages.currentPage().getParameters().put('issueHierId',testIH.Id); 
            Test.startTest();
                IssueHierarchyController obj=  new IssueHierarchyController(new ApexPages.StandardController(testIH));
                //System.AssertEquals(null,obj.reset());
            Test.stopTest();
       
            System.AssertEquals(null,obj.reset());
        }
        //Validate data reset for OnChangeProductLine method
        static testMethod void validateOnChangePL() {
            Classification__c testClsfy = TestDataSetup.createClassify('Test Classification');
            insert testClsfy;
            Product_Line__c testPL = TestDataSetup.createPL('');
            insert testPL;
            Issue_Type__c testIT = TestDataSetup.createIT('');
            insert testIT;
            Group__c testGroup = TestDataSetup.createGroup('Test Group');
            insert testGroup;
            Cause__c testCause = TestDataSetup.createCause('');
            insert testCause;
            Reason__c testReason = TestDataSetup.createReason('');
            insert testReason;
            Issue_Hierarchy__c testIH = TestDataSetup.createIH(testClsfy, testPL, testIT, testGroup, testCause, testReason,false);
            insert testIH;
            //ApexPages.currentPage().getParameters().put('issueHierId',testIH.Id); 
            Test.startTest();
            IssueHierarchyController obj=  new IssueHierarchyController(new ApexPages.StandardController(testIH));
            Test.stopTest();
            System.AssertEquals(null,obj.onChangeproductLine());
           
           //System.AssertEquals(null,obj.deleteStore());
        }
    
        //  Validate IssueHierarchyDataOnLoad method
          static testMethod void validateIssueHierarchyDataOnLoad() {
            Classification__c testClsfy = TestDataSetup.createClassify('Test Classification');
            insert testClsfy;
            Product_Line__c testPL = TestDataSetup.createPL('Test Product Line');
            insert testPL;
            Issue_Type__c testIT = TestDataSetup.createIT('Test Issue Type');
            insert testIT;
            Group__c testGroup = TestDataSetup.createGroup('Test Group');
            insert testGroup;
            Cause__c testCause = TestDataSetup.createCause('Test Cause');
            insert testCause;
            Reason__c testReason = TestDataSetup.createReason('Test Reason');
            insert testReason;
            Issue_Hierarchy__c testIH = TestDataSetup.createIH(testClsfy, testPL, testIT, testGroup, testCause, testReason, true);
            insert testIH;
            ApexPages.currentPage().getParameters().put('issueHierId',testIH.Id);
            ApexPages.currentPage().getParameters().put('firstParam',testReason.Id);
            ApexPages.currentPage().getParameters().put('secondParam',testCause.Id);
            ApexPages.currentPage().getParameters().put('productParam',testPL.Id); 
            
            Test.startTest();
               IssueHierarchyController obj=  new IssueHierarchyController(new ApexPages.StandardController(testIH));
               obj.IssueHierarchyDataOnLoad();
            Test.stopTest();
               
               //Assertions
               System.AssertEquals('Test Issue Type',obj.selectedIssueType);
               System.AssertEquals('Test Reason',obj.reasonStr);
               System.AssertEquals('Test Cause',obj.causeStr);
           
        }
    
        // Validate GetReasonStatic method
        static testMethod void validateGetReasonStatic() {
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
            ApexPages.currentPage().getParameters().put('issueHierId',testIH.Id);
            ApexPages.currentPage().getParameters().put('firstParam',testReason.Id);
            ApexPages.currentPage().getParameters().put('secondParam',testCause.Id);
            ApexPages.currentPage().getParameters().put('productParam',testPL.Id); 
            //String tempReason = IssueHierarchyController.getReasonStatic(testPL.Name, testIT.Description__c, testCause.Description__c);
            Test.startTest();
              IssueHierarchyController obj=  new IssueHierarchyController(new ApexPages.StandardController(testIH));
              //IssueHierarchyController.getReasonStatic(testPL.Name, testIT.Description__c, testCause.Description__c);
            Test.stopTest();
             
             System.AssertEquals('Test Reason',obj.reasonStr);
            
        }
    
        // Validate GetCauseStatic method
        static testMethod void validateGetCauseStatic() {
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
            ApexPages.currentPage().getParameters().put('issueHierId',testIH.Id);
            ApexPages.currentPage().getParameters().put('firstParam',testReason.Id);
            ApexPages.currentPage().getParameters().put('secondParam',testCause.Id);
            ApexPages.currentPage().getParameters().put('productParam',testPL.Id); 
            
            Test.startTest();
               //IssueHierarchyController.getCauseStatic('Test Product Line', 'Test Issue Type', 'Test Reason');
            Test.stopTest();
           
        }
    
        //Validate GetIssueHierarchyData method
        static testMethod void validateGetIssueHierarchyData() {
            Classification__c testClsfy = TestDataSetup.createClassify('Test Classification');
            insert testClsfy;
            Product_Line__c testPL = TestDataSetup.createPL('Test Product Line');
            insert testPL;
            Issue_Type__c testIT = TestDataSetup.createIT('Test Issue Type');
            insert testIT;
            Group__c testGroup = TestDataSetup.createGroup('Test Group');
            insert testGroup;
            Cause__c testCause = TestDataSetup.createCause('Test Cause');
            insert testCause;
            Reason__c testReason = TestDataSetup.createReason('Test Reason');
            insert testReason;
            Issue_Hierarchy__c testIH = TestDataSetup.createIH(testClsfy, testPL, testIT, testGroup, testCause, testReason, true);
            insert testIH;
            ApexPages.currentPage().getParameters().put('issueHierId',testIH.Id);
            ApexPages.currentPage().getParameters().put('firstParam',testCause.Id);
            ApexPages.currentPage().getParameters().put('secondParam',testReason.Id);
            
            Test.startTest();
                IssueHierarchyController obj=  new IssueHierarchyController(new ApexPages.StandardController(testIH));
                obj.getIssueHierarchyData();
            Test.stopTest();
           
        }
    
        //Validate GetIssueHierarchyData method 
        static testMethod void validateGetIssueHierarchyData1() {
            Classification__c testClsfy = TestDataSetup.createClassify('Test Classification');
            insert testClsfy;
            Product_Line__c testPL = TestDataSetup.createPL('Test Product Line');
            insert testPL;
            Issue_Type__c testIT = TestDataSetup.createIT('Test Issue Type');
            insert testIT;
            Group__c testGroup = TestDataSetup.createGroup('Test Group');
            insert testGroup;
            Cause__c testCause = TestDataSetup.createCause('Test Cause');
            insert testCause;
            Reason__c testReason = TestDataSetup.createReason('Test Reason');
            insert testReason;
            Issue_Hierarchy__c testIH = TestDataSetup.createIH(testClsfy, testPL, testIT, testGroup, testCause, testReason, true);
            insert testIH;
            ApexPages.currentPage().getParameters().put('issueHierId',testIH.Id);
            ApexPages.currentPage().getParameters().put('firstParam',testCause.Id);
            ApexPages.currentPage().getParameters().put('secondParam',testReason.Id);
             
            Test.startTest();
                IssueHierarchyController.causeWrapper wrapObj=  new IssueHierarchyController.causeWrapper(True,testIH);
                IssueHierarchyController obj=  new IssueHierarchyController(new ApexPages.StandardController(testIH));
                obj.getIssueHierarchyData();
            Test.stopTest();
           
        }
    
    
    }