<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
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
<%@page import="com.ibm.openpages.api.metadata.IFieldDefinition"%>
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
<%
System.out.println("==== ad-hoc query test jsp ====");
IServiceFactory serviceFactory = null;
FieldAnalysis fa = new FieldAnalysis();

serviceFactory = fa.getServiceFactory(request, response);

String objectType = request.getParameter("obtype");
Logger.getLogger(this.getClass()).error("this is object type : " + objectType);
PrintWriter pw = new PrintWriter(out);
String FieldValue = "";
String FieldGroup = "";
Date before = new Date();
String reportTitle = "fIELD ANALYSIS";
int rowspan = -1;
int totalNumberOfRecords = fa.totalNumberOfRecords(objectType, serviceFactory);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Timus OP Field Usage Utility</title>
<style>
/* CSS for the page layout */
body {
	background-color: #f2f2f2;
	font-family: Arial, sans-serif;
	margin: 0;
	padding: 20px;
}

.container {
	display: flex;
	flex-direction: column;
	max-width: 600px;
	margin: 0 auto;
	background-color: #ffffff;
	border-radius: 10px;
	box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
}

.form-container {
	padding: 20px;
}

form {
	margin-bottom: 20px;
}

label {
	display: block;
	margin-bottom: 10px;
	color: #333333;
	font-weight: bold;
}

/* CSS for the table */
table {
	width: 100%;
	border-collapse: collapse;
}

td {
	border-bottom: 1px solid #dddddd;
	text-align: left;
}

th {
	height: 50px;
	background-color: #2196f3;
	color: #ffffff;
}

table.dataTable thead th {
	height: 13px; /* Adjust the height as per your requirement */
}

.container {
	display: flex;
	justify-content: center;
	align-items: center;
	max-width: 220px;
}

.container input {
	margin-bottom: 10px;
}

.chart-container {
	
}

.chart-container .chartjs-render-monitor .tick {
	font-size: 5px;
}

.chartCard {
	width: 100vw;
	height: calc(100vh - 40px);
	background: rgba(54, 162, 235, 0.2);
	display: flex;
	align-items: center;
	justify-content: center;
}

.chartBox {
	width: 700px;
	padding: 20px;
	border-radius: 20px;
	border: solid 3px rgba(54, 162, 235, 1);
	background: white;
}

.container01 {
	width: 100%;
	max-width: 100%;
	overflow-x: scroll;
}

.containerBody {
	height: 500px;
}

.wrapper {
display: flex;
}

.inner-div {
  margin-right:160px;
}

.inner-div left {
  margin-right: auto;
}
</style>
<link rel="stylesheet" href="/UtilityFiles/jquery.dataTables.min.css">
<link rel="stylesheet" href="/UtilityFiles/PieChartCSS01.css">
<link rel="stylesheet" href="/UtilityFiles/PieChartCSS02.css">
<script src="/UtilityFiles/chart.js"></script>
<script src="/UtilityFiles/jQuery.js"></script>
<script src="/UtilityFiles/jquery.dataTables.min.js"></script>
<script src="/UtilityFiles/dataTables.searchPanes.min.js"></script>
<script src="/UtilityFiles/dataTables.select.min.js"></script>
<script src="/UtilityFiles/highcharts.js"></script>
<script src="/UtilityFiles/Accessibility.js"></script>
<script src="/UtilityFiles/highcharts-more.js"></script>
<script src="/UtilityFiles/chartjs.js"></script>
<script src="/UtilityFiles/jspdf.umd.min.js"></script>
<script>
//JS For Sorting
	$(document).ready(
			function() {

				var minEl = $('#min');
				var maxEl = $('#max');

				// Custom range filtering function
				$.fn.dataTable.ext.search.push(function(settings, data,
						dataIndex) {
					var min = parseInt(minEl.val(), 10);
					var max = parseInt(maxEl.val(), 10);
					var age = parseFloat(data[3]) || 0; // use data for the age column

					if ((isNaN(min) && isNaN(max))
							|| (isNaN(min) && age <= max)
							|| (min <= age && isNaN(max))
							|| (min <= age && age <= max)) {
						return true;
					}

					return false;
				});

				var table = $('#myTable').DataTable({
					   "lengthMenu": [ [2, 4, 8, -1], [2, 4, 8, "All"] ],
					   "pageLength": 4
					});

				minEl.on('input', function() {
					table.draw();
				});
				maxEl.on('input', function() {
					table.draw();
				});
			});
	//================================================================================================================
	
