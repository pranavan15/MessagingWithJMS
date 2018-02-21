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

book[] bookInventory = [{bookId:1, bookName:"Tom Jones", authorName:"Henry Fielding"},
                    {bookId:2, bookName:"The Rainbow", authorName:"D. H. Lawrence"},
                    {bookId:3, bookName:"Lolita", authorName:"Vladimir Nabokov"},
                    {bookId:4, bookName:"Atonement", authorName:"Ian McEwan"},
                    {bookId:5, bookName:"Hamlet", authorName:"William Shakespeare"}];

@http:configuration {basePath:"/bookStore"}
service<http> bookstoreService {
    resource placeOrder (http:Connection httpConnection, http:InRequest request) {
        http:OutResponse response = {};
        order bookOrder = {};
        TypeConversionError intConversionError;

        try {
            // Get the JSON payload from the user request
            json reqPayload = request.getJsonPayload();
            bookOrder.customerName = reqPayload["Name"].toString();
            bookOrder.address = reqPayload["Address"].toString();
            bookOrder.contactNumber = reqPayload["ContactNumber"].toString();
            bookOrder.bookId, intConversionError = <int>reqPayload["BookId"].toString();
        } catch (error err) {
            response.statusCode = 400;
            response.setJsonPayload({"Message":"Bad Request: Invalid payload"});
            _ = httpConnection.respond(response);
            return;
        }

        if (intConversionError != null || bookOrder.bookId <= 0) {
            response.statusCode = 400;
            response.setJsonPayload({"Message":"Bad Request: Field 'bookId' should be a positive integer"});
            _ = httpConnection.respond(response);
            return;
        }

        //addToJmsQueue(bookOrder);
        log:printInfo("New order added to the message queue");

        // Send response to the user
        response.setJsonPayload({"Message":"Your order is successfully placed. Ordered book will be delivered soon"});
        _ = httpConnection.respond(response);
    }

    resource getAvailableBooks (http:Connection httpConnection, http:InRequest request) {
        http:OutResponse response = {};
    }
}

//// Function to add messages to the JMS queue
//function addToJmsQueue (order bookOrder) {
//    endpoint<jms:JmsClient> jmsEP {
//        create jms:JmsClient(getConnectorConfig());
//    }
//    // Create an empty Ballerina message
//    jms:JMSMessage queueMessage = jms:createTextMessage(getConnectorConfig());
//    // Set a string payload to the message
//    var bookOrderDetails, _ = <json>bookOrder;
//    queueMessage.setTextMessageContent(bookOrderDetails.toString());
//    // Send the message to the JMS provider
//    jmsEP.send("messageQueue", queueMessage);
//}
//
//function getConnectorConfig () (jms:ClientProperties) {
//    // Here connection properties are defined as a map. 'providerUrl' or 'configFilePath' and the
//    // 'initialContextFactory' vary according to the JMS provider you use
//    // In this example WSO2 MB server has been used as the message broker
//    jms:ClientProperties properties = {initialContextFactory:"wso2mbInitialContextFactory",
//                                          configFilePath:"/home/pranavan/IdeaProjects/SAMPLES/" +
//                                                         "MessagingWithJMS/bookstore/resources/jndi.properties",
//                                          connectionFactoryName:"QueueConnectionFactory",
//                                          connectionFactoryType:"queue"};
//    return properties;
//}