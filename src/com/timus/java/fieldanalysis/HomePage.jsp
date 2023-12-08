<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    <%@page import="com.ibm.openpages.api.metadata.Id"%>
<%@page import="com.ibm.openpages.api.resource.IIdField"%>
<%@page import="com.ibm.openpages.api.metadata.DataType"%>
<%@page import="com.ibm.openpages.api.metadata.IEnumValue"%>
<%@page import="com.ibm.openpages.api.resource.IMultiEnumField"%>
<%@page import="com.ibm.openpages.api.resource.IFloatField"%>
<%@page import="com.ibm.openpages.api.resource.IReferenceField"%>
<%@page import="com.ibm.openpages.api.resource.IEnumField"%>
<%@page import="com.ibm.openpages.api.resource.IStringField"%>
<%@page import="com.ibm.openpages.api.resource.IDateField"%>
<%@page import="com.ibm.openpages.api.resource.IIntegerField"%>
<%@page import="com.ibm.openpages.api.resource.IBooleanField"%>
<%@page import="com.ibm.openpages.api.configuration.ICurrency"%>
<%@page import="com.ibm.openpages.api.resource.ICurrencyField"%>
<%@page import="com.ibm.openpages.api.resource.IField"%>
<%@page import="com.ibm.openpages.api.query.IResultSetRow"%>
<%@page import="com.ibm.openpages.api.query.ITabularResultSet"%>
<%@page import="com.ibm.openpages.api.query.IQuery"%>
<%@page import="com.ibm.openpages.api.service.IQueryService"%>
<%@page import="com.ibm.openpages.api.service.IConfigurationService"%>
<%@page import="com.ibm.openpages.api.configuration.IReportingPeriod"%>
<%@page import="com.ibm.openpages.api.metadata.ITypeDefinition"%>
<%@page import="com.ibm.openpages.api.service.IMetaDataService"%>
<%@page import="com.ibm.openpages.api.service.ISecurityService"%>
<%@page import="com.ibm.openpages.api.service.IServiceFactory"%>
<%@page import="com.ibm.openpages.api.service.ServiceFactory"%>
<%@page import="com.ibm.openpages.api.ServerType"%>
<%@page import="com.ibm.openpages.api.Context"%>
<%@page import="com.ibm.openpages.api.OpenPagesException"%>
<%@page import="org.apache.log4j.Logger"%>
<%@page import="java.util.UUID"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="java.io.PrintWriter"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.HashSet"%>
<%@page import="java.util.*"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.io.File"%>
<%@page import="java.io.FileOutputStream"%>
<%@page import="java.io.InputStream"%>
<%@page import="java.io.InputStreamReader"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.util.HashMap"%>
<%@page import="com.timus.java.fieldanalysis.*"%>
<!DOCTYPE html>
<html>
<head>
<style>
    body {
      background-color: #E6F7FF;
      font-family: Arial, sans-serif;
    }

    .container {
      width: 400px;
      margin: 50px auto;
      background-color: #D0EFC6;
      padding: 20px;
      border-radius: 5px;
      box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.2);
    }

    .form-group {
      margin-bottom: 20px;
    }

    .form-label {
      display: block;
      font-weight: bold;
      margin-bottom: 5px;
    }

    .form-control {
      width: 100%;
      padding: 8px;
      border: 1px solid #84C1FF;
      border-radius: 4px;
    }

    .submit-btn {
      background-color: #00BFFF;
      color: #fff;
      border: none;
      padding: 10px 20px;
      border-radius: 4px;
      cursor: pointer;
      transition: background-color 0.3s;
    }

    .submit-btn:hover {
      background-color: #008B8B;
    }
  </style>
<meta charset="ISO-8859-1">
<title>Home Page</title>
<script>
//JS For Buffering Image
function showLoader() {
		document.getElementById('loader').style.display = 'block';
		window.addEventListener('unload', hideLoader);
	}

	function hideLoader() {
		document.getElementById('loader').style.display = 'none';
	}
</script>
</head>
<body>
        <div style="text-align: center"> <h2 style="margin-left: 10px">Welcome to Field Usage Analysis Utility</h2></div>
<div class="container">
        <form action="FieldAnalysis.jsp" onsubmit="showLoader(); document.getElementById('submitButton').style.display = 'none';">
        <div class="form-group" style="text-align: center">
                            <lable>Please select an object type : </lable>
                            <br></br>
                                <select name="obtype" onchange="updateSelectedValue(this)">
                                    <%
                                     FieldAnalysis fa = new FieldAnalysis();
                                     fa.getServiceFactory(request, response);
                                     List<String> OBTypes = fa.getObjectTypes();
                                     
                                    for (int i = 0; i < OBTypes.size(); i++) {
                                        String objectTypeName = (String)OBTypes.get(i);
                                    %>
                                    <option value="<%=objectTypeName%>"><%=objectTypeName%></option>
                                    <%
                                    }
                                    %>
                                </select>
                                <br></br>
                                <div id="loader" style="display: none;">
			<img id = "bufferingImage" src="/ServicenowImages/loading-65.gif" style="width: 70px; height: 70px;" alt="Loading...">
		</div>
                        <input id = "submitButton" class="submit-btn" value="Execute" type="submit" onsubmit="showLoader()" />
                        </div>
                    </form>
        </div>
</body>
</html>