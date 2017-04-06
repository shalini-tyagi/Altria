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
  Public class CorrespondenceControllerTest{
      static testmethod void CorrespondenceControllerTest1(){
      
      account acc=new account();
          acc.Name='priyanka';
          insert acc;
    
    contact con=new contact();
       con.FirstName='shweta';
       con.Salutation='ms';
       con.Accountid=acc.id;
       con.LastName='thakur';
       con.Apt_Lot__c='qwe';
       con.Street_Address__c='altria';
       con.City__c='meerut';    
       con.State__c='up';
       con.Zip_Code__c ='281004';             
       insert con;
       
   /*DocumentType__c dty=new DocumentType__c();
        dty.ReqFulfillment__c='Yes';
        dty.showMasterField__c=true;
        dty.Description__c='CRCNM05';
        dty.NAME='USSTC06- Call Me- Product Quality';
        dty.TenantId__c='AloricaAltria';
        dty.DocumentTypeCode__c='ALTRAMCRRCRRS';
        dty.VendorCode__c='PRC';
        dty.FLPPackage__c='Yes';
        dty.DocumentType__c='Outbound';
        insert dty;       */
    
   Correspondence__c crspdnc=new Correspondence__c();
      crspdnc.contact__c=con.id;
      crspdnc.Received_Date__c=system.today();
      crspdnc.LetterDate__c='system.today()';
      insert crspdnc;
            
           
    Case cs=new Case();
        cs.Taste__c='asd';
        cs.Purchase_Price__c=123;
        insert cs;       
          
  
     ApexPages.currentPage().getParameters().put('contid',con.id);
     ApexPages.StandardController std = new ApexPages.StandardController(crspdnc);    
     CorrespondenceController ac = new CorrespondenceController (std);     
      ac.conObj=con;
      ac.codObj=crspdnc;    
    //ac.codObj.Contact__c=con.id;
      ac.showMasterID=true;
      ac.selectedId='shweta'; 
      ac.Clear();
      //ac.getShowMasterField();        
      //ac.getRecord();      
      ac.SaveRecord();
      }
  }