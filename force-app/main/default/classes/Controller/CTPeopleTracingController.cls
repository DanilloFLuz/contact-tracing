public with sharing class CTPeopleTracingController {
    
    public static List<People_Tracing__c> getTraces(String recordId){
        return [SELECT Id, Contact_Date__c, Contact_Type__c, Person_1__c, Person_1__r.Health_Status__c ,Person_2__c, Person_2__r.Health_Status__c 
                    FROM People_Tracing__c 
                    WHERE Person_1__c = :recordId OR Person_2__c = :recordId
                    ORDER BY Contact_Date__c DESC NULLS LAST];
    }

    public static List<People_Tracing__c> checkDuplicates(List<People_Tracing__c> peopleTraces){
        Set<Id> personIds = new Set<Id>();

        for(People_Tracing__c trace : peopleTraces){
            personIds.add(trace.Person_1__c);
            personIds.add(trace.Person_2__c);
        }

        Map<Id, Set<Id>> mapOfExistingRecords = new  Map<Id, Set<Id>>();
        List<People_Tracing__c> duplicates = new List<People_Tracing__c>();

        List<People_Tracing__c> existingRecords = [SELECT Id, Person_1__c, Person_2__c 
                                                        FROM People_Tracing__c 
                                                        WHERE Person_1__c IN :personIds 
                                                        OR Person_2__c IN :personIds];

        if(existingRecords != null && existingRecords.size() > 0){
            for (People_Tracing__c trace : existingRecords) {
                if(! mapOfExistingRecords.containsKey(trace.Person_1__c)){
                    mapOfExistingRecords.put(trace.Person_1__c, new Set<Id>());
                }
                mapOfExistingRecords.get(trace.Person_1__c).add(trace.Person_2__c);


                if(! mapOfExistingRecords.containsKey(trace.Person_2__c)){
                    mapOfExistingRecords.put(trace.Person_2__c, new Set<Id>());
                }
                mapOfExistingRecords.get(trace.Person_2__c).add(trace.Person_1__c);
            }

            for (People_Tracing__c trace : peopleTraces) {
                if((mapOfExistingRecords.containsKey(trace.Person_1__c) 
                    && mapOfExistingRecords.get(trace.Person_1__c).contains(trace.Person_2__c)) 
                    || (mapOfExistingRecords.containsKey(trace.Person_2__c))
                    && mapOfExistingRecords.get(trace.Person_2__c).contains(trace.Person_1__c)){
                        duplicates.add(trace);
                    }
            }
        }

        return duplicates;

    }
    public static Set<Id> getCohabitants(Set<Id> personIds, Set<Id> alredyProcessed){
        List<String> healthStatuses = new List<String>{'Green', 'Yellow'};
        List<People_Tracing__c> peopleTraces = [SELECT Id, Person_1__c, Person_2__c 
                                                    FROM People_Tracing__c 
                                                    WHERE (Person_1__c IN :personIds OR Person_2__c IN :personIds) 
                                                    AND Contact_Type__c = 'Cohabitant'
                                                    AND (Person_1__r.Health_Status__c IN :healthStatuses OR Person_2__r.Health_Status__c IN :healthStatuses)];
        Set<Id> cohabitants = new Set<Id>();
        for (People_Tracing__c pt : peopleTraces) {
            if(!alredyProcessed.contains(pt.Person_1__c)){
                cohabitants.add(pt.Person_1__c);
                alredyProcessed.add(pt.Person_1__c);
            }
            if(!alredyProcessed.contains(pt.Person_2__c)){
                cohabitants.add(pt.Person_2__c);
                alredyProcessed.add(pt.Person_2__c);
            }
        }

        return cohabitants;
    }

    public static Set<Id> getNeighbours(Set<Id> personIds, Set<Id> alredyProcessed){
        List<People_Tracing__c> peopleTraces = [SELECT Id, Person_1__c, Person_2__c 
                                                    FROM People_Tracing__c 
                                                    WHERE (Person_1__c IN :personIds OR Person_2__c IN :personIds) 
                                                    AND Contact_Type__c = 'Neighbour'
                                                    AND (Person_1__r.Health_Status__c = 'Green' OR Person_2__r.Health_Status__c = 'Green')];
        Set<Id> neighbour = new Set<Id>();
        for (People_Tracing__c pt : peopleTraces) {
            if(!alredyProcessed.contains(pt.Person_1__c)){
                neighbour.add(pt.Person_1__c);
                alredyProcessed.add(pt.Person_1__c);
            }
            if(!alredyProcessed.contains(pt.Person_2__c)){
                neighbour.add(pt.Person_2__c);
                alredyProcessed.add(pt.Person_2__c);
            }
        }

        return neighbour;
    }

    public static Set<Id> getPrimaryContacts(Set<Id> personIds, Set<Id> alredyProcessed){
        List<String> healthStatuses = new List<String>{'Green', 'Yellow'};
        List<People_Tracing__c> peopleTraces = [SELECT Id, Person_1__c, Person_2__c 
                                                    FROM People_Tracing__c 
                                                    WHERE (Person_1__c IN :personIds OR Person_2__c IN :personIds) 
                                                    AND Contact_Type__c = 'Other'
                                                    AND Contact_Date__c = LAST_N_DAYS:10
                                                    AND (Person_1__r.Health_Status__c IN :healthStatuses OR Person_2__r.Health_Status__c IN :healthStatuses)];
        Set<Id> primaryContacts = new Set<Id>();
        for (People_Tracing__c pt : peopleTraces) {
            if(!alredyProcessed.contains(pt.Person_1__c)){
                primaryContacts.add(pt.Person_1__c);
                alredyProcessed.add(pt.Person_1__c);
            }
            if(!alredyProcessed.contains(pt.Person_2__c)){
                primaryContacts.add(pt.Person_2__c);
                alredyProcessed.add(pt.Person_2__c);
            }
        }

        return primaryContacts;
    }

    public static Set<Id> getSecondaryContacts(Set<Id> primaryContactIds, Set<Id> alredyProcessed){
        List<People_Tracing__c> peopleTraces = [SELECT Id, Person_1__c, Person_2__c 
                                                    FROM People_Tracing__c 
                                                    WHERE (Person_1__c IN :primaryContactIds OR Person_2__c IN :primaryContactIds) 
                                                    AND Contact_Type__c = 'Other'
                                                    AND Contact_Date__c = LAST_N_DAYS:10
                                                    AND (Person_1__r.Health_Status__c = 'Green' OR Person_2__r.Health_Status__c = 'Green')];
        Set<Id> secundaryContacts = new Set<Id>();
        for (People_Tracing__c pt : peopleTraces) {
            if(!alredyProcessed.contains(pt.Person_1__c)){
                secundaryContacts.add(pt.Person_1__c);
                alredyProcessed.add(pt.Person_1__c);
            }
            if(!alredyProcessed.contains(pt.Person_2__c)){
                secundaryContacts.add(pt.Person_2__c);
                alredyProcessed.add(pt.Person_2__c);
            }
        }

        return secundaryContacts;
    }

}