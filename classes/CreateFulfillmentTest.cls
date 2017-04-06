@isTest(SeeAllData=true)
 Public class CreateFulfillmentTest{
      static testmethod void CreateFulfillmentTest1(){
      
      
      account acc=new account();
        acc.Name='priyanka';
        insert acc;
      
      contact con=new contact();
         con.FirstName='shweta';
         con.Accountid=acc.id;
         con.LastName='thakur';
         con.Apt_Lot__c='qwe';
         con.Street_Address__c='altria';
         con.City__c='meerut';    
         con.State__c='up';
         con.Zip_Code__c ='281004';             
         insert con;
      
      Correspondence__c crspdnc=new Correspondence__c();
          crspdnc.contact__c=con.id;
          insert crspdnc;    
          
      /*DocType__c dt=new DocType__c();
          dt.RequiresFulfillment__c='Yes';
          DT.NAME='ASD';
          insert dt;    */
         
      Fulfillment__c fflmt=new Fulfillment__c ();           
          fflmt.Correspondence__c=crspdnc.Id;
          fflmt.Packagecode__c='aaa';
          fflmt.Accnumber__c=con.id;
          fflmt.Add1__c='bbb';
          fflmt.Add2__c='ccc';
          fflmt.City__c='meerut';
          fflmt.FName__c='shweta';
          fflmt.LName__c='thakur';
          fflmt.Nameprefix__c='ddd';
          fflmt.State__c='up';
          fflmt.Zip__c='asdfg';
                   
          insert fflmt ;
        
      }
      
  }