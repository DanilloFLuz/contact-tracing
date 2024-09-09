public with sharing class CTUpdateLocationStatusBatch implements Database.Batchable<SObject> {
    
    public Database.QueryLocator start(Database.BatchableContext bc) {
        List<String> healthStatuses = new List<String>{'Red', 'Orange', 'Yellow'};
        Date today = Date.today();
        Date fourteenDaysAgo = today - 14;
        return Database.getQueryLocator('SELECT Id, Status__c FROM Location__c WHERE Status__c IN :healthStatuses AND Status_Update_Date__c  = :fourteenDaysAgo');
    }

    public void execute(Database.BatchableContext bc, List<Location__c> scope){
        for (Location__c lc : scope) {
            lc.Status__c = 'Green';
        }
        update scope;
    }

    public void finish(Database.BatchableContext bc){
        //System.debug('Batch is complete');
    }
}