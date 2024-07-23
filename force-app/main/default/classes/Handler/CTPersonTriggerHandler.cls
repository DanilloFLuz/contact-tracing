public with sharing class CTPersonTriggerHandler {
    public static void beforeInsertHandler(List<Person__c> newPerson){
        for(Person__c p : newPerson){
            if(String.isBlank(p.Health_Status__c)){
                p.Health_Status__c = 'Green';
                p.Token__c = CTPersonController.getToken(p.Mobile__c);
            }
        }
    }

    public static void beforeUpdateHandler(List<Person__c> newPerson, Map<Id, Person__c> oldMap){
        for(Person__c p : newPerson){
            if(String.isNotBlank(p.Id) && oldMap.get(p.Id).Health_Status__c != p.Health_Status__c){
                p.Status_Update_Date__c=Date.today();
            }
        }
    }
}