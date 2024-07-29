public with sharing class CTLocationTracingTriggerHandler {

    public static void beforeInsertHandler(List<Location_Tracing__c> newLocationTracing){
        List<Location_Tracing__c> duplicates = CTLocationTracingController.checkDuplicates(newLocationTracing);
        for (Location_Tracing__c trace : duplicates) {
            trace.addError('Duplicate record found. Person ID: '+trace.Person__c+' Location ID: '+trace.Location__c);
        }
    }
}