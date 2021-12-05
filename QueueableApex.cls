/*
Create an Queueable Apex class that inserts Contacts for Accounts.
Create a Queueable Apex class that inserts the same Contact for each Account for a specific state.
Create an Apex class:
Name: AddPrimaryContact
Interface: Queueable
Create a constructor for the class that accepts as its first argument a Contact sObject and a second argument as a string for the State abbreviation
The execute method must query for a maximum of 200 Accounts with the BillingName specified by the State abbreviation passed into the constructor and insert the Contact sObject record associated to each Account. Look at the sObject clone() method.
Create an Apex test class:
Name: AddPrimaryContactTest
In the test class, insert 50 Account records for BillingName NY and 50 Account records for BillingName CA
Create an instance of the AddPrimaryContact class, enqueue the job, and assert that a Contact record was inserted for each of the 50 Accounts with the BillingName of CA
The unit tests must cover all lines of code included in the AddPrimaryContact class, resulting in 100% code coverage
Before verifying this challenge, run your test class at least once using the Developer Console Run All feature
*/

//Queueable Class

public class AddPrimaryContact implements Queueable {
    Contact con;
    String state;
    public AddPrimaryContact(Contact con, String state) {
        this.con = con;
        this.state = state;
    }
    public void execute(QueueableContext Context) {
        List<Account> acc = [SELECT Id from Account WHERE BillingState=:state LIMIT 200];
        List<Contact> contact = new List<Contact>();
        for(Account a : acc) {
            Contact copy = con.clone(false, false, false, false);
            copy.AccountId = a.id;
            contact.add(copy);
        }
        insert contact;
     
    }

}

//Queueable Test Class

@isTest
public class AddPrimaryContactTest {
    @testSetup
    public static void setUp(){
        List<Account> ins = new List<Account>();
        for (Integer i = 0; i < 100; i++) {
            if(i < 50) {
                Account a = new Account(Name = 'Random', BillingState = 'NY');
                ins.add(a);
            }
            else {
                Account a = new Account(Name = 'Random', BillingState = 'CA');
                ins.add(a);
            }
        }
        insert ins;
    }
    
    @isTest
    public static void runTest(){
        Contact cont = new Contact(LastName = 'Test');
        AddPrimaryContact addPC = new AddPrimaryContact(cont,'CA');
        test.startTest();
        System.enqueueJob(addPC);
        test.stopTest();
        System.assertEquals(50, [SELECT COUNT() FROM Contact WHERE Account.BillingState ='CA']);
    }

}