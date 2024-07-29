/**
 * CTPersonController
 * Main Controller class for Person__c object
 * @author Danillo
 */
public with sharing class CTPersonController {
    
    /**
     * Generate unique token using mobile number
     * use MD5 algorith to generate one-way hash
     * @param mobile
     * @return string token
     */
    public static String getToken(String mobileNo){
        Blob mobileHash = Crypto.generateDigest('MD5', Blob.valueOf(mobileNo));
        // get the string value of hash blob
        return EncodingUtil.base64Encode(mobileHash);
    }

    /**
     * Get 100 contacts with recent heath status change
     * @return List<Person__c>
     */
    public static List<Person__c> getRecentHealthChanges(){
        return [SELECT Id, Name, Status_Update_Date__c, Token__c, Mobile__c, Health_Status__c FROM Person__c ORDER BY Status_Update_Date__c DESC NULLS LAST LIMIT 100];
    }

    /**
     * Search a person by name, token or mobile
     * @return List<Person__c>
     */
    public static List<Person__c> searchPeople(String searchTerm){
        searchTerm = searchTerm+'%';
        return [SELECT Id, Name, Status_Update_Date__c, Token__c, Mobile__c, Health_Status__c FROM Person__c WHERE Name LIKE :searchTerm or Mobile__c LIKE :searchTerm or Token__c LIKE :searchTerm ORDER BY Status_Update_Date__c DESC NULLS LAST];
    }
    
    /**
     * Search a person by id
     * @return Person__c
     */
    public static Person__c getPersonById(String personId){
        List<Person__c> people = [SELECT Id, Name, Status_Update_Date__c, Token__c, Mobile__c, Health_Status__c FROM Person__c WHERE Id =: personId ];
        if(people != null && people.size() > 0){
            return people[0];
        }
        return null;
    }

    /**
     * Get count of people in each health status
     * @return Map<String, Integer>
     */
    public static Map<String, Integer> getHealthStatusCount(){
        Map<String, Integer> healthStatusCount = new Map<String, Integer>();
        for(AggregateResult ar : [SELECT Health_Status__c, COUNT(Id) countStatus
                                    FROM Person__c 
                                    GROUP BY Health_Status__c]){
            String healthStatus = String.valueOf(ar.get('Health_Status__c'));
            Integer count = Integer.valueOf(ar.get('countStatus'));
            healthStatusCount.put(healthStatus, count);
        }
        return healthStatusCount;
    }

    public static void updateYellowScore(Set<Id> personIds){
        List<Person__c> peopleToUpdate = new List<Person__c>();
        for(Id pid : personIds){
            peopleToUpdate.add(new Person__c(Id=pid,Health_Status__c='Yellow'));
        }
        if(peopleToUpdate.size() > 0){
            update peopleToUpdate;
        }
    }
}