package bookstore;

import ballerina.log;
import ballerina.math;
import ballerina.net.http;
import ballerina.net.jms;

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
    resource placeOrder (http:Request request, http:Response response) {
        // Get the JSON payload from the user request
        json reqPayload = request.getJsonPayload();
        string source = reqPayload["Source"].toString();
        string destination = reqPayload["Destination"].toString();
        string vehicleType = reqPayload["Vehicle"].toString();
        string phoneNumber = reqPayload["PhoneNumber"].toString();
        // Send response to the user
        json responseMessage = {"Message":"Order successful. You will get an SMS when a vehicle is available"};
        response.setJsonPayload(responseMessage);
        _ = response.send();

       \
                addToJmsQueue(phoneNumber);
                log:printInfo("Phone number added to the message queue");
                break;
            }
        }
    }
}

// Function to handle availability checking logic
function checkAvailability (string source, string destination, string vehicleType) (boolean) {
    int availability = math:randomInRange(0, 2);
    return (<boolean>availability);
}

// Function to add messages to the JMS queue
function addToJmsQueue (string phoneNumber) {
    endpoint<jms:JmsClient> jmsEP {
        create jms:JmsClient(getConnectorConfig());
    }
    // Create an empty Ballerina message
    jms:JMSMessage queueMessage = jms:createTextMessage(getConnectorConfig());
    // Set a string payload to the message
    queueMessage.setTextMessageContent(phoneNumber);
    // Send the message to the JMS provider
    jmsEP.send("messageQueue", queueMessage);
}

function getConnectorConfig () (jms:ClientProperties) {
    // Here connection properties are defined as a map. 'providerUrl' or 'configFilePath' and the
    // 'initialContextFactory' vary according to the JMS provider you use
    // In this example WSO2 MB server has been used as the message broker
    jms:ClientProperties properties = {initialContextFactory:"wso2mbInitialContextFactory",
                                          configFilePath:"/home/pranavan/IdeaProjects/Ballerina-samples/" +
                                                         "MessagingWithJMS/resources/jndi.properties",
                                          connectionFactoryName:"QueueConnectionFactory",
                                          connectionFactoryType:"queue"};
    return properties;
}
