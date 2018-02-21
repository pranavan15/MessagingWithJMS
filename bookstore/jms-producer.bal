package bookstore;

import ballerina.log;
import ballerina.net.http;
//import ballerina.net.jms;

struct order {
    string customerName;
    string address;
    string contactNumber;
    int bookId;
}

struct book {
    int bookId;
    string bookName;
    string authorName;
}

book[] inventory = [{bookId:1, bookName:"Tom Jones", authorName:"Henry Fielding"},
                    {bookId:2, bookName:"The Rainbow", authorName:"D. H. Lawrence"},
                    {bookId:3, bookName:"Lolita", authorName:"Vladimir Nabokov"},
                    {bookId:4, bookName:"Atonement", authorName:"Ian McEwan"},
                    {bookId:5, bookName:"Hamlet", authorName:"William Shakespeare"}];

service<http> bookstoreService {
    resource placeOrder (http:Connection httpConnection, http:InRequest request) {
        http:OutResponse response = {};
        json responseMessage = {};
        order bookOrder;
        TypeCastError intCastError;

        try {
            // Get the JSON payload from the user request
            json reqPayload = request.getJsonPayload();
            bookOrder.customerName = reqPayload["Name"].toString();
            bookOrder.address = reqPayload["Address"].toString();
            bookOrder.contactNumber = reqPayload["contactNumber"].toString();
            bookOrder.bookId, intCastError = (int)reqPayload["bookId"];
        } catch (error err) {

        }

        if (castError != null || bookOrder.bookId <= 0) {
            response.statusCode = 400;
            responseMessage = {"Message":"Bad request; field 'bookId' needs to be a positive integer value"};
            _ = httpConnection.respond(response);
            return;
        }
        println(bookOrder);
        // Send response to the user
        responseMessage = {"Message":"Your order is successfully placed. Ordered book will be delivered soon"};
        response.setJsonPayload(responseMessage);
        _ = httpConnection.respond(response);

        //addToJmsQueue(phoneNumber);
        log:printInfo("Phone number added to the message queue");

    }
}

//// Function to add messages to the JMS queue
//function addToJmsQueue (string phoneNumber) {
//    endpoint<jms:JmsClient> jmsEP {
//        create jms:JmsClient(getConnectorConfig());
//    }
//    // Create an empty Ballerina message
//    jms:JMSMessage queueMessage = jms:createTextMessage(getConnectorConfig());
//    // Set a string payload to the message
//    queueMessage.setTextMessageContent(phoneNumber);
//    // Send the message to the JMS provider
//    jmsEP.send("messageQueue", queueMessage);
//}
//
//function getConnectorConfig () (jms:ClientProperties) {
//    // Here connection properties are defined as a map. 'providerUrl' or 'configFilePath' and the
//    // 'initialContextFactory' vary according to the JMS provider you use
//    // In this example WSO2 MB server has been used as the message broker
//    jms:ClientProperties properties = {initialContextFactory:"wso2mbInitialContextFactory",
//                                          configFilePath:"/home/pranavan/IdeaProjects/Ballerina-samples/" +
//                                                         "MessagingWithJMS/resources/jndi.properties",
//                                          connectionFactoryName:"QueueConnectionFactory",
//                                          connectionFactoryType:"queue"};
//    return properties;
//}
