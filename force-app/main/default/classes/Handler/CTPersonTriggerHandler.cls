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
            if(oldMap.get(p.Id).Mobile__c != p.Mobile__c && p.Mobile__c != null){
                p.Token__c = CTPersonController.getToken(p.Mobile__c);
            }
        }
    }

    public static void afterUpdateHandler(List<Person__c> newPerson, Map<Id, Person__c> oldMap){
        Set<Id> statusChange = new Set<Id>();
        Set<Id> redStatus = new Set<Id>();
        for(Person__c person : newPerson){
            if(oldMap.get(person.Id).Health_Status__c != person.Health_Status__c){
                statusChange.add(person.Id);
            }
            if(oldMap.get(person.Id).Health_Status__c != 'Red' && person.Health_Status__c == 'Red') {
                redStatus.add(person.Id);
            }
        }

        Set<Id> alreadyProcessed = new Set<Id>();
        alreadyProcessed.addAll(redStatus);

        Set<Id> orangeStatus = new Set<Id>();
        Set<Id> yellowStatus = new Set<Id>();

        // lets add cohabitants
        orangeStatus.addAll(CTPeopleTracingController.getCohabitants(redStatus, alreadyProcessed));
        // lets add primaryContacts
        Set<Id> primaryContacts = CTPeopleTracingController.getPrimaryContacts(redStatus, alreadyProcessed);
        orangeStatus.addAll(primaryContacts);
        // lets add neighbours
        yellowStatus.addAll(CTPeopleTracingController.getNeighbours(redStatus, alreadyProcessed));
        // lets add secondaryContacts
        yellowStatus.addAll(CTPeopleTracingController.getSecondaryContacts(primaryContacts, alreadyProcessed));

        List<Person__c> personToUpdate = new List<Person__c>();
        for (Id pid : orangeStatus) {
            personToUpdate.add(new Person__c(Id=pid, Health_Status__c='Orange'));
        }

        for (Id pid : yellowStatus) {
            personToUpdate.add(new Person__c(Id=pid, Health_Status__c='Yellow'));
        }

        if(personToUpdate.size() > 0){
            update personToUpdate;
        }

        List<Location_Tracing__c> locationTraces = CTLocationTracingController.getLocationsByPersonIds(statusChange);
        if(locationTraces.size() > 0 && locationTraces != null){
            Set<Id> locationsIds = new Set<Id>();
            for(Location_Tracing__c location : locationTraces){
                locationsIds.add(location.Location__c);
            }
            CTLocationController.updateRedScore(locationsIds);
        }
        
    }
}