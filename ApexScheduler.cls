/*
Create an Apex class that uses Scheduled Apex to update Lead records.
Create an Apex class that implements the Schedulable interface to update Lead records with a specific LeadSource. (This is very similar to what you did for Batch Apex.)
Create an Apex class:
Name: DailyLeadProcessor
Interface: Schedulable
The execute method must find the first 200 Lead records with a blank LeadSource field and update them with the LeadSource value of Dreamforce
Create an Apex test class:
Name: DailyLeadProcessorTest
In the test class, insert 200 Lead records, schedule the DailyLeadProcessor class to run and test that all Lead records were updated correctly
The unit tests must cover all lines of code included in the DailyLeadProcessor class, resulting in 100% code coverage.
Before verifying this challenge, run your test class at least once using the Developer Console Run All feature
*/

//Daily Lead Processor Class

public class DailyLeadProcessor implements Schedulable {
    public void execute(SchedulableContext context) {
        List<Lead> first200 = [SELECT Id, LeadSource FROM Lead WHERE LeadSource='' LIMIT 200];
        for (Integer i = 0; i < first200.size(); i++) {
            first200[i].LeadSource = 'Dreamforce';
        }
        update first200;
 
    }

}

//Daily Lead Processor Test Class
@isTest
public class DailyLeadProcessorTest {
	@testSetup
    public static void testSetup() {
        List<Lead> a = new List<Lead>();
        for (Integer i = 0; i < 200; i++) {
            Lead l = new Lead(Company='Blah', LastName='Test', status='Test');
            a.add(l);
		}
        insert a;
    }
    
    @isTest
    public static void testDLP() {
        String CRON_EXP = '0 0 0 15 3 ? 2022';
        test.startTest();
        String jobID = System.schedule('Check Lead Test', CRON_EXP, new DailyLeadProcessor());
        test.stopTest();
        System.assertEquals(200, [SELECT COUNT() FROM LEAD WHERE LeadSource = 'Dreamforce']);
    }
}