package bookstore.jmsProducer;

import ballerina.test;
import ballerina.net.jms;

//  Unit test for testing getConnectorConfig() function
function testGetConnectorConfig () {
    // Get the JMS client properties
    jms:ClientProperties properties = getConnectorConfig();
    // 'properties' should not be null
    test:assertTrue(properties != null, "Cannot obtain JMS client connector configurations!");
    // Check whether the configurations are as expected
    test:assertStringEquals("QueueConnectionFactory", properties.connectionFactoryName,
                            "Jms client connector configurations mismatch!");
    test:assertStringEquals("queue", properties.connectionFactoryType,
                            "Jms client connection configurations mismatch!");
}

//  Unit test for testing addToJmsQueue() function
function testAddToJmsQueue () {
    // Construct a new order
    order bookOrder = {customerName:"TestUser", address:"20, Palm Grove, Colombo, Sri Lanka",
                          contactNumber:"+94777123456", orderedBookName:"Hamlet"};
    // Add the order to the JMS queue
    error jmsError = addToJmsQueue(bookOrder);
    // 'jmsError' is expected to be null
    test:assertTrue(jmsError == null, "Cannot add order to JMS queue! Error Msg: " + jmsError.msg);
}
