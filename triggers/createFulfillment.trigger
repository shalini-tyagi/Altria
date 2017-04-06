trigger createFulfillment on Correspondence__c (after insert) {
    
    if(trigger.isInsert){
        
        Fulfillment__c ffObj =new Fulfillment__c();
        
        for(Correspondence__c  corObj:Trigger.new){ 
            if(corObj!=NULL && corObj.Requires_Fulfillment__c=='Yes'){                
                List<DocumentType__c> docObj = new List<DocumentType__c>([Select id, PrintLetterHead__c,PkgCode__c, 
                                                                         FileExtension__c,  FileName__c 
                                                                         from DocumentType__c  
                                                                         where id =: corObj.DocType__c 
                                                                         and IsActive__c = true
                                                                         and ReqFulfillment__c = 'Yes']);
                                                                         
                Contact conObj=[select id,FirstName,LastName,Street_Address__c,Apt_Lot__c,City__c,Salutation,Suffix__c,State__c,Zip_Code__c 
                                from contact 
                                where id=:corObj.Contact__c];
                
                if(!docObj.isEmpty() && docObj.size() >0){
                    ffObj.Correspondence__c=corObj.Id;
                   
                    ffObj.Accnumber__c=corObj.Contact__c;
                    ffObj.Add1__c=conObj.Street_Address__c;
                    ffObj.Add2__c=conObj.Apt_Lot__c;
                    ffObj.City__c=conObj.City__c;
                    ffObj.FName__c=conObj.FirstName;
                    ffObj.LName__c=conObj.LastName;
                    ffObj.Nameprefix__c=conObj.Salutation;
                    ffObj.Name_Suffix__c= conObj.Suffix__c;
                    ffObj.State__c=conObj.State__c;
                    ffObj.Zip__c=conObj.Zip_Code__c;
                    
                    ffObj.Packagecode__c=docObj[0].PkgCode__c; 
                    ffObj.Letter_head__c=docObj[0].PrintLetterHead__c;
                    ffObj.FileName__c=docObj[0].FileName__c;
                    
                    ffObj.BCode__c = corObj.Brand_Code__c;
                    ffObj.Master_ID__c = corObj.MasterId__c;
                    insert ffObj;                    
                }
            }
            else{
                
            }
        } 
    } 
}