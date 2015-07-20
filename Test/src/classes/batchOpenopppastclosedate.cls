global class batchOpenopppastclosedate implements Database.Batchable<sObject> {
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        
         String query = 'Select RecordType.Name,Amount,days_past_close_date__c,Description,OwnerId,Owner.Email,RecordTypeId,Name,Id,StageName,IsClosed,CloseDate From Opportunity where CloseDate <=Today and '
       +'StageName IN (\'Prospecting\',\'Qualification\') and RecordType.Name IN (\'FSINT Opportunity\',\'FSINT Telecash Opportunity\')'; 
        return Database.getQueryLocator(query);
    }
   
    global void execute(Database.BatchableContext BC, List<opportunity> scope) {
    
    
     String rEmail = 'girish.nallamothu@firstdata.com';      
    List<Opportunity> oppListdayspastcloseddate14 = new List<Opportunity>();
    List<Opportunity> oppListdayspastcloseddatelessthan15 = new List<Opportunity>();
    List<Opportunity> oppListdayspastcloseddate60 = new List<Opportunity>();
    List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
    EmailTemplate emailTemplate=[ select Id from EmailTemplate where DeveloperName='TIlldays14'];
     
         for(opportunity a : scope)
         {
         
          if(a.days_past_close_date__c<15)
            {
                //initiallize messaging method
                Messaging.SingleEmailMessage Tillfourteendaysemail = new Messaging.SingleEmailMessage();
            //Get To address 
                String[] toAddresses = new String[] {a.Owner.Email};
            //set to Address
                Tillfourteendaysemail.setToAddresses(toAddresses);
            //Set Reply email
                Tillfourteendaysemail.setInReplyTo(rEmail);
            //set object Id
               Tillfourteendaysemail.setTargetObjectId(a.OwnerId);
                system.debug('targetobjectid:' +a.OwnerId);
              Tillfourteendaysemail.setWhatId(a.id);
               system.debug('whatid:' +a.id);
            //set template Id
                Tillfourteendaysemail.setTemplateId(emailTemplate.Id);
                system.debug('template:' +emailTemplate.id);

            //flag to false to stop inserting activity history
                Tillfourteendaysemail.setSaveAsActivity(false); 
            //add to the list emails
                emails.add(Tillfourteendaysemail);



       
                system.debug('hi' + a.name);
                a.Description='Days Past Close Date les than 15 Email Sent' ;
                oppListdayspastcloseddatelessthan15 .add(a);
                //sendemail
            }
            
          if(a.days_past_close_date__c==14)
            {
                  system.debug('hi1' + a.name);
                a.StageName='On Hold';
            }
         
         
                      
         }
         
           //send mail 
         Messaging.sendEmail(emails);
         
         if(!oppListdayspastcloseddate14 .isEmpty()){
             update oppListdayspastcloseddate14 ;
         }
          if(!oppListdayspastcloseddatelessthan15 .isEmpty()){
             update oppListdayspastcloseddatelessthan15 ;
         }
         
          if(!oppListdayspastcloseddate60 .isEmpty()){
             update oppListdayspastcloseddate60 ;
         }
    }   
    
    global void finish(Database.BatchableContext BC) {
    }
}