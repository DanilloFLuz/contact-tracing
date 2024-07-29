
@isTest
public with sharing class CTPeopleTracingTriggerHandlerTest {

    @TestSetup
    static void makeData(){
        List<Person__c> persons = new List<Person__c>();
        persons.add(new Person__c(Name='Test 1', Mobile__c='11999999999'));
        persons.add(new Person__c(Name='Test 2', Mobile__c='11888888888'));
        persons.add(new Person__c(Name='Test 3', Mobile__c='11777777777'));
        persons.add(new Person__c(Name='Test 4', Mobile__c='11666666666'));
        persons.add(new Person__c(Name='Test 5', Mobile__c='11555555555'));

        insert persons;

        List<Person__c> person = [SELECT Id FROM Person__c];
        List<People_Tracing__c> peopleTracing = new List<People_Tracing__c>();
        peopleTracing.add(new People_Tracing__c(Person_1__c=person[0].Id, Person_2__c=person[1].Id, Contact_Date__c=Date.today().addDays(-10), Contact_Type__c='Cohabitant'));
        peopleTracing.add(new People_Tracing__c(Person_1__c=person[2].Id, Person_2__c=person[3].Id, Contact_Date__c=Date.today().addDays(-10), Contact_Type__c='Neighbour'));
        peopleTracing.add(new People_Tracing__c(Person_1__c=person[0].Id, Person_2__c=person[4].Id, Contact_Date__c=Date.today().addDays(-10), Contact_Type__c='Other'));
        peopleTracing.add(new People_Tracing__c(Person_1__c=person[2].Id, Person_2__c=person[0].Id, Contact_Date__c=Date.today().addDays(-10), Contact_Type__c='Cohabitant'));
        peopleTracing.add(new People_Tracing__c(Person_1__c=person[1].Id, Person_2__c=person[4].Id, Contact_Date__c=Date.today().addDays(-10), Contact_Type__c='Other'));
        peopleTracing.add(new People_Tracing__c(Person_1__c=person[3].Id, Person_2__c=person[1].Id, Contact_Date__c=Date.today().addDays(-10), Contact_Type__c='Neighbour'));

        insert peopleTracing;
    }

    @isTest
    public static void beforeInsertHandeTest1(){
        List<Person__c> person = [SELECT Id FROM Person__c];
        List<People_Tracing__c> peopleTracing = new List<People_Tracing__c>();
        peopleTracing.add(new People_Tracing__c(Person_1__c=person[3].Id, Person_2__c=person[1].Id, Contact_Date__c=Date.today().addDays(-10), Contact_Type__c='Neighbour'));

        Test.startTest();
        try {
            insert peopleTracing;
            System.assert(false, 'Exceção foi realizada');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('Duplicate record found. Person 1: '+person[3].Id+' Person 2: '+person[1].Id), 
                          'Duplicate record found. Person 1: '+person[3].Id+' Person 2: '+person[1].Id);
        }
        Test.stopTest();

        peopleTracing = [SELECT Id FROM People_Tracing__c];
        System.assertEquals(6, peopleTracing.size());
    }
}