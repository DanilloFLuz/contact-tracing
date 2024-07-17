/**
 * CTLocationTracingController
 * Main Controller class for Location_Tracing__c object
 * @author Danillo
 */
public with sharing class CTLocationTracingController {

    /**
     * Get all visitor id for locations
     * @param locationId
     * @return List<Location_Tracing__c>
     */
    public static List<Location_Tracing__c> getVisitors(String locationId){
        return [SELECT Id, Person__c, Location__c, Visit_Date__c, Person__r.Token__c, Person__r.Health_Status__c 
                    FROM Location_Tracing__c 
                    WHERE Id = :locationId 
                    ORDER BY Visit_Date__c DESC NULLS LAST];
    }

    /**
     * Get all locations ids for visitor
     * @param personIds
     * @return List<Location_Tracing__c>
     */
    public static List<Location_Tracing__c> getLocationsByPersonIds(Set<Id> personIds){
        return [SELECT Id, Person__c, Location__c
                    FROM Location_Tracing__c 
                    WHERE Person__c IN :personIds 
                    AND Visit_Date__c = LAST_N_DAYS:10];
    }

    /**
     * Get all visitor ids for locations
     * @param locationIds
     * @return List<Location_Tracing__c>
     */
    public static List<Location_Tracing__c> getLocationsByLocationsIds(Set<Id> locationIds) {
        return [SELECT Id, Name, Person__c, Location__c, Visit_Date__c 
                    FROM Location_Tracing__c 
                    WHERE Location__c IN :locationIds 
                    AND Person__r.Health_Status__c = 'Green'
                    AND Visit_Date__c = LAST_N_DAYS:10];
    }

    public static List<Location_Tracing__c> checkDuplicates(List<Location_Tracing__c> locationTraces){
        Set<Id> locationsIds = new Set<Id>();
        Set<Id> personIds = new Set<Id>();

        for(Location_Tracing__c trace : locationTraces){
            locationsIds.add(trace.Location__c);
            personIds.add(trace.Person__c);
        }
        
        Map<Id, Set<Id>> mapOfExistingRecords = new Map<Id, Set<Id>>();

        List<Location_Tracing__c> existingRecords = [SELECT Id, Person__c, Location__c 
                                                                    FROM Location_Tracing__c 
                                                                    WHERE Location__c IN :locationsIds 
                                                                    AND Person__c IN :personIds];

        List<Location_Tracing__c> duplicates = new List<Location_Tracing__c>();
        
        if(existingRecords != null && existingRecords.size() > 0){
            for (Location_Tracing__c trace : existingRecords) {
                if(! mapOfExistingRecords.containsKey(trace.Location__c)){
                    mapOfExistingRecords.put(trace.Location__c, new Set<Id>());
                }
                // add person ids to map set
                mapOfExistingRecords.get(trace.Location__c).add(trace.Person__c);

            }

            // loop over new location tracing records
            for (Location_Tracing__c trace : locationTraces) {
                // First check for location id
                // if item found in map, then check for person in set
                if(mapOfExistingRecords.containsKey(trace.Location__c) 
                    && mapOfExistingRecords.get(trace.Location__c).contains(trace.Person__c)){
                    duplicates.add(trace);
                }
            }
        }
        
        return duplicates;
    }
}