<%@ page language="java" import="java.lang.*" import="java.sql.*" %>
<%@ page contentType="text/html; charset=iso-8859-1" language="java" %>
<%@ page import="java.sql.*" %> 
<%@ page import="java.io.*" %> 
<%
    try {
        String connectionURL = "jdbc:mysql://localhost/hackathon";
        Connection connection = null;
        Class.forName("com.mysql.jdbc.Driver").newInstance();
        connection = DriverManager.getConnection(connectionURL, "root", "");
        if (!connection.isClosed()) {
            Statement st = connection.createStatement();
            ResultSet rs = null;
            String hidden = "";
            if (request.getParameter("hiddenField") != null) {
                if (request.getParameter("typevariable").equals("c")) {
                    hidden = request.getParameter("hiddenField");
                    rs = st.executeQuery("select * from tweet where city = '" + hidden + "'");

                    int i = 0;
                    int flag = 0;
                    out.println("{\"Data\":[");
                    while (rs.next()) {

                        if (flag == 1) {
                            out.println(",{");
                        } /*out.println(",\"Cities\":\""+rs.getString(2)+"\"");
                         */ else {
                            out.println("{");
                        }
                        out.println("\"Cities\":\"" + rs.getString(1) + "\"");
                        out.println(",\"state\":\"" + rs.getString(2) + "\"");
                        out.println(",\"geo\":\"" + rs.getString(3) + "\"");
                        out.println(",\"text\":\"" + rs.getString(4) + "\"");
                        flag = 1;
                        i++;

                        out.println("}");
                    }
                    out.println("]}");

                }
                if (request.getParameter("typevariable").equals("s")) {
                    hidden = request.getParameter("hiddenField");
                    rs = st.executeQuery("select * from tweet where state = '" + hidden + "'");

                    int i = 0;
                    int flag = 0;
                    out.println("{\"Data\":[");
                    while (rs.next()) {

                        if (flag == 1) {
                            out.println(",{");
                        } /*out.println(",\"Cities\":\""+rs.getString(2)+"\"");
                         */ else {
                            out.println("{");
                        }
                        out.println("\"Cities\":\"" + rs.getString(1) + "\"");
                        out.println(",\"state\":\"" + rs.getString(2) + "\"");
                        out.println(",\"geo\":\"" + rs.getString(3) + "\"");
                        out.println(",\"text\":\"" + rs.getString(4) + "\"");
                        flag = 1;
                        i++;

                        out.println("}");
                    }
                    out.println("]}");

                }
            }
        }
        connection.close();
    } catch (Exception ex) {
        out.println("Unable to connect to database" + ex);
    }
%>
