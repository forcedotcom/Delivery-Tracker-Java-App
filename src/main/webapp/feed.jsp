<%--
Copyright (c) 2011, salesforce.com, inc.
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided
that the following conditions are met:

Redistributions of source code must retain the above copyright notice, this list of conditions and the
following disclaimer.

Redistributions in binary form must reproduce the above copyright notice, this list of conditions and
the following disclaimer in the documentation and/or other materials provided with the distribution.

Neither the name of salesforce.com, inc. nor the names of its contributors may be used to endorse or
promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED
WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
POSSIBILITY OF SUCH DAMAGE.
--%>

<%@ page import="canvas.SignedRequest" %>
<%@ page import="java.util.Map" %>
<%
    // Pull the signed request out of the request body and verify/decode it.
    Map<String, String[]> parameters = request.getParameterMap();
    String[] signedRequest = parameters.get("signed_request");
    String yourConsumerSecret=System.getenv("APP_SECRET");
    String signedRequestJson = null;
    if (signedRequest != null) {
        signedRequestJson = SignedRequest.verifyAndDecodeAsJson(signedRequest[0], yourConsumerSecret);
    }
%>
<!DOCTYPE html>
<html>
<head>

    <link href="css/custom-theme/jquery-ui-1.9.2.custom.min.css" rel="stylesheet" type="text/css" />
    <link href="css/style.css" rel="stylesheet" type="text/css" />

    <script type="text/javascript" src="sdk/js/canvas-all.js"></script>
    <script type="text/javascript" src="js/jquery-1.8.3.js"></script>
    <script type="text/javascript" src="js/jquery-ui-1.9.2.custom.min.js"></script>
    <script type="text/javascript" src="scripts/json2.js"></script>
    <script type="text/javascript" src="scripts/shipment.js"></script>

    <script>
        var module;
        console.log("Signed Request = " + '<%=signedRequestJson%>');
        var sr = JSON.parse('<%=signedRequestJson%>');

		var urlParams;
		function getItin() {
    		var match,
		        pl     = /\+/g,  // Regex for replacing addition symbol with a space
	    	    search = /([^&=]+)=?([^&]*)/g,
        		decode = function (s) { return decodeURIComponent(s.replace(pl, " ")); },
        		query  = window.location.search.substring(1);

  			urlParams = {};
			while (match = search.exec(query))
				urlParams[decode(match[1])] = decode(match[2]);
		};

        $(document).ready(function(){

            console.log("JQuery Ready...");
            getItin();
            var id = (!!sr) ? (!!sr.context.environment.parameters.shipment ? sr.context.environment.parameters.shipment : ((!!urlParams["shipment"]) ? urlParams["shipment"] : "123")) : ((!!urlParams["shipment"]) ? urlParams["shipment"] : "123");
            console.log("SR: " + sr);
            console.log("sr.context.environment.parameters.shipment: " + sr.context.environment.parameters.shipment);
            console.log("urlParams: " + urlParams); 
            console.log("Shipment:" + id);
            module.updateShipmentStatus(id);

        });
        
        Sfdc.canvas(function() {
            console.log("Canvas Ready...");
            module = shipment.instance(sr);
            Sfdc.canvas.client.subscribe(sr.client, module.subscriptions);
        });
    </script>
</head>
<body>
<div>
    <div class="feed-post">
    <table id="reservation" width="100%" border="0" cellspacing="0" cellpadding="0">
        <thead>
        <tr>
            <th class="status">Status</th>
            <th class="description">Description</th>
            <th class="cost">Cost</th>
            <th class="date">Date</th>
        </tr>
        </thead>
        <tbody>
        </tbody>
    </table>
    </div>
    <div class="zen-btn-container">
    <button class="zen-btn" id="completed">Complete</button>
    <button class="zen-btn" id="cancelled">Cancelled</button>
    </div>

</div>
</body>
</html>
