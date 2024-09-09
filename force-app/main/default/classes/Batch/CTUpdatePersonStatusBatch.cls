public with sharing class CTUpdatePersonStatusBatch implements Database.Batchable<SObject>{

    public Database.QueryLocator start (Database.BatchableContext bc) {
        List<String> healthStatuses = new List<String>{'Red', 'Orange', 'Yellow'};
        Date today = Date.today();
        Date fourteenDaysAgo = today - 14;
        return Database.getQueryLocator('SELECT Id, Health_Status__c FROM Person__c WHERE Health_Status__c IN :healthStatuses AND Status_Update_Date__c = :fourteenDaysAgo');
    }

    public void execute(Database.BatchableContext bc, List<Person__c> scope) {
        for(Person__c p : scope){
            p.Health_Status__c = 'Green';
        }
        update scope;
    }

    public void finish(Database.BatchableContext bc) {
        //System.debug('Batch is complete');
    }
}