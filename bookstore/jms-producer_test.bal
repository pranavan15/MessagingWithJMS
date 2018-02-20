package bookstore;

import ballerina.test;
import ballerina.net.http;


function testCabBookingService () {
    endpoint<http:HttpClient> httpEndpoint {
        create http:HttpClient("http://localhost:9090", {});
    }

    http:Request request = {};
    http:Response response = {};
    // Set request body
    json requestBody = {"Source":"Colombo", "Destination":"Kandy", "Vehicle":"Car", "PhoneNumber":"0777123123"};
    request.setJsonPayload(requestBody);
    // Start cabBookingService
    _ = test:startService("cabBookingService");
    // Send a POST request to cabBookingService
    response, _ = httpEndpoint.post("/cabBookingService/placeOrder", request);
    string stringResponse = response.getJsonPayload().toString();
    // Assert Response
    test:assertStringEquals(stringResponse, "{\"Message\":\"Order successful. " +
                                            "You will get an SMS when a vehicle is available\"}", "Response mismatch!");
}

function testGetConnectorConfig () {
    jms:ClientProperties properties = getConnectorConfig();
    test:assertStringEquals("wso2mbInitialContextFactory", properties.initialContextFactory,
                            "Jms client connection configuration mismatch!");
    test:assertStringEquals("QueueConnectionFactory", properties.connectionFactoryName,
                            "Jms client connection configuration mismatch!");
    test:assertStringEquals("queue", properties.connectionFactoryType, "Jms client connection configuration mismatch!");
}