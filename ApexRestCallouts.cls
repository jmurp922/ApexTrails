/*
Create an Apex class that calls a REST endpoint and write a test class.
Create an Apex class that calls a REST endpoint to return the name of an animal, write unit tests that achieve 100% code coverage for the class using a mock response, and run your Apex tests.
Create an Apex class:
Name: AnimalLocator
Method name: getAnimalNameById
The method must accept an Integer and return a String.
The method must call https://th-apex-http-callout.herokuapp.com/animals/id, using the ID passed into the method 
The method returns the value of the name property (i.e., the animal name)
Create a test class:
Name: AnimalLocatorTest
The test class uses a mock class called AnimalLocatorMock to mock the callout response
Create unit tests:
Unit tests must cover all lines of code included in the AnimalLocator class, resulting in 100% code coverage
Run your test class at least once (via Run All tests the Developer Console) before attempting to verify this challenge
*/

//Animal Locator Class

public class AnimalLocator {
    public static String getAnimalNameById(Integer incID) {
        Http http = new Http();
        HttpRequest request = new HTTPRequest();
        request.setEndpoint('https://th-apex-http-callout.herokuapp.com/animals/' + incID);
        request.setMethod('GET');
        HTTPResponse response = http.send(request);
        String respAnimal;
        If  (response.getStatusCode() == 200) {
            Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            Map<String, Object> animals = (map<String, Object>) results.get('animal');
            respAnimal = String.valueOf(animals.get('name'));
        }
        return respAnimal;
    }

}

//Animal Locator Test Class

@isTest
public class AnimalLocatorTest {
	@isTest
    public static void AnimalLocatorTest(){
        Test.setMock(HttpCalloutMock.class, new AnimalLocatorMock());
        String result = AnimalLocator.getAnimalNameById(0);
        String animal = 'majestic badger';
        System.assertEquals(animal, result);
    }
}

//Animal Locator Mock Test

@isTest
global class AnimalLocatorMock implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest request) {
        HTTPResponse response = new HTTPResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{"animal":{"id":1,"name":"chicken","eats":"chicken food","says":"cluck cluck"}}');
        response.setStatusCode(200);
        return response;
    }

}