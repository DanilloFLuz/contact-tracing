@isTest
public with sharing class LocationTracingTriggerHandlerTest {

    @TestSetup
    static void makeData(){
        List<Person__c> persons = new List<Person__c>();
        persons.add(new Person__c(Name='Test 1', Mobile__c='11999999999'));
        persons.add(new Person__c(Name='Test 2', Mobile__c='11888888888'));
        persons.add(new Person__c(Name='Test 3', Mobile__c='11777777777'));
        persons.add(new Person__c(Name='Test 4', Mobile__c='11666666666'));
        persons.add(new Person__c(Name='Test 5', Mobile__c='11555555555'));

        insert persons;

        List<Location__c> locations = new List<Location__c>();
        locations.add(new Location__c(Name='Guarulhos', Address__c='Rua Guarulhos', Pincode__c='0145687'));
        locations.add(new Location__c(Name='Petroleo', Address__c='Rua Petroleo', Pincode__c='1234567'));
        locations.add(new Location__c(Name='Viagem', Address__c='Rua Viagem', Pincode__c='9876543'));
        locations.add(new Location__c(Name='Casa', Address__c='Rua Casa', Pincode__c='456789'));
        locations.add(new Location__c(Name='Mato', Address__c='Rua Mato', Pincode__c='369852'));

        insert locations;
        
        persons = [SELECT Id FROM Person__c];
        locations = [SELECT Id FROM Location__c];
        List<Location_Tracing__c> locationTracing = new List<Location_Tracing__c>();
        locationTracing.add(new Location_Tracing__c(Person__c=persons[0].Id, Location__c=locations[0].Id,Visit_Date__c=Date.today().addDays(-10)));
        locationTracing.add(new Location_Tracing__c(Person__c=persons[1].Id, Location__c=locations[1].Id,Visit_Date__c=Date.today().addDays(-10)));

        insert locationTracing;
    }

    @isTest
    public static void beforeInsertHandlerTest1(){
        List<Person__c> persons = [SELECT Id FROM Person__c];
        List<Location__c> locations = [SELECT Id FROM Location__c];
        List<Location_Tracing__c> locationTracing = new List<Location_Tracing__c>();
        locationTracing.add(new Location_Tracing__c(Person__c=persons[1].Id, Location__c=locations[1].Id,Visit_Date__c=Date.today().addDays(-10)));

        Test.startTest();
        try {
            insert locationTracing;
            System.assert(false, 'Exceção foi realizada');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('Duplicate record found. Person ID: '+persons[1].Id+' Location ID: '+locations[1].Id), 
                          'Duplicate record found. Person ID: '+persons[1].Id+' Location ID: '+locations[1].Id);
        }
        Test.stopTest();

        locationTracing = [SELECT Id FROM Location_Tracing__c];
        System.assertEquals(2, locationTracing.size());
    }
}