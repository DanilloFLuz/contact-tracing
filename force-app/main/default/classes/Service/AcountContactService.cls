public with sharing class AcountContactService {

    public static void updateActiveContacts(Set<Id> accountIds){
        Map<Id, Account> accountsToUpdate = new Map<Id, Account>();
        for(AggregateResult result : [SELECT AccountId, COUNT(Id) totalContacts 
                                        FROM Contact 
                                        WHERE Active__c = TRUE 
                                        AND AccountId IN : accountIds 
                                        GROUP BY AccountId]){
            // get account id and number of active contacts
            String accId = String.valueOf(result.get('AccountId'));
            Integer totalContacts = Integer.valueOf(result.get('totalContacts'));
            Account acc = new Account(Id=accId, Active_Contacts__c=totalContacts);
            accountsToUpdate.put(accId, acc);
        }

        for(Id accId : accountIds){
            if(!accountsToUpdate.containsKey(accId)){
                accountsToUpdate.put(accId, new Account(Id=accId, Active_Contacts__c=0));
            }
        }
        update accountsToUpdate.values();
    }
}