// Fetch the dynamically generated table data

	  document.addEventListener('DOMContentLoaded', function() {
		var tableData = [];
		$('#myTable tbody tr').each(function() {
			var row = {};
			//row.fieldGroup = $(this).find('td:eq(0)').text();
			row.fieldName = $(this).find('td:eq(1)').text();
			//row.recordCount = parseInt($(this).find('td:eq(2)').text());
			row.percentage = parseFloat($(this).find('td:eq(3)').text());
			tableData.push(row);
		});

		 var ctx = document.getElementById('myChart');
		 
		 //=====================================================================================================
			 
			 const data = {
			      labels: tableData.map(function(row) {
						return row.fieldName;
					}),
			      datasets: [{
			        label: 'Field Analysis',
			        data: tableData.map(function(row) {
						return row.percentage;
					}),
			        backgroundColor: 'rgba(54, 162, 235, 0.5)',
			        borderColor : 'rgba(54, 162, 235, 1)',
			        borderWidth: 1
			      }]
			    }; 
		 
			 // config 
			    const config = {
			      type: 'bar',
			      data,
			      options: {
			    	  maintainAspectRatio:false,
			        scales: {
			          y: {
			            beginAtZero: true
			          },
			          x : {
							beginAtZero : true,
							 ticks : 
							 {
								maxRotation : 90,
								minRotation : 90,
							 }, 
						}
			        }
			      }
			    };
			 
			 // render init block
			    const myChart = new Chart(
			      document.getElementById('myChart'),
			      config
			    );
			    
			    const containerBody = document.querySelector('.containerBody');
			    if(myChart.data.labels.length>10)
			    {
			    	containerBody.style.width='3000px';
			    }
			 
		 //=====================================================================================================
	 });
	function goBack() {
	      window.history.back();
	    }
