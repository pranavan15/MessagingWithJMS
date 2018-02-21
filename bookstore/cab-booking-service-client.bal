package bookstore;
//
//import ballerina.log;
//import ballerina.net.http;
//
//// Client to consume Cab booking service
//public function main (string[] args) {
//    endpoint<http:HttpClient> httpEndpoint {
//        create http:HttpClient("http://localhost:9090", {});
//    }
//
//    http:Request request = {};
//    http:Response response = {};
//    // Set request body
//    json requestBody = {"Source":"Colombo", "Destination":"Kandy", "Vehicle":"Car", "PhoneNumber":"0777123123"};
//    request.setJsonPayload(requestBody);
//    // Initiate a POST request
//    response, _ = httpEndpoint.post("/cabBookingService/placeOrder", request);
//    // Get the JSON response
//    json jsonResponse = response.getJsonPayload();
//    log:printInfo(jsonResponse.toString());
//}
