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

<%@ page import="java.util.Map" %>

<%@ page import="canvas.SignedRequest" %>
<%@ page import="java.util.Map" %>
<%@ page import="canvas.CanvasRequest" %>
<%
    // Pull the signed request out of the request body and verify/decode it.
    System.out.println("WDT...............") ;
    Map<String, String[]> parameters = request.getParameterMap();
    String[] signedRequest = parameters.get("signed_request");
    String yourConsumerSecret=System.getenv("APP_SECRET");
    System.out.println("WDT...............") ;
    if (signedRequest != null) {
        CanvasRequest cr = SignedRequest.verifyAndDecode(signedRequest[0], yourConsumerSecret);
        System.out.println("DisplayLocation = " + cr.getContext().getEnvironmentContext().getDisplayLocation());

        /* this determines that the environment you are viewing from is the publisher therefore displays the page associated with that view */
        if ("Publisher".equals(cr.getContext().getEnvironmentContext().getDisplayLocation())) {
            %><jsp:forward page="publisher.jsp"/><%
        }

        /* this determines that the environment you are viewing from is the chatter feed therefore displays the page associated with that view */
        else if ("ChatterFeed".equals(cr.getContext().getEnvironmentContext().getDisplayLocation())) {
            %><jsp:forward page="feed.jsp"/><%
        }

        /* this determines that the environment you are viewing from is the anywhere else in salesforce (ie VF/Chatter tab/Canvas App
        * Previewer/Global Action etc) therefore displays the page associated with that view 
        */
        else {
            %><jsp:forward page="signed-request.jsp"/><%
        }

    /* this else statement runs when you are not viewing within Salesforce and no signed_request is passed in */
    } else {
        %><jsp:forward page="welcome.jsp"/><%
    }
%>