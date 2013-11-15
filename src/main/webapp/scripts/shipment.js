(function ($, $$) {

    "use strict";

    var action = "share", shipment;

    /* this makes fake data for the canvas app */
    var shipments = {
            123:
            {id : 123, status : "Waiting",  description : "Cellular Accessories and Phones",  date: "12/20/2013",
                trucks : [
                    {truck : "Box Truck 304", driverNumber : "D4702",
                        departs : {city : "Denver, CO", day : "12/18/2013", time : "08:15 AM"},
                        arrives : {city : "San Francisco, CA", day : "09/20/2013", time : "09:30 AM"}},
                    {truck : "Box Truck 512", driverNumber : "D0123",
                        departs : {city : "Los Angeles, CA", day : "12/19/2013", time : "08:00 AM"},
                        arrives : {city : "San Francisco, CA", day : "12/19/2013", time : "5:00 PM"}}
                ],
                destination : {name : "The Tech Store", address : {street : "55 Fourth Street", city : "San Francisco", state : "CA", zip : "94103"}},
                total : "$23500.00"
            },
            124:
            {id : 124, status : "Approved", description : "Laptop Supplies",  date: "09/10/2013",
                trucks : [
                    {truck : "Bus 005", driverNumber : "D2702",
                        departs : {city : "Austin, TX", day : "09/5/2013", time : "08:15 AM"},
                        arrives : {city : "San Francisco, CA", day : "09/10/2013", time : "09:30 AM"}},
                    {truck : "Lowboy 201", driverNumber : "UA123",
                        departs : {city : "Las Vegas, NV", day : "09/8/2013", time : "08:00 AM"},
                        arrives : {city : "San Francisco, CA", day : "09/10/2013", time : "5:00 PM"}}
                ],
                destination : {name : "DigiMedia", address : {street : "150 Van Ness St", city : "San Francisco", state : "CA", zip : "94134"}},
                total : "$17750.00"
            },
            125:
            {id : 125, status : "Complete", description : "Tablets",  date: "06/18/2013",
                trucks : [
                    {truck : "Box Truck 117", driverNumber : "D6702",
                        departs : {city : "Salt Lake City, UT", day : "06/14/2013", time : "08:00 AM"},
                        arrives : {city : "San Francisco, CA", day : "06/18/2013", time : "09:30 AM"}}
                ],
                destination : {name : "Munder Difflin Paperless Company", address : {street : "160 Brannan St", city : "San Francisco", state : "CA", zip : "94103"}},
                total : "$13000.00"
            },
            126:
            {id : 126, status : "Complete", description : "TVs, Projectors, and Desktops, oh my!",  date: "04/02/2013",
                trucks : [
                    {truck : "Bus 006", driverNumber : "D2202",
                        departs : {city : "Portland, OR", day : "04/02/2013", time : "08:15 AM"},
                        arrives : {city : "San Francisco, CA", day : "04/05/2013", time : "09:30 AM"}},
                    {truck : "Box Truck 215", driverNumber : "D8123",
                        departs : {city : "San Diego, CA", day : "04/10/2013", time : "03:00 PM"},
                        arrives : {city : "San Francisco, CA", day : "04/12/2013", time : "5:30 PM"}}
                ],
                destination : {name : "Salesforce", address : {street : "1 Market St", city : "San Francisco", state : "CA", zip : "94105"}},
                total : "$3300.00"
            }
        };
    
    var module = {

        instance : function (sr) {
            var payload;

            /* this will revert the table back to its original state if called*/
            function refresh(id) {
                var v, $tbody;
                if (!$$.isNil(id)) {
                    $tbody = $("#reservation tbody");
                    v = shipments[id];
                    $tbody.append(
                        "<tr id='"+ id + "'><td id='status'>" + v.status  +
                            "</td><td>" + v.description + "</td><td>" + v.total + "</td><td>" + v.date + "</td></tr>");
                }
                else {
                    $tbody = $("#reservations tbody");
                    $.each(shipments, function(i, v) {
                        $tbody.append(
                            "<tr id='"+ i + "'><td>" + v.status  +
                                "</td><td>" + v.description + "</td><td>" + v.date + "</td></tr>");
                    });
                }
            }

            /* this generates the text post information based off of the shipment selected */
            function prettyPrint(id) {

                var it = shipments[id];

                var text = "My Shipment For: " + it.description + "\n";
                	text += "Status: " + it.status + "\n";
                	text += "Date: " + it.date + "\n\n";
                    for (var i = 0; i < it.trucks.length; i++) {
                        var f = it.trucks[i];
                        text += "Truck: " + f.truck + " " + f.driverNumber + "- " + f.departs.city +"\n";
                        text += "Departs: " + f.departs.city + ": " + f.departs.day + " " + f.departs.time + "\n";
                        text += "Arrives: " + f.arrives.city + ": " + f.departs.day + " " + f.arrives.time + "\n\n";
                    }
                    text += "Shipped To: " + it.destination.name + ", " + it.destination.address.street + ", " + it.destination.address.city + ", " + it.destination.address.state + "\n";
                    text += "Total Cost: " + it.total;

                return text;
            }

            /* this changes the shipment status in the CanvasPost when you click the button */
            function updateShipmentStatus(id) {

                $(function() {
                    $("button" )
                        .button()
                        .click(function( event ) {
                            event.preventDefault();
                            action = $(this).attr("id");
                            $("#status").empty().append(("completed" === action) ? "Completed" : "Cancelled");
                        });
                });

                console.log("Mark Complete...." + id);
                refresh(id);
            }

            /* this determines to see which row you selected and what kind of post you wanted to make */
            function draw() {

                $("#reservations").chromatable({
                    width: "100%",
                    height: "100%",
                    scrolling: "yes"
                });

                /* this grabs information from the shipment selected */
                $("#reservations").selectable({
                    filter:'tr',
                    selected: function(event, ui){
                        var s = $(this).find('.ui-selected');
                        shipment = s[0].id;
                        console.log("Shipment: " + shipment);

                        // @review - generate named methods instead (fireEnable())
                        console.log("Fire event from client");

                        /* the line below makes the "Share" button on the publisher active and clickable for a submit */
                        $$.client.publish(sr.client, {name : 'publisher.setValidForSubmit', payload : true});
                    }
                });

                /* all of the buttons are styled radio buttons and associated with acitons to perform*/
                $( "#radio" ).buttonset();
                $("#radio :radio").click(function(e) {
                    var rawElement = this;
                    var $element = $(this);
                    action = $(this).attr("id");
                    console.log("Action: " + action);
                });
                
                $( "#switch" ).buttonset();
                $("#switch :radio").click(function(e) {
                    var rawElement = this;
                    var $element = $(this);
                    var tempAction = $(this).attr("id");
                  	action = "share";
                    $('#reservations .ui-selected').removeClass('ui-selected')
                    console.log("Action: " + action);
                });
                
                $( "#radio2" ).buttonset();
				$("#radio2 :radio").click(function(e) {
                    var rawElement = this;
                    var $element = $(this);
                    action = $(this).attr("id");
                    console.log("Action: " + action);
                });
                
                refresh();
            }
            
            /* these are the handler responses for all of the subscriptions */
            var handlers = {
                onSetupPanel : function(payload) {
                	console.log("EH Module setupPanel..", payload);
                },
                onShowPanel : function(payload) {
                    console.log("EH Module showPanel", payload);
                },

                /* this subscription is for when you click out of the canvas app but don't refresh the page
                * and you want the canvas to go back to its original state. This is most applicable in
                * canvas in a publisher action in Aloha where you can toggle between different actions
                * on the same screen 
                */
                onClearPanelState : function(payload) {
                    console.log("EH Module clearPanelState");
                    // Clear the selected reservation
                    $('#reservations .ui-selected').removeClass('ui-selected')
                    
                    // Clear the selected radio buttons
                    $('input[name="radio"]').prop('checked', false);
                    
                    // Re enable the default selection
                    action = "share";
                    $('#share').prop('checked', true);
                    $("#radio :radio").button( "refresh");
                    $('#itin').prop('checked', true);
                },
                onSuccess : function() {
                    console.log("EH Module onSuccess");
                },
                onFailure : function (payload) {
                    /* This logs the error to the console. Currently you only see console error in the standard (non-mobile) publisher */
                    console.log(JSON.stringify(payload, null, 4));
                    console.log("EH Module onFailure");
                },

                /* when you select a shipment, a type of post, and then click share, this will take that payload (selection data) 
                * and create the appopriate ype of post out of it 
                */
                onGetPayload : function () {
                    var p = {};
                    console.log("EH Module getPayload");
                    if ("share" === action) {
                        p.feedItemType = "TextPost";
                        p.auxText = prettyPrint(shipment);
                    }
                    else if ("link" === action) {
                        p.feedItemType = "LinkPost"; 
                        p.auxText = "Please confirm this shipment status: " + shipments[shipment].description;

                        /* 
                        * change this to your heroku app url 
                        */
                        p.url = "https://[YOUR_APP_URL].herokuapp.com/signed-request.jsp?shipment=" + shipment; 
                        p.urlName = shipments[shipment].description;
                    }

                    /* this piece creates the CanvasPost. Things to note:
                    * p.feedItemType = CanvasPost
                    * p.auxText > cannot be more than 255 chars 
                    * p.namespace/developerName > can be pulled from signed request or manually from your org/connected app
                    * p.thumbnailUrl = the icon you see in the chatter feed
                    * p.parameters > can be passed into the CanvasApp in the environment context 
                    * p.Title > cannot be more than 40 chars 
                    */
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
                    
                    // Note: we can extend the payload here to include more then just value.
                    $$.client.publish(sr.client, {name : 'publisher.setPayload', payload : p});
                }
            };

            var that = {

                draw : draw,
                refresh : refresh,
                updateShipmentStatus : updateShipmentStatus,

                // Subscriptions to callbacks from publisher...
                subscriptions : [
                    {name : 'publisher.setupPanel', onData : handlers.onSetupPanel},
                    {name : 'publisher.showPanel', onData : handlers.onShowPanel},
                    {name : 'publisher.clearPanelState',  onData : handlers.onClearPanelState},
                    {name : 'publisher.failure', onData : handlers.onFailure},
                    {name : 'publisher.success', onData : handlers.onSuccess},
                    {name : 'publisher.getPayload', onData : handlers.onGetPayload}
                ]
            };
            return that;
        }
    };

    // Replace with module pattern
    window.shipment = module;

}(jQuery, Sfdc.canvas));