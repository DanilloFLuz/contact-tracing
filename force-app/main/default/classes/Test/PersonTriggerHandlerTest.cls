@isTest
public with sharing class PersonTriggerHandlerTest {

    @TestSetup
    public static void makeData(){
        List<Person__c> persons = new List<Person__c>();
        persons.add(new Person__c(Name='Test 1', Mobile__c='11999999999'));
        persons.add(new Person__c(Name='Test 2', Mobile__c='11888888888'));
        persons.add(new Person__c(Name='Test 3', Mobile__c='11777777777'));
        persons.add(new Person__c(Name='Test 4', Mobile__c='11666666666'));
        persons.add(new Person__c(Name='Test 5', Mobile__c='11555555555'));

        insert persons;
    }

    @isTest
    public static void beforeInsertHandlerTest1(){
        List<Person__c> persons = [SELECT Name, Mobile__c, Health_Status__c FROM Person__c];
        System.assertEquals(5, persons.size());
        for (Person__c p : persons) {
            if(p.Name == 'Test 3'){
                System.assertEquals('11777777777', p.Mobile__c);
                System.assertEquals('Green', p.Health_Status__c);
            }
            if(p.Name == 'Test 5'){
                System.assertEquals('11555555555', p.Mobile__c);
            }
        }
    }

    @isTest
    public static void beforeInsertHandlerBulk(){
        List<Person__c> personInsert = new List<Person__c>();
        for (Integer i = 0; i < 1000; i++) {
            personInsert.add(new Person__c(Name='Test Bulk' + i, Mobile__c='11999999999'));
        }
        insert personInsert;

        List<Person__c> persons = [SELECT Name, Mobile__c, Health_Status__c FROM Person__c];
        System.assertEquals(1005, persons.size());
        for (Person__c p : persons) {
            if(p.Name == 'Test 3'){
                System.assertEquals('11777777777', p.Mobile__c);
                System.assertEquals('Green', p.Health_Status__c);
            }
            if(p.Name == 'Test 5'){
                System.assertEquals('11555555555', p.Mobile__c);
            }
            if(p.Name == 'Test Bulk 8'){
                System.assertEquals('11999999999', p.Mobile__c);
            }
        }
    }

    @isTest
    public static void beforeUpdateHandlerTest1(){
        List<Person__c> persons = [SELECT Name, Mobile__c, Health_Status__c, Status_Update_Date__c FROM Person__c];
        for (Person__c p : persons) {
            if(p.Name == 'Test 1'){
                p.Health_Status__c = 'Yellow';
            }
            if(p.Name == 'Test 2'){
                p.Health_Status__c = 'Yellow';
            }
        }

        Test.startTest();
        update persons;
        Test.stopTest();

        System.assertEquals(5, persons.size());
        List<Person__c> personUpdate = [SELECT Name, Mobile__c, Health_Status__c, Status_Update_Date__c FROM Person__c];
        for (Person__c p : personUpdate) {
            if(p.Name == 'Test 1'){
                System.assertEquals('Yellow', p.Health_Status__c);
                System.assertEquals(Date.today(), p.Status_Update_Date__c);
            }
            if (p.Name == 'Test 3') {
                System.assertEquals('Green', p.Health_Status__c);
            }
        }
    }

    @isTest
    public static void afterUpdateHandlerTest1(){
        List<Person__c> person = [SELECT Id FROM Person__c];
        List<People_Tracing__c> peopleTracing = new List<People_Tracing__c>();
        peopleTracing.add(new People_Tracing__c(Person_1__c=person[0].Id, Person_2__c=person[1].Id, Contact_Date__c=Date.today().addDays(-10), Contact_Type__c='Cohabitant'));
        peopleTracing.add(new People_Tracing__c(Person_1__c=person[2].Id, Person_2__c=person[3].Id, Contact_Date__c=Date.today().addDays(-10), Contact_Type__c='Neighbour'));
        peopleTracing.add(new People_Tracing__c(Person_1__c=person[0].Id, Person_2__c=person[4].Id, Contact_Date__c=Date.today().addDays(-10), Contact_Type__c='Other'));
        peopleTracing.add(new People_Tracing__c(Person_1__c=person[2].Id, Person_2__c=person[0].Id, Contact_Date__c=Date.today().addDays(-10), Contact_Type__c='Cohabitant'));
        peopleTracing.add(new People_Tracing__c(Person_1__c=person[1].Id, Person_2__c=person[4].Id, Contact_Date__c=Date.today().addDays(-10), Contact_Type__c='Other'));
        peopleTracing.add(new People_Tracing__c(Person_1__c=person[3].Id, Person_2__c=person[1].Id, Contact_Date__c=Date.today().addDays(-10), Contact_Type__c='Neighbour'));

        insert peopleTracing;

        List<Location__c> location = new List<Location__c>();
        location.add(new Location__c(Name='Guarulhos', Address__c='Rua Guarulhos', Pincode__c='0145687'));
        location.add(new Location__c(Name='Petroleo', Address__c='Rua Petroleo', Pincode__c='1234567'));
        location.add(new Location__c(Name='Viagem', Address__c='Rua Viagem', Pincode__c='9876543'));
        location.add(new Location__c(Name='Casa', Address__c='Rua Casa', Pincode__c='456789'));
        location.add(new Location__c(Name='Mato', Address__c='Rua Mato', Pincode__c='369852'));

        insert location;

        List<Location__c> locations = [SELECT Id FROM Location__c];
        List<Location_Tracing__c> locationTracing = new List<Location_Tracing__c>();
        locationTracing.add(new Location_Tracing__c(Person__c=person[0].Id, Location__c=location[0].Id,Visit_Date__c=Date.today().addDays(-10)));
        locationTracing.add(new Location_Tracing__c(Person__c=person[1].Id, Location__c=location[1].Id,Visit_Date__c=Date.today().addDays(-10)));
        locationTracing.add(new Location_Tracing__c(Person__c=person[2].Id, Location__c=location[2].Id,Visit_Date__c=Date.today().addDays(-10)));
        locationTracing.add(new Location_Tracing__c(Person__c=person[3].Id, Location__c=location[3].Id,Visit_Date__c=Date.today().addDays(-10)));
        locationTracing.add(new Location_Tracing__c(Person__c=person[4].Id, Location__c=location[4].Id,Visit_Date__c=Date.today().addDays(-10)));

        insert locationTracing;

        List<Person__c> persons = [SELECT Name, Mobile__c, Health_Status__c FROM Person__c];
        for (Person__c p : persons) {
            if(p.Name == 'Test 1'){
                p.Health_Status__c = 'Red';
            }
            if(p.Name == 'Test 3'){
                p.Health_Status__c = 'Red';
            }
        }

        Test.startTest();
        update persons;
        Test.stopTest();

        for (Person__c p : persons) {
            if(p.Name == 'Test 1'){
                System.assertEquals('Red', p.Health_Status__c);
            }
            if (p.Name == 'Test 2') {
                System.assertEquals('Green', p.Health_Status__c);
            }
        }
    }
}