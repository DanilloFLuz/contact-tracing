public with sharing class CTPeopleTracingTriggerHandler {
   
    public static void beforeInsertHande(List<People_Tracing__c> newPeopleTracing){
        List<People_Tracing__c> duplicates = CTPeopleTracingController.checkDuplicates(newPeopleTracing);
        List<People_Tracing__c> newPeople = new List<People_Tracing__c>();

        for (People_Tracing__c people : duplicates) {
            people.addError('Duplicate record found. Person 1: '+people.Person_1__c+' Person 2: '+people.Person_2__c);
        }

    }
}