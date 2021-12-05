/*
Create an Apex class that uses Batch Apex to update Lead records.
Create an Apex class that implements the Database.Batchable interface to update all Lead records in the org with a specific LeadSource.
Create an Apex class:
Name: LeadProcessor
Interface: Database.Batchable
Use a QueryLocator in the start method to collect all Lead records in the org
The execute method must update all Lead records in the org with the LeadSource value of Dreamforce
Create an Apex test class:
Name: LeadProcessorTest
In the test class, insert 200 Lead records, execute the LeadProcessor Batch class and test that all Lead records were updated correctly
The unit tests must cover all lines of code included in the LeadProcessor class, resulting in 100% code coverage
Before verifying this challenge, run your test class at least once using the Developer Console Run All feature
*/

//Lead Processor Class

global class LeadProcessor implements Database.Batchable<Sobject>  {
    public Database.QueryLocator start(DataBase.BatchableContext bc){
        return DataBase.getQueryLocator('SELECT Id FROM Lead');
    }
    public void execute(Database.BatchableContext bc, List<Lead> scope) {
        List<Lead> ins = new List<Lead>();
        for(Lead l : scope) {
            l.LeadSource='Dreamforce';
            ins.add(l);
        }
        update ins;
    }
    public void finish(Database.BatchableContext bc) {
        System.debug('Compeleted');
    }
}

//Lead Processor Test Class

@isTest
public class LeadProcessorTest {
    @testSetup
    public static void setUp() {
        List<Lead> tempLead = new List<Lead>();
   		for(Integer i= 0; i < 200; i++) {
           Lead a = new Lead(LastName ='Sure', Company='Alright', LeadSource = 'Blah' + i);
     	   tempLead.add(a);
  		}
        insert tempLead;
    }
    
    @isTest
    public static void runTest() {
        test.startTest();
        LeadProcessor lp = new LeadProcessor();
        Id batchId = Database.executeBatch(lp);
        test.stopTest();
        System.assertEquals(200, [SELECT COUNT() from Lead where LeadSource = 'Dreamforce']);
    }
   
}