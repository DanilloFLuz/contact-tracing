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

    public static void afterUpdateHandle(List<Location__c> newLocation, Map<Id, Location__c> oldMap){
        Set<Id> redStatus = new Set<Id>();

        for(Location__c location : newLocation){
            if(location.Status__c != oldMap.get(location.Id).Status__c && location.Status__c == 'Red'){
                redStatus.add(location.Id);
            }
        }

        List<Location_Tracing__c> locationTracing = CTLocationTracingController.getLocationsByLocationsIds(redStatus);
        if(locationTracing.size() > 0 && locationTracing != null){
            Set<Id> personId = new Set<Id>();
            for(Location_Tracing__c location : locationTracing){
                personId.add(location.Person__c);
            }
            CTPersonController.updateYellowScore(personId);
        }
    }
}