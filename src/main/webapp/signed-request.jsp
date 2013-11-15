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
    <link href="css/custom-theme/jquery-ui-1.9.2.custom.css" rel="stylesheet" type="text/css" />
    <link href="css/style.css" rel="stylesheet" type="text/css" />

    <%-- todo move to css file --%>
    <style>
        .ui-selecting { background: #C4E7F2; }
        .ui-selected {
            background: #C4E7F2;
            /*background: #e4f5ff;*/
            /*background: -moz-linear-gradient(#fff,#e4f5ff 60%);*/
            /*background: -webkit-linear-gradient(#fff,#e4f5ff 60%);*/
            /*background: -ms-linear-gradient(#fff,#e4f5ff 60%);*/
            font-weight: 700;}
        .hide {
		    display:none;
		}
		.show {
		    display:block;
		}
    </style>


    <script type="text/javascript" src="sdk/js/canvas-all.js"></script>
    <script type="text/javascript" src="js/jquery-1.8.3.js"></script>
    <script type="text/javascript" src="js/jquery-ui-1.9.2.custom.min.js"></script>
    <script type="text/javascript" src="js/jquery.chromatable.js"></script>
    <script type="text/javascript" src="scripts/json2.js"></script>
    <script type="text/javascript" src="scripts/shipment.js"></script>

    <script>
        var module;

        $(document).ready(function(){
            module.draw();
        });
        Sfdc.canvas(function() {
            var sr = JSON.parse('<%=signedRequestJson%>');
            module = shipment.instance(sr);
            Sfdc.canvas.client.subscribe(sr.client, module.subscriptions);
            Sfdc.canvas.client.resize(sr.client, {height : "225px"});
            console.log("Canvas Done....");
        });
        
    </script>
</head>
<body>
<div class="clear">
    <h3>Shipments</h3>
    <div id="shipmentsdiv" class="show">
    	<table id="reservations" width="100%" border="0" cellspacing="0" cellpadding="0">
	        <thead>
        	<tr>
    	        <th class="status">Status</th>
	            <th class="description">Description</th>
            	<th class="date">Date</th>
        	</tr>
    	    </thead>
	        <tbody>
        	</tbody>
    	</table><br />
	    <form>
    	    <div id="radio">
	            <input type="radio" id="share" name="radio" checked="checked"/><label for="share">Text Post</label>
            	<input type="radio" id="link" name="radio"  /><label for="link">Link Post</label>
            	<input type="radio" id="approval" name="radio"  /><label for="approval">Approval Post</label>
    	    </div>
	    </form>
	</div>
</div>
</body>
</html>
