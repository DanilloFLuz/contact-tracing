@isTest
public with sharing class LocationTriggerHandlerTest {

    @TestSetup
    public static void makeData(){
        List<Location__c> location = new List<Location__c>();
        location.add(new Location__c(Name='Guarulhos', Address__c='Rua Guarulhos', Pincode__c='0145687'));
        location.add(new Location__c(Name='Petroleo', Address__c='Rua Petroleo', Pincode__c='1234567'));
        location.add(new Location__c(Name='Viagem', Address__c='Rua Viagem', Pincode__c='9876543'));
        location.add(new Location__c(Name='Casa', Address__c='Rua Casa', Pincode__c='456789'));
        location.add(new Location__c(Name='Mato', Address__c='Rua Mato', Pincode__c='369852'));

        insert location;
    }

    @isTest
    public static void beforeInsertHandleTest1(){
        List<Location__c> location = [SELECT Id, Name, Status__c FROM Location__c];
        System.assertEquals(5, location.size());
        for(Location__c l : location){
            if(l.Name == 'Guarulhos'){
                System.assertEquals('Green', l.Status__c);
            }
        }
    }

    @isTest
    public static void beforeUpdateHandleTest1(){
        List<Location__c> location = [SELECT Id, Name, Status__c FROM Location__c];
        System.assertEquals(5, location.size());
        for(Location__c l : location){
            if(l.Name == 'Guarulhos'){
                l.Status__c = 'Yellow';
            }
        }
        
        Test.startTest();
        update location;
        Test.stopTest();

        location = [SELECT Id, Name, Status__c, Status_Update_Date__c FROM Location__c];
        for(Location__c l : location){
            if(l.Name == 'Guarulhos'){
                System.assertEquals(Date.today(), l.Status_Update_Date__c);
            }
        }
    }

    @isTest
    public static void afterUpdateHandleTest1(){
        List<Person__c> persons = new List<Person__c>();
        persons.add(new Person__c(Name='Test 1', Mobile__c='11999999999'));
        persons.add(new Person__c(Name='Test 2', Mobile__c='11888888888'));
        persons.add(new Person__c(Name='Test 3', Mobile__c='11777777777'));
        persons.add(new Person__c(Name='Test 4', Mobile__c='11666666666'));
        persons.add(new Person__c(Name='Test 5', Mobile__c='11555555555'));

        insert persons;

        persons = [SELECT Id FROM Person__c];
        List<Location__c> locations = [SELECT Id FROM Location__c];
        List<Location_Tracing__c> locationTracing = new List<Location_Tracing__c>();
        locationTracing.add(new Location_Tracing__c(Person__c=persons[0].Id, Location__c=locations[0].Id,Visit_Date__c=Date.today().addDays(-10)));
        locationTracing.add(new Location_Tracing__c(Person__c=persons[1].Id, Location__c=locations[1].Id,Visit_Date__c=Date.today().addDays(-10)));
        locationTracing.add(new Location_Tracing__c(Person__c=persons[2].Id, Location__c=locations[2].Id,Visit_Date__c=Date.today().addDays(-10)));
        locationTracing.add(new Location_Tracing__c(Person__c=persons[3].Id, Location__c=locations[3].Id,Visit_Date__c=Date.today().addDays(-10)));
        locationTracing.add(new Location_Tracing__c(Person__c=persons[4].Id, Location__c=locations[4].Id,Visit_Date__c=Date.today().addDays(-10)));

        insert locationTracing;

        List<Location__c> location = [SELECT Id, Name, Status__c FROM Location__c];
        System.assertEquals(5, location.size());
        for(Location__c l : location){
            if(l.Name == 'Guarulhos'){
                l.Status__c = 'Red';
            }
        }
        
        Test.startTest();
        update location;
        Test.stopTest();

        location = [SELECT Id, Name, Status__c, Status_Update_Date__c FROM Location__c];
        for(Location__c l : location){
            if(l.Name == 'Guarulhos'){
                System.assertEquals(Date.today(), l.Status_Update_Date__c);
            }
        }
    }
}