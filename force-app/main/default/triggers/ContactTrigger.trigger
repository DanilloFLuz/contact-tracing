trigger ContactTrigger on Contact (after insert, after update, after delete, after undelete) {
	switch on Trigger.operationType{
        when AFTER_INSERT {
            Set<Id> accountIds = new Set<Id>();
            for(Contact con : Trigger.new){
                if(String.isNotBlank(con.AccountId)){
                    // write automation logic here
                    accountIds.add(con.AccountId);
                }
            }

            List<AggregateResult> results = [SELECT AccountId, COUNT(Id) totalContacts FROM Contact WHERE Active__c = TRUE AND AccountId IN : accountIds GROUP BY AccountId];
            List<Account> accountsToUpdate = new List<Account>();
            for(AggregateResult result : results){
                // get account id and number of active contacts
                String accId = String.valueOf(result.get('AccountId'));
                Integer totalContacts = Integer.valueOf(result.get('totalContacts'));
                Account acc = new Account(Id=accId, Active_Contacts__c=totalContacts);
                accountsToUpdate.add(acc);
            }
            update accountsToUpdate;
        }
        
        when AFTER_UPDATE {
            Set<Id> accountIds = new Set<Id>();
            for(Contact con : Trigger.new){
                if(String.isNotBlank(con.AccountId) && Trigger.oldMap.get(con.Id).Active__c != con.Active__c){
                    // write automation logic here
                    accountIds.add(con.AccountId);
                } else if(Trigger.oldMap.get(con.Id).AccountId != con.AccountId){
                    accountIds.add(con.AccountId);
                    accountIds.add(Trigger.oldMap.get(con.Id).AccountId);
                }
            }

            List<AggregateResult> results = [SELECT AccountId, COUNT(Id) totalContacts FROM Contact WHERE Active__c = TRUE AND AccountId IN : accountIds GROUP BY AccountId];
            List<Account> accountsToUpdate = new List<Account>();
            for(AggregateResult result : results){
                // get account id and number of active contacts
                String accId = String.valueOf(result.get('AccountId'));
                Integer totalContacts = Integer.valueOf(result.get('totalContacts'));
                Account acc = new Account(Id=accId, Active_Contacts__c=totalContacts);
                accountsToUpdate.add(acc);
            }
            update accountsToUpdate;
        }
        
        /*when AFTER_DELETE {
            Map<Id, Integer> accountMap = new Map<Id, Integer>();
            for(Contact contact : Trigger.new) {
                if(String.isBlank(contact.AccountId)) {
                    if(! accountMap.containsKey(contact.AccountId)){
                        accountMap.put(contact.AccountId, 0);
                    }
                    Integer totalContacts = accountMap.get(contact.AccountId);
                    totalContacts--;
                    accountMap.put(contact.AccountId, totalContacts);
                }
            }

            List<Account> accountUpdate = new List<Account>();
            // Atualização da account diminuindo a quantidade
            for(Account account : [SELECT Id,Active_Contacts__c FROM Account WHERE Id IN :accountMap.keySet()]){
               Decimal total = account.Active_Contacts__c + accountMap.get(account.Id);
               accountUpdate.add(new Account(Id=account.Id,Active_Contacts__c=total));
            }
            update accountUpdate;
        }

        when AFTER_UNDELETE {

        }*/
    }
}