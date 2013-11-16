<p align="center">

## About
This is a proof of concept delivery fulfillment app that shows how to tightly integrate a 3rd party Java app like this one into Salesforce using <b>Force.com Canvas</b>.

## How it Works
On its own it performs 2 tasks:

1. Displays list of `Shipments` that either need to be or have been delivered 
2. Allows a user to select a shipment and create either a text post, link post, or confirmation (canvas) post. 
* text post: takes the body of the feed item typed by the user (if any) and also creates a comment using the selected shipment.
* link post: takes the body of the feed item typed by the user (if any) and also creates a link to the app living on Heroku for the selected shipment. 
* confirmation post: takes the body of the feed item typed by the user (if any) and also posts a canvas app to the feed with the feed item details displayed (description, title, etc) defined by the selected shipment.


## How to set it up
While the app is fine, the user still has to:

1. Log in to Salesforce
2. Create a Connected App in Salesforce with this apps URL (on Heroku or elsewhere) and add APP_SECRET (Consumer Secret) and RUNNING_ON_HEROKU (true or false) as env vars
3. Add Canvas into a global publisher action to track deliveries


#SFDC Canvas Java Template  

Force.com Canvas is a mashup framework for consuming third party applications within Salesforce. Its goal is to connect applications at a UI level instead of an API level. Platform Connect will provide third party applications with a JavaScript SDK along with Java classes so they can seamlessly integrate canvas style applications, while developing in the technology and platform of their choice. 

### Important files to note for the workbook
    SignedRequest.java: handles the verify and decode of the environment vars and signed request
    canvas.jsp: determines where you are viewing the Canvas from and routes the appropriate view
    shipment.js: handles all of the interactions in the publisher

### Important code snippets 

**Code Snippet #1: shipment.js**
This snippet makes a post to Chatter of type "CanvasPost." You can see that it is dynamically setting all of the post values, and grabs the Canvas app information from the signed request. You also have the ability to pass in parameters which will be appended to the URL to be used in the Chatter feed Canvas app.

    else if ("approval" === action) {
        p.feedItemType = "CanvasPost";
        p.auxText = "Please confirm this shipment status: " + shipments[shipment].description;
        p.namespace =  sr.context.application.namespace;
        p.developerName =  sr.context.application.developerName;
        p.thumbnailUrl = "https://cdn1.iconfinder.com/data/icons/VISTA/project_managment/png/48/deliverables.png";
        p.parameters =  "{\"shipment\":\"" + shipment + "\"}";
        p.title = shipments[shipment].description;
        p.description = "This is a travel shipment for Shipment - " + shipments[shipment].description + ".  Click the link to open the Canvas App.";
    }

  **Code Snippet #2: shipment.js**
  This snippet of code runs at the end of a function that is only called when all of the required element have been selected in the Canvas. Until this statement is called, the "Submit" button on the publisher cannot be pressed. This ensures that the end user cannot make a post until they have selected all the necessary elements of the Canvas application. Once this method is called, the "Submit" button becomes active. 
  
  $$ > the Sfdc.canvas
  {name : 'publisher.setValidForSubmit', payload : true} > makes the submit button active

     $$.client.publish(sr.client, {name : 'publisher.setValidForSubmit', payload : true});

  **Code Snippet #3: shipment.js**
  This snippet uses the "Submit" (ie publish) button to publish the FeedItem to the Chatter feed. Depending on which type of post you selected, it will post a different type (text, link, Canvas). 

  $$ > the Sfdc.canvas
  {name : 'publisher.setPayload', payload : p} > publishes the action using the submit button, passes the p (FeedItem) to chatter 

    $$.client.publish(sr.client, {name : 'publisher.setPayload', payload : p});

### How to Build The app locally

    mvn package
    
### First time keystore generation (for local SSL support)

      > keytool -keystore keystore -alias jetty -genkey -keyalg RSA
      Enter keystore password: 123456
      Re-enter new password: 123456
      What is your first and last name?
        [Unknown]:  
      What is the name of your organizational unit?
        [Unknown]:  <Your Org Unit>
      What is the name of your organization?
        [Unknown]:  <Your Org>
      What is the name of your City or Locality?
        [Unknown]:  <Your City>
      What is the name of your State or Province?
        [Unknown]: <Your State> 
      What is the two-letter country code for this unit?
        [Unknown]:  <Your Country>
      Is CN=<Your Name>, OU=<Your OU>, O=<Your O>, L=<Your Locality>, ST=<Your State>, C=<Your Country>?
        [no]:  yes

      Enter key password for <jetty>
	(RETURN if same as keystore password):  
      Re-enter new password: 

### How to Run Canvas locally

    sh target/bin/webapp

### How to invoke app locally

    https:/localhost:8443
    
### Canvas URL

    https://localhost:8443/canvas.jsp
    or on Heroku
    https://<your-heroku-app>.herokuapp.com/canvas.jsp
    
### Canvas Callback URLs
    
    https://localhost:8443/sdk/callback.html
    or on Heroku
    https://<your-heroku-app>.herokuapp.com/sdk/callback.html

### How to push new changes to heroku

      git add -A
      git commit -m "My change comments"
      git push heroku master

### How to get Heroku logs
      
      heroku logs --tail




