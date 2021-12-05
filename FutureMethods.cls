/*
Create an Apex class that uses the @future annotation to update Account records.
Create an Apex class with a future method that accepts a List of Account IDs and updates a custom field on the Account object with the number of contacts associated to the Account. Write unit tests that achieve 100% code coverage for the class. Every hands-on challenge in this module asks you to create a test class.
Create a field on the Account object:
Label: Number Of Contacts
Name: Number_Of_Contacts
Type: Number
This field will hold the total number of Contacts for the Account
Create an Apex class:
Name: AccountProcessor
Method name: countContacts
The method must accept a List of Account IDs
The method must use the @future annotation
The method counts the number of Contact records associated to each Account ID passed to the method and updates the 'Number_Of_Contacts__c' field with this value
Create an Apex test class:
Name: AccountProcessorTest
The unit tests must cover all lines of code included in the AccountProcessor class, resulting in 100% code coverage.
Before verifying this challenge, run your test class at least once using the Developer Console Run All feature
*/

//Account Processor Class
public class AccountProcessor {
    @future public static void countContacts(List<Id> accID) {
        List<Account> accL = [SELECT Id FROM Account where Id in :accID];
        List<Account> ret = new List<Account>();
        for (Account a : accL) {
            a.Number_of_Contacts__c = [SELECT COUNT() from Contact WHERE AccountId=:a.Id];
            ret.add(a);
        }
        update ret;
    }

}

//Account Processor Test Class
@isTest
public class AccountProcessorTest {
    @isTest public static void zeroCase() {
        Account a = new Account(Name='Test 1');
        insert a;
        List<Id> testing = new List<Id>();
        testing.add(a.id);
        test.StartTest();
        AccountProcessor.countContacts(testing);
        test.StopTest();
        Integer getNum = [SELECT Number_of_Contacts__c FROM Accounts WHERE Id=a.Id];
        System.assertEquals(0, getNum);
    }

}