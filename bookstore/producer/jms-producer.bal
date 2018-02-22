package bookstore.producer;

import ballerina.log;
import ballerina.net.http;
import ballerina.net.jms;

struct order {
    string customerName;
    string address;
    string contactNumber;
    string orderedBookName;
}

json[] bookInventory = ["Tom Jones", "The Rainbow", "Lolita", "Atonement", "Hamlet"];

@http:configuration {basePath:"/bookStore"}
service<http> bookstoreService {
    resource placeOrder (http:Connection httpConnection, http:InRequest request) {
        http:OutResponse response = {};
        order bookOrder = {};

        try {
            // Get the JSON payload from the user request
            json reqPayload = request.getJsonPayload();
            bookOrder.customerName = reqPayload["Name"].toString();
            bookOrder.address = reqPayload["Address"].toString();
            bookOrder.contactNumber = reqPayload["ContactNumber"].toString();
            bookOrder.orderedBookName = reqPayload["BookName"].toString();
        } catch (error err) {
            response.statusCode = 400;
            response.setJsonPayload({"Message":"Bad Request: Invalid payload"});
            _ = httpConnection.respond(response);
            return;
        }
        boolean isBookAvailable;
        foreach book in bookInventory {
            if (bookOrder.orderedBookName.trim().equalsIgnoreCase(book.toString())) {
                isBookAvailable = true;
                break;
            }
        }
        json responseMessage;
        if(isBookAvailable) {
            responseMessage = {"Message":"Your order is successfully placed. Ordered book will be delivered soon"};
            addToJmsQueue(bookOrder);
            log:printInfo("New order added to the JMS Queue; CustomerName: '" + bookOrder.customerName
                          + "', OrderedBook: '" + bookOrder.orderedBookName + "';");
        }
        else {
            responseMessage = {"Message":"Requested book not available"};
        }

        // Send response to the user
        response.setJsonPayload(responseMessage);
        _ = httpConnection.respond(response);
    }

    resource getAvailableBooks (http:Connection httpConnection, http:InRequest request) {
        http:OutResponse response = {};
        response.setJsonPayload(bookInventory);
        _ = httpConnection.respond(response);
    }
}

// Function to add messages to the JMS queue
function addToJmsQueue (order bookOrder) {
    endpoint<jms:JmsClient> jmsEP {
        create jms:JmsClient(getConnectorConfig());
    }
    // Create an empty Ballerina message
    jms:JMSMessage queueMessage = jms:createTextMessage(getConnectorConfig());
    // Set a string payload to the message
    var bookOrderDetails, _ = <json>bookOrder;
    queueMessage.setTextMessageContent(bookOrderDetails.toString());
    // Send the message to the JMS provider
    jmsEP.send("OrderQueue", queueMessage);
}

function getConnectorConfig () (jms:ClientProperties) {
    // Here connection properties are defined as a map. 'providerUrl' or 'configFilePath' and the
    // 'initialContextFactory' vary according to the JMS provider you use
    // In this example WSO2 MB server has been used as the message broker
    jms:ClientProperties properties = {initialContextFactory:"wso2mbInitialContextFactory",
                                          configFilePath:"/home/pranavan/IdeaProjects/SAMPLES/MessagingWithJMS/bookstore/resources/jndi.properties",
                                          connectionFactoryName:"QueueConnectionFactory",
                                          connectionFactoryType:"queue"};
    return properties;
}
