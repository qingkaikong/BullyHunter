<!DOCTYPE html>
<%@ page language="java" import="java.lang.*" import="java.sql.*" %>
<%@ page contentType="text/html; charset=iso-8859-1" language="java" %>
<%@ page import="java.sql.*" %> 
<%@ page import="java.io.*" %> 
<html>
  <head>
    <title>Simple Map</title>
    <meta name="viewport" content="initial-scale=1.0, user-scalable=no">
    <meta charset="utf-8">
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
                background: aqua;
                margin: auto;
                padding: 10px;
            }
            div#one {
                width: 25%;
                height: 100%;
                background: white;
                float: left;
            }
            div#map-canvas {
                margin-left: 15%;
                height: 100%;
                background: white;
            }
        </style>
        <script src="https://maps.googleapis.com/maps/api/js?v=3.exp"></script>
   
    <script>
var map;
var flag=0;
var geocoder;
function  usedatabase(str)
{
    <% String connector;
     try {

        String connectionURL = "jdbc:sqlite:/Users/qk0840/qingkai/BullyHunter/bullyhunter/bullyhunter/tweets.db";
        Connection connection = null;
        Class.forName("org.sqlite.JDBC").newInstance();
        connection = DriverManager.getConnection(connectionURL);
        if (!connection.isClosed()) {
            Statement st = connection.createStatement();
            ResultSet rs=null;
             rs = st.executeQuery("select * from tweets");
                while (rs.next()) {
            %>
                var a = "<%=rs.getString(7)%>";
                if (a != "None")
                {
                    var textvalue = "<%=rs.getString(8)%>";
                    var geovalue = a.split(",");
                    var lat = geovalue[0];
                    var longvalue = geovalue[1];
                    var myLatlng = new google.maps.LatLng(lat, longvalue);
                    alert(textvalue);
                    codegeo(lat,longvalue,textvalue);
                }
                else
                {
                    var city = "<%=rs.getString(5)%>";
                    var state = "<%=rs.getString(6)%>";
                    var address = city + "," + state;
                    var textvalue = "<%=rs.getString(8)%>";
                    alert(address);
                    codeAddress(address, textvalue)

                }
                  <%
                }
                
        }connection.close();
     }
     catch(Exception ex)
     {
          %>    var a= "<%=ex.toString() %>";
                  alert("ELSE"+a);<%
     }
    %>
}
   function codegeo(lat,longvalue,textvalue)
            {
                alert("I am here"+lat+longvalue+textvalue);
                 var latlngset = new google.maps.LatLng(lat, longvalue);
                    var marker = new google.maps.Marker({  
                        map: map, position: latlngset  
                    });
                     var infowindow = new google.maps.InfoWindow({
                            content: textvalue
                        });
                        google.maps.event.addListener(marker, 'click', function() {
                            infowindow.open(map, marker);

                        });
                    
                    
            }
function codeAddress(address, textvalue) {
                alert("hello");
                geocoder = new google.maps.Geocoder();
                geocoder.geocode({'address': address}, function(results, status) {

                    if (status == google.maps.GeocoderStatus.OK) {
                        map.setCenter(results[0].geometry.location);
                        var marker = new google.maps.Marker({
                            map: map,
                            position: results[0].geometry.location
                        });
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
                var x = document.forms["myForm"]["filtercategory"].value;
                alert(x);
                var detailsvalue;
                detailsvalue = document.forms["myForm"]["detailsbox"].value;
                alert("Cheack " + detailsvalue);
                if (x == 'City')
                {
                    x = "city='" + detailsvalue + "'";
                    alert(x);
                    
                    document.location.href = "myindex.jsp?" + x;
                    usedatabase(x);
                }
                if (x == null || x == "") {
                    alert("Name must be filled out");
                    return false;
                }
            }
 function initialize() {
                if (flag === 0)
                {
                    alert("ajskfkfsadkjads");
                    map = new google.maps.Map(document.getElementById('map-canvas'), {
                        zoom: 4,
                        center: {lat: 32.73, lng: -96.97}
                    });

                    /*alert(document.getElementById("hiddenField").value);
                     */
                  usedatabase("");
                }
                flag = 1;
            }
           
window.onload=function(){
    initialize();
    
}

    </script>
  </head>
  <body >

    <center><h1>Bully Buster</h1></center>

    <section>
        <form method="post" name="myForm">
            <div id="one">
                Enter Details: <input type="text" name="detailsbox"/><br/>
                <input type="radio" name="filtercategory" value="Pincode">Pincode
                <br/>
                <input type="radio" name="filtercategory" value="Location Name" >Location Name 
                <br/>
                <input type="radio" name="filtercategory" value="City" >City
                <br/>
                <input type="hidden" id="hiddenField"/>
                <!-- Column one start -->
                <!-- Column one end -->
                <button name="data" type="button" >Click</button> 
               
        </form>

    </div>
    <div id="map-canvas"></div>
</section>

</body>
</html>