</script>
</head>
<body>
	<div>
		<h2 style="text-align: center">
			Field Usage Analysis of
			<%=objectType%>
			Object Type
		</h2>
	</div>
	<div>
		<%
		try {
			IFieldDefinition d = serviceFactory.createMetaDataService().getType("SOXRisk").getFieldsDefinition().get(10);
			String s = d.getName();
			Logger.getLogger(this.getClass()).error("This is field name : "+s);
			
			HashMap<String, List<String>> fnfg01 = new HashMap<String, List<String>>();
			// get access to each field in a row
			for (IFieldDefinition field0 : serviceFactory.createMetaDataService().getType("SOXRisk").getFieldsDefinition()) {
				String records = field0.getName();
				if (records.contains(":")) {
					String[] fnf = records.split(":");
					String fieldgroup = fnf[0];
					String field = fnf[1];
					if (fnfg01.containsKey(fieldgroup)) {
						List<String> temp = fnfg01.get(fieldgroup);
						temp.add(field);
						fnfg01.put(fieldgroup, temp);
					} else {
						List<String> fieldList = new ArrayList<String>();
						fieldList.add(field);
						fnfg01.put(fieldgroup, fieldList);
					}
				}
			}
			
			 for (Map.Entry<String, List<String>> entry : fnfg01.entrySet()) {
		            String key = entry.getKey();
		            	Logger.getLogger(this.getClass()).error("These are Hashmap keys : "+key);
		            List<String> value = entry.getValue();
		            for(String ob : value)
		            {
		            	Logger.getLogger(this.getClass()).error("These are Hashmap values : "+ob);
		            }
		            System.out.println("Key: " + key + ", Value: " + value);
		        }
			
			Logger.getLogger(this.getClass()).error("This is hashmap : "+fnfg01.toString());
			//Calling HashMap containing FieldGroups and fields.
			HashMap<String, List<String>> fnfg = fa.getFieldsAndFG(request, objectType);
			if (objectType != null) {
		%>
		<div align="center" style="margin-top: 20px;">
			<div class="wrapper">
				<div class = "inner-div left">
					Total Number of Records:<b><%=totalNumberOfRecords%></b>
				</div>
				<div class="inner-div">
					<label for="min">Min % Used:</label> <input type="text" id="min"
						name="min">
				</div>
				<div class="inner-div">
					<label for="max">Max % Used:</label> <input type="text" id="max"
						name="max">
				</div>
			</div>
			<table id="myTable" class="display" border="1"
				style="border: solid gray; border-collapse: collapse;">
				<thead style="font-size: 12px">
					<tr>
						<th style="text-align: center"><div>
								<h3>FieldGroup</h3>
							</div></th>
						<th style="text-align: center"><h3>FieldName</h3></th>
						<th style="text-align: center"><h3>
								No. of records</br>using field
							</h3></th>
						<th style="text-align: center"><h3>
								Percentage of records</br>using field
							</h3></th>
					</tr>
				</thead>
				<tbody>
					<%
					pw.flush();
					for (Map.Entry<String, List<String>> entry : fnfg.entrySet()) {
						int iii = 0;
						String key0 = entry.getKey();
						List<String> value = entry.getValue();
						int ii = 0;
						rowspan = value.size();
						int six = 2;
						for (int i = 0; i < value.size(); i++) {
							FieldGroup = entry.getKey();
					%>
					<tr>
						<td>
							<%
							pw.println(FieldGroup);
							%>
						</td>
						<td>
							<%
							if (iii >= 0) {
								FieldValue = value.get(iii);
								pw.println(FieldValue);
								iii++;
							}
							//====================================================================================================================
							%>
						</td>
						<td style="text-align: center">
							<%
							//Fetching number of records using that field.
							pw.println(fa.getNotNullRecords(objectType, serviceFactory, FieldGroup, FieldValue));
							%>
						</td>
						<td style="text-align: center">
							<%
							//Fetching percentage of records using that field.
							pw.println(fa.showAllPercentage());
							}
							%>
						</td>
					</tr>
					<%
					pw.flush();
					}
					%>
				</tbody>
			</table>
			<div class="container01">
				<div class="containerBody">
					<canvas id="myChart"></canvas>
				</div>
			</div>
			<div>
				<button onclick="goBack()">Go Back</button><br>
				<button id="downloadBtn" type="button">Download PDF</button>
			</div>
		</div>
		<%
		}
		pw.println(" ");
		} catch (Exception e) {
		//compute diff of before / after time
		out.println("Completed<br/>");
		out.println("Errors:</p>");
		out.println("<pre>");
		e.printStackTrace(pw);
		out.println("</pre>");
		Logger.getLogger(this.getClass()).error("Let's Go!", e);
		}
		%>
	</div>
	<script type="text/javascript">
		//For downloading pdf.
		function downloadAsPDF() {
			// Get the HTML table element
			var table = document.getElementById('myTable');
			window.jsPDF = window.jspdf.jsPDF;
			// Create a new jsPDF instance
			//var doc = new jsPDF();
			
			var jsPDF = require('jspdf');
			require('jspdf-autotable');

			// Convert the table to PDF
			doc.autoTable({
				html : table
			});

			// Save the PDF file
			doc.save('table.pdf');
		}

		// Attach click event listener to the button
		document.getElementById('downloadBtn').addEventListener('click',
				function(event) {
					// Prevent form submission
					event.preventDefault();

					// Call the downloadAsPDF function
					downloadAsPDF();
				});
	</script>
	
</body>
</html>
