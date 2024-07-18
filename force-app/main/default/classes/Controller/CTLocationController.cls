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

}