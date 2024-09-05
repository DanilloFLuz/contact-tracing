public with sharing class CTLocationTabController {
    @AuraEnabled
    public static LocationInformation getLocationDetails(String recordId){
        LocationInformation info = new LocationInformation();
        Location__c locationDetail = CTLocationController.getLocationById(recordId);
        if (locationDetail != null) {
            info.name = locationDetail.Name;
            info.pincode = locationDetail.Pincode__c;
            info.redScore = locationDetail.Red_Score__c;
            info.statusUpdateOn = locationDetail.Status_Update_Date__c;
            info.status = locationDetail.Status__c;
        }
        List<Location_Tracing__c> peopleVisitors = CTLocationTracingController.getVisitors(recordId);
        System.debug(peopleVisitors);
        if(peopleVisitors != null && peopleVisitors.size() > 0){
            List<locationVisitors> visitors = new List<locationVisitors>();

            for(Location_Tracing__c trace : peopleVisitors){
                locationVisitors v = new locationVisitors();
                v.id = trace.Person__c;
                v.status = trace.Person__r.Health_Status__c;
                v.visitDate = trace.Visit_Date__c;
                v.token = trace.Person__r.Token__c;
                visitors.add(v);
            }
            info.personVisitors = visitors;   
            info.contactsCount = visitors.size();         
        }
        return info;
    }

    public class LocationInformation {
        @AuraEnabled
        public String name;
        @AuraEnabled
        public String pincode;
        @AuraEnabled
        public Double redScore;
        @AuraEnabled
        public Date statusUpdateOn;
        @AuraEnabled
        public String status;
        @AuraEnabled 
        public Integer contactsCount = 0;
        @AuraEnabled
        public List<locationVisitors> personVisitors;
            
    }

    public class locationVisitors {
        @AuraEnabled
        public String id;
        @AuraEnabled
        public String status;
        @AuraEnabled
        public String token;
        @AuraEnabled
        public Date visitDate;
    }
}