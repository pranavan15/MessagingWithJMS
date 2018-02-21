package bookstore;

//import ballerina.log;
//import ballerina.net.jms;
//
//@Description {value:"Service level annotation to provide connection details.
//                      Connection factory type can be either queue or topic depending on the requirement. "}
//
//@jms:configuration {
//    initialContextFactory:"wso2mbInitialContextFactory",
//    providerUrl:
//    "amqp://admin:admin@carbon/carbon?brokerlist='tcp://localhost:5675'",
//    connectionFactoryName:"QueueConnectionFactory",
//    concurrentConsumers:300,
//    destination:"messageQueue"
//}
//
//// JMS service that consumes messages from the JMS queue
//service<jms> sendSms {
//    resource onMessage (jms:JMSMessage message) {
//        log:printInfo("Message received from jms-producer");
//        // Retrieve the string payload using native function
//        string stringPayload = message.getTextMessageContent();
//        println(stringPayload);
//        //sendSmsToPhone(stringPayload);
//    }
//}

//// Function to handle SMS sending logic
//function sendSmsToPhone (string number) {
//    log:printInfo("Successfully sent SMS to: " + number);
//    log:printInfo("SMS Content: Hello user! Vehicle available for your journey\n");
//}
