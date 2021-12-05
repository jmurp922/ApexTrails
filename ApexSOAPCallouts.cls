/*
Generate an Apex class using WSDL2Apex and write a test class.
Generate an Apex class using WSDL2Apex for a SOAP web service, write unit tests that achieve 100% code coverage for the class using a mock response, and run your Apex tests.
Generate a class using this using this WSDL file:
Name: ParkService (Tip: After you click the Parse WSDL button, change the Apex class name from parksServices to ParkService)
Class must be in public scope
Create a class:
Name: ParkLocator
Class must have a country method that uses the ParkService class
Method must return an array of available park names for a particular country passed to the web service (such as Germany, India, Japan, and United States)
Create a test class:
Name: ParkLocatorTest
Test class uses a mock class called ParkServiceMock to mock the callout response
Create unit tests:

Unit tests must cover all lines of code included in the ParkLocator class, resulting in 100% code coverage.
Run your test class at least once (via Run All tests the Developer Console) before attempting to verify this challenge.
*/

//Park Locator Class
public class ParkLocator {
    public static String[] country(String country){
        ParkService.ParksImplPort parks = new ParkService.ParksImplPort();
        String[] parksname = parks.byCountry(country);
        return parksname;
    }
}

//Park Service Mock Class
@isTest
global class ParkServiceMock implements WebServiceMock {
   global void doInvoke(
        Object stub,
        Object request,
        Map<String, Object> response,
        String endpoint,
        String soapAction,
        String requestName,
        String responseNS,
        String responseName,
        String responseType) {
        ParkService.byCountryResponse response_x = new ParkService.byCountryResponse();
        List<String> str = new List<String> {'Park1','Park2','Park3'};
        response_x.return_x = str;
        response.put('response_x', response_x); 
   }
}

//Park Locator Test Class
@isTest
private class ParkLocatorTest  {
    @isTest static void testCallout() {              
        Test.setMock(WebServiceMock.class, new ParkServiceMock());
        List<String> result = new List<String>();
        List<String> expected = new List<String>{'Park1','Park2','Park3'};
        result = ParkLocator.country('India');
        System.assertEquals(expected, result); 
    }
}