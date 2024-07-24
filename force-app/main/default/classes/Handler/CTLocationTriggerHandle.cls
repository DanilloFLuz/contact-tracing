public with sharing class CTLocationTriggerHandle {
    
    public static void beforeInsertHandle(List<Location__c> newLocation){
        for(Location__c location : newLocation){
                location.Status__c = 'Green';
        }
    }

    public static void beforeUpdateHandle(List<Location__c> newLocation, Map<Id, Location__c> oldMap){
        for(Location__c location : newLocation){
            if(oldMap.get(location.Id).Status__c != location.Status__c){
                location.Status_Update_Date__c = Date.today();
            }
        }
    }
}