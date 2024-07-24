/**
 * CTLocationController
 * Main Controller class for Location__c object
 * @author Danillo
 */
public with sharing class CTLocationController {

    /**
     * Get 100 contacts with recent heath status change
     * @return List<Location__c>
     */
    public static List<Location__c> getRecentStatusChanges(){
        return [SELECT Id, Name, Address__c, Red_Score__c, Pincode__c, Status__c, Status_Update_Date__c FROM Location__c ORDER BY Status_Update_Date__c DESC NULLS LAST LIMIT 100];
    }

    /**
     * Search a location by name, Pincode or Adress
     * @return List<Location__c>
     */
    public static List<Location__c> searchLocations(String searchTerm){
        searchTerm = searchTerm+'%';
        return [SELECT Id, Name, Address__c, Red_Score__c, Pincode__c, Status__c, Status_Update_Date__c FROM Location__c WHERE Name LIKE :searchTerm OR Pincode__c LIKE :searchTerm OR Address__c LIKE :searchTerm ORDER BY Status_Update_Date__c DESC NULLS LAST];
    }

    /**
     * Search a location by id
     * @return Location__c
     */
    public static Location__c getLocationById(String locationId){
        List<Location__c> location = [SELECT Id, Name, Address__c, Red_Score__c, Pincode__c, Status__c, Status_Update_Date__c FROM Location__c WHERE Id = :locationId];
        if(location != null && location.size() > 0){
            return location[0];
        }
        return null;
    }

    /**
     * Get count of locations in each health status
     * @return Map<String, Integer>
     */
    public static Map<String, Integer> getStatusCount(){
        Map<String, Integer> healthLocationCount = new Map<String, Integer>();
        for(AggregateResult ar : [SELECT Status__c, COUNT(Id) countStatusLocation FROM Location__c GROUP BY Status__c]){
            healthLocationCount.put(String.valueOf(ar.get('Status__c')), Integer.valueOf(ar.get('countStatusLocation')));
        }
        return healthLocationCount;
    }

    public static void updateRedScore(Set<Id> locationIds){
        List<Location__c> locationToUpdate = new List<Location__c>();
        AggregateResult[] redPeoplePerLocation =  [SELECT Location__c, COUNT(Id) total FROM Location_Tracing__c
                                                        WHERE Person__r.Health_Status__c = 'Red'
                                                        AND Visit_Date__c = LAST_N_DAYS:10
                                                        AND Location__c IN :locationIds
                                                        GROUP BY Location__c];
        for (AggregateResult ar : redPeoplePerLocation) {
            String locationID = String.valueOf(ar.get('Location__c'));
            Integer redScore = Integer.valueOf(ar.get('total'));
            String status = getStatus(redScore);
            locationToUpdate.add(new Location__c(Id=locationID,Red_Score__c=redScore,Status__c=status));
        }
        if(locationToUpdate.size() > 0 && locationToUpdate != null){
            update locationToUpdate;
        }
    }

    public static String getStatus(Integer redScore){
        if(redScore == 0){
            return 'Green';
        }else if(redScore <= 5){
            return 'Yellow';
        }else if (redScore <= 10) {
            return 'Orange';
        }else{
            return 'Red';
        }
    }
}