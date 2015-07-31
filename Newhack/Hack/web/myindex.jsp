<!DOCTYPE html>
<%@ page language="java" import="java.lang.*" import="java.sql.*" %>
<%@ page contentType="text/html; charset=iso-8859-1" language="java" %>
<%@ page import="java.sql.*" %> 
<%@ page import="java.io.*" %> 
<html>
    <head>
        <script src="//code.jquery.com/jquery-1.11.3.min.js"></script>
        <script src="//code.jquery.com/jquery-migrate-1.2.1.min.js"></script>
        <script src="https://maps.googleapis.com/maps/api/js?v=3.exp&libraries=places"></script>
        <title>Simple Map</title>

        <style>
            html, body {
                height: 100%;
                margin: 0;
                padding: 0;
            }

            #filterdiv
            {
                margin-top: 10%;
                width: 45%;
                height: 100%;

            }
            section {
                width: 90%;
                height: 100%;

                margin: auto;
                padding: 10px;
            }
            div#one {
                width: 25%;
                height: 100%;
                background:  #FFFFFF;
                float: left;
                border-radius: 15px;
                padding:10px;
            }
            div#map-canvas {
                margin-left: 15%;
                height: 100%;
                background:  #04B4AE;
            }
            h1 { color: #7c795d; font-family: 'Trocchi', serif; font-size: 25px; font-weight: normal; line-height: 48px; margin: 0; }
            table { 
                color: #333; /* Lighten up font color */
                font-family: Helvetica, Arial, sans-serif; /* Nicer font */
                width: 640px; 
                border-collapse: 
                    collapse; border-spacing: 0; 
            }

            td, th { border: 1px solid #CCC; height: 30px; } /* Make cells a bit taller */

            th {
                background: #F3F3F3; /* Light grey background */
                font-weight: bold; /* Make sure they're bold */
            }
            label
            {
                color:  #7c795d;
                font-size: 20px;
            }
            td {
                background: #FAFAFA; /* Lighter grey background */
                text-align: center; /* Center our text */
            }
            #headerdiv {
                background-color: #FFFFFF;
                width: 90%;
                border-radius: 25px;
            }
            button{
                border-top: 1px solid #96d1f8;
                background: #65a9d7;
                background: -webkit-gradient(linear, left top, left bottom, from(#3e779d), to(#65a9d7));
                background: -webkit-linear-gradient(top, #3e779d, #65a9d7);
                background: -moz-linear-gradient(top, #3e779d, #65a9d7);
                background: -ms-linear-gradient(top, #3e779d, #65a9d7);
                background: -o-linear-gradient(top, #3e779d, #65a9d7);
                padding: 5px 10px;
                -webkit-border-radius: 8px;
                -moz-border-radius: 8px;
                border-radius: 8px;
                -webkit-box-shadow: rgba(0,0,0,1) 0 1px 0;
                -moz-box-shadow: rgba(0,0,0,1) 0 1px 0;
                box-shadow: rgba(0,0,0,1) 0 1px 0;
                text-shadow: rgba(0,0,0,.4) 0 1px 0;
                color: white;
                font-size: 14px;
                font-family: Georgia, serif;
                text-decoration: none;
                vertical-align: middle;
            }

        </style>
        <script src="https://maps.googleapis.com/maps/api/js?v=3.exp"></script>
        <script>
            var map;
            var flag = 0;
            var geocoder;
            var markerslist = [];
            var tweetlist = [];
            var citylist = []
            function usedatabase(str)
            {


            <% String connector;
                if (request.getParameter("hiddenField") != null) {%>
                var x = <%=request.getParameter("hiddenField")%>

            <%
                }
                int apple = 1;
                try {

                    String connectionURL = "jdbc:mysql://localhost/hackathon";
                    Connection connection = null;
                    Class.forName("com.mysql.jdbc.Driver").newInstance();
                    connection = DriverManager.getConnection(connectionURL, "root", "");
                    if (!connection.isClosed()) {
                        Statement st = connection.createStatement();
                        ResultSet rs = null;

                        String searchstringcity = "";
                        String hidden = "";
                        if (request.getParameter("hiddenField") != null) {
                            hidden = request.getParameter("hiddenField");
                            rs = st.executeQuery("select * from tweet where city = '" + hidden + "'");

                        }
                        hidden = request.getParameter("hiddenField");
                        searchstringcity = "city='" + request.getParameter("hiddenField") + "'";

                        String searchstringzipcode = "";

                        searchstringzipcode = "state='" + request.getParameter("state") + "'";
                        String searchstringlocation = "";

                        searchstringlocation = "zipcode='" + request.getParameter("zipcode") + "'";
                        if (searchstringcity.length() == 0 && searchstringzipcode.length() == 0 && searchstringlocation.length() == 0) {

                            rs = st.executeQuery("select * from tweet");
                        } else {

                            if (searchstringcity.length() != 0) {
                                rs = st.executeQuery("select * from tweet where " + searchstringcity);
                            } else if (searchstringlocation.length() != 0) {
                                rs = st.executeQuery("select * from tweet where " + searchstringlocation);
                            } else if (searchstringzipcode.length() != 0) {
                                rs = st.executeQuery("select * from tweet where " + searchstringzipcode);
                            } else {
                                rs = st.executeQuery("select * from tweet");
                            }
                        }
            %>
                var a = <%=searchstringcity%>;
                /*      alert("Hai" + str);
                 */

                var key = 0;

            <%

                rs = st.executeQuery("select * from tweet");
                while (rs.next()) {
            %>
                var a = "<%=rs.getString(3)%>";


                if (a != "")
                {
                    var textvalue = "<%=rs.getString(4)%>";
                    var geovalue = a.split(",");
                    var lat = geovalue[0];
                    var longvalue = geovalue[1];
                    tweetlist.push(textvalue);
                    citylist.push("UNKNOWN");
                    codegeo(lat, longvalue, textvalue);
                }
                else
                {
                    var city = "<%=rs.getString(1)%>";

                    var state = "<%=rs.getString(2)%>";
                    var address = city + "," + state;
                    var textvalue = "<%=rs.getString(4)%>";
                    tweetlist.push(textvalue);
                    citylist.push(city);

                    codeAddress(address, textvalue)

                }
            <%

                        }
                    }
                    connection.close();
                } catch (Exception ex) {

                    out.println("Unable to connect to database" + ex);
                }
            %>
            }


            function initialize() {
                if (flag === 0)
                {

                    map = new google.maps.Map(document.getElementById('map-canvas'), {
                        zoom: 4,
                        center: {lat: 32.73, lng: -96.97},
                        types: ['school']
                    });

                    /*alert(document.getElementById("hiddenField").value);
                     */
                    usedatabase("");
                }
                flag = 1;
            }
            function codegeo(lat, longvalue, textvalue)
            {

                var latlngset = new google.maps.LatLng(lat, longvalue);
                var marker = new google.maps.Marker({
                    map: map, position: latlngset
                });
                markerslist.push(marker);
                var infowindow = new google.maps.InfoWindow({
                    content: textvalue
                });
                google.maps.event.addListener(marker, 'click', function() {
                    infowindow.open(map, marker);

                });

            }
            function codeAddress(address, textvalue) {

                geocoder = new google.maps.Geocoder();
                geocoder.geocode({'address': address}, function(results, status) {

                    if (status == google.maps.GeocoderStatus.OK) {
                        map.setCenter(results[0].geometry.location);
                        var marker = new google.maps.Marker({
                            map: map,
                            position: results[0].geometry.location
                        });
                        markerslist.push(marker);
                        var infowindow = new google.maps.InfoWindow({
                            content: textvalue
                        });
                        google.maps.event.addListener(marker, 'click', function() {
                            infowindow.open(map, marker);

                        });
                    } else {
                        alert('Geocode was not successful for the following reason: ' + status);
                    }
                });
            }

            function filtervalue() {
                tweetlist = [];
                citylist = [];
                var x = document.forms["myForm"]["filtercategory"].value;

                var detailsvalue;
                detailsvalue = document.forms["myForm"]["detailsbox"].value;

                if (x == 'City')
                {
                    clearMarkers();
                    x = detailsvalue;
                    document.getElementById("hiddenField").value = x;

                    hidden = $("#hiddenField").val();
                    typevariable = "c";
                    $($.post("/Hack/database.jsp", {hiddenField: hidden, typevariable: typevariable})
                            .done(function(data)
                            {

                                var obj = jQuery.parseJSON(data);

                                if (obj.Data.length === 0)
                                {
                                    alert("Data Unavailable for the city")
                                    return false;
                                }
                                for (i = 0; i < obj.Data.length; i++)
                                {
                                    if (obj.Data[i].geo != "")
                                    {
                                        var textvalue = obj.Data[i].text;
                                        var geovalue = obj.Data[i].geo.split(",");
                                        var lat = geovalue[0];
                                        var longvalue = geovalue[1];
                                        tweetlist.push(textvalue);
                                        citylist.push("UNKNOWN");
                                        codegeo(lat, longvalue, textvalue);
                                    }
                                    else
                                    {
                                        var city = obj.Data[i].Cities;
                                        var state = obj.Data[i].state;
                                        var address = city + "," + state;
                                        var textvalue = obj.Data[i].text;
                                        tweetlist.push(textvalue);
                                        citylist.push(city);
                                        codeAddress(address, textvalue)
                                    }
                                }

                            }));


                }
                if (x == 'state')
                {
                    clearMarkers();
                    x = document.getElementById("selectbox").value;
                    document.getElementById("hiddenField").value = x;

                    hidden = $("#hiddenField").val();

                    typevariable = "s";
                    $($.post("/Hack/database.jsp", {hiddenField: hidden, typevariable: typevariable})
                            .done(function(data)
                            {

                                var obj = jQuery.parseJSON(data);
                                if (obj.Data.length === 0)
                                    alert("Data Unavailable for the state")
                                for (i = 0; i < obj.Data.length; i++)
                                {

                                    if (obj.Data[i].geo != "")
                                    {
                                        var textvalue = obj.Data[i].text;
                                        tweetlist.push(textvalue);
                                        citylist.push("UNKNOWN");
                                        var geovalue = obj.Data[i].geo.split(",");
                                        var lat = geovalue[0];
                                        var longvalue = geovalue[1];

                                        codegeo(lat, longvalue, textvalue);
                                    }
                                    else
                                    {
                                        var city = obj.Data[i].Cities;
                                        var state = obj.Data[i].state;
                                        var address = city + "," + state;
                                        var textvalue = obj.Data[i].text;

                                        tweetlist.push(textvalue);
                                        citylist.push(city);
                                        codeAddress(address, textvalue)
                                    }
                                }

                            }));


                }
                if (x == null || x == "") {
                    alert("Name must be filled out");
                    return false;
                }
            }
            function clearMarkers() {


                setAllMap(null);
                markerslist = [];

            }
            function setAllMap(map) {
                for (var i = 0; i < markerslist.length; i++) {
                    markerslist[i].setMap(map);
                }
            }
            function givesummary()
            {

                var i = 0;
                myDeleteFunction();


                for (i = 0; i < tweetlist.length; i++)
                {
                    myCreateFunction(tweetlist[i], citylist[i]);
                }
                if (tweetlist.length > 0)
                    alert("There are a total of " + tweetlist.length + " tweets");
                else
                    alert("There are no tweets from the place you selected. Try again later")
                var table = document.getElementById("myTable");
                var header = table.createTHead();
                var row = header.insertRow(0);
                var cell1 = row.insertCell(0);
                var cell2 = row.insertCell(0);
                cell1.innerHTML = "<b>Tweet</b>";
                cell2.innerHTML = "<b>City</b>";

            }

            function myCreateFunction(tweet, city) {

                var table = document.getElementById("myTable");
                var row = table.insertRow(0);
                var cell1 = row.insertCell(0);
                var cell2 = row.insertCell(0);
                cell1.innerHTML = tweet;
                cell2.innerHTML = city;

            }

            function myDeleteFunction() {
                var resultsTable = document.getElementById("myTable");

                var i = 0;
                while (resultsTable.hasChildNodes())
                {
                    resultsTable.removeChild(resultsTable.firstChild);
                }
            }
            window.onload = function() {
                initialize();

            }
            $(document).ready(function() {

                $("#detailsbox").hide();
                $("#selectbox").hide();
                $("#selectlabel").text("  Please Select an Option");
                $("#statebox").click(function() {
                    $("#detailsbox").hide();
                    $("#selectbox").show();
                    $("#selectlabel").text("  Please Select a state");
                });
                $("#citybox").click(function() {
                    $("#detailsbox").show();
                    $("#selectlabel").text("  Please Enter a city: ");
                    $("#selectbox").hide();
                });
            });

        </script>

    </head>
    <body style="background-color:#65a9d7" >
    <center>
        <br>
        <div id="headerdiv">    
            <center><h1>Bully Buster</h1></center>
        </div>
    </center>
    <section>
        <form method="post" name="myForm">

            <div id="one">
                <br>
                &nbsp;<label id="selectlabel"></label>
                <br/>
                &nbsp;<input type="text" name="detailsbox" id="detailsbox"/>
                <br/>
                &nbsp;<select name="filtercategory" id="selectbox">
                    <option value="AL">AL</option>
                    <option value="AK">AK</option>
                    <option value="AZ">AZ</option>
                    <option value="AR">AR</option>
                    <option value="CA">CA</option>
                    <option value="CO">CO</option>
                    <option value="CT">CT</option>
                    <option value="DE">DE</option>
                    <option value="FL">FL</option>
                    <option value="GA">GA</option>
                    <option value="HI">HI</option>
                    <option value="ID">ID</option>
                    <option value="IL">IL</option>
                    <option value="IN">IN</option>
                    <option value="IA">IA</option>
                    <option value="KS">KS</option>
                    <option value="KY">KY</option>
                    <option value="LA">LA</option>
                    <option value="ME">ME</option>
                    <option value="MD">MD</option>
                    <option value="MA">MA</option>
                    <option value="MI">MI</option>
                    <option value="MN">MN</option>
                    <option value="MS">MS</option>
                    <option value="MO">MO</option>
                    <option value="MT">MT</option>
                    <option value="NE">NE</option>
                    <option value="NV">NV</option>
                    <option value="NH">NH</option>
                    <option value="NJ">NJ</option>
                    <option value="NM">NM</option>
                    <option value="NY">NY</option>
                    <option value="NC">NC</option>
                    <option value="ND">ND</option>
                    <option value="OH">OH</option>
                    <option value="OK">OK</option>
                    <option value="OR">OR</option>
                    <option value="PA">PA</option>
                    <option value="RI">RI</option>
                    <option value="SC">SC</option>
                    <option value="SD">SD</option>
                    <option value="TN">TN</option>
                    <option value="TX">TX</option>
                    <option value="UT">UT</option>
                    <option value="VT">VT</option>
                    <option value="VA">VA</option>
                    <option value="WA">WA</option>
                    <option value="WV">WV</option>
                    <option value="WI">WI</option>
                    <option value="WY">WY</option>


                </select>
                <br>
                <input type="radio" name="filtercategory" id="statebox" value="state" style=" color:  #7c795d;font-size: 20px;" >State
                <br/>
                <input type="radio" name="filtercategory" id="citybox" value="City" style=" color:  #7c795d;font-size: 20px;">City
                <br/>
                <input type="hidden" id="hiddenField"/>
                <!-- Column one start -->
                <!-- Column one end -->
                <br>
                <center>
                    <button name="data" type="button" onclick="filtervalue();">Filter</button> 
                    <button name="data" type="button" onclick="givesummary();">Give Summary of tweets</button>
                </center>
                <br>
                <br>
                </form>

            </div>
            <div id="map-canvas"></div>
    </section>
    <center>
        <table id="myTable" border="1">

        </table>
    </center>

</body>
</html>