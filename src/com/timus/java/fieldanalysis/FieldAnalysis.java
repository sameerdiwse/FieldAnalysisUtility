package com.timus.java.fieldanalysis;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;

import com.ibm.openpages.api.OpenPagesException;
import com.ibm.openpages.api.metadata.IFieldDefinition;
import com.ibm.openpages.api.metadata.ITypeDefinition;
import com.ibm.openpages.api.query.IQuery;
import com.ibm.openpages.api.query.IResultSetRow;
import com.ibm.openpages.api.query.ITabularResultSet;
import com.ibm.openpages.api.resource.IField;
import com.ibm.openpages.api.resource.IIntegerField;
import com.ibm.openpages.api.service.IMetaDataService;
import com.ibm.openpages.api.service.IQueryService;
import com.ibm.openpages.api.service.IServiceFactory;
import com.ibm.openpages.api.service.ServiceFactory;

public class FieldAnalysis {

	static IServiceFactory serviceFactory = null;
	Date before = new Date();
	String reportTitle = "FIELD ANALYSIS";
	IQueryService queryService;
	// String objectType = "";
	int count;
	int totalNumberOfRecords = 0;
	int totalNumberOfNotNullRecords = 0;
	String thistotalrecords = "";
	String FieldValue = "";
	String FieldGroup = "";
	int fgFlag = 0;

	public IServiceFactory getServiceFactory(HttpServletRequest request, HttpServletResponse response)
			throws IOException {
		try {
			serviceFactory = ServiceFactory.getServiceFactory(request);
		} catch (OpenPagesException ope) {
			Cookie cookie = new Cookie("opTargetUrl", "./query-test3.jsp");
			cookie.setMaxAge(-1);
			response.addCookie(cookie);
			response.sendRedirect("./log.on.do");
		}
		return serviceFactory;
	}

	public List<String> getObjectTypes() {
		IMetaDataService imdservice = serviceFactory.createMetaDataService();
		List<String> OBTypeList = new ArrayList<String>();
		for (ITypeDefinition idf : imdservice.getTypes()) {
			OBTypeList.add(idf.getName());
		}
		return OBTypeList;
	}

	public void testOB() {
		IFieldDefinition d = serviceFactory.createMetaDataService().getType("SOXRisk").getFieldsDefinition().get(0);
		
		HashMap<String, List<String>> fnfg = new HashMap<String, List<String>>();
			// get access to each field in a row
			for (IFieldDefinition field0 : serviceFactory.createMetaDataService().getType("SOXRisk").getFieldsDefinition()) {
				String records = field0.getName();
				if (records.contains(":")) {
					String[] fnf = records.split(":");
					String fieldgroup = fnf[0];
					String field = fnf[1];
					if (fnfg.containsKey(fieldgroup)) {
						List<String> temp = fnfg.get(fieldgroup);
						temp.add(field);
						fnfg.put(fieldgroup, temp);
					} else {
						List<String> fieldList = new ArrayList<String>();
						fieldList.add(field);
						fnfg.put(fieldgroup, fieldList);
					}
				}
			}
	}

	public HashMap<String, List<String>> getFieldsAndFG(HttpServletRequest request, String objectType) {
        //Showing fields and field groups using different approach.
		IFieldDefinition d = serviceFactory.createMetaDataService().getType("SOXRisk").getFieldsDefinition().get(10);
//		serviceFactory.createResourceService().getGRCObject(null);
		String s = d.getName();
		
		HashMap<String, List<String>> fnfg01 = new HashMap<String, List<String>>();
		// get access to each field in a row
		for (IFieldDefinition field0 : serviceFactory.createMetaDataService().getType(objectType).getFieldsDefinition()) 
		{
			String records = field0.getName();
			if (records.contains(":")) 
			{
				String[] fnf = records.split(":");
				String fieldgroup = fnf[0];
				String field = fnf[1];
				if (fnfg01.containsKey(fieldgroup)) 
				{
					List<String> temp = fnfg01.get(fieldgroup);
					temp.add(field);
					fnfg01.put(fieldgroup, temp);
				} else 
				{
					List<String> fieldList = new ArrayList<String>();
					fieldList.add(field);
					fnfg01.put(fieldgroup, fieldList);
				}
			}
		}
		
//		HashMap<String, List<String>> fnfg = new HashMap<String, List<String>>();
//		Logger.getLogger(this.getClass()).error("In getFieldsAndFG method.");
//
//		String queryStmt;
//		if (objectType == null)
//			queryStmt = "select * from [SOXBusEntity]";
//		else {
//			queryStmt = "select * from [" + objectType + "]";
//		}
//		// to execute query
//		queryService = serviceFactory.createQueryService();
//		IQuery query = queryService.buildQuery(queryStmt);
//
//		// to fetch the record
//		ITabularResultSet resultset = query.fetchRows(0);
//
//		for (IResultSetRow row : resultset) {
//			// get access to each field in a row
//			for (IField field0 : row) {
//				String records = field0.getName();
//				if (records.contains(":")) {
//					String[] fnf = records.split(":");
//					String fieldgroup = fnf[0];
//					String field = fnf[1];
//					if (fnfg.containsKey(fieldgroup)) {
//						List<String> temp = fnfg.get(fieldgroup);
//						temp.add(field);
//						fnfg.put(fieldgroup, temp);
//					} else {
//						List<String> fieldList = new ArrayList<String>();
//						fieldList.add(field);
//						fnfg.put(fieldgroup, fieldList);
//					}
//				}
//			}
//			break;
//		}
		return fnfg01;
	}

	public int totalNumberOfRecords(String objectType, IServiceFactory serviceFactory1) {
		IQueryService queryService1 = serviceFactory1.createQueryService();
		String queryStmt1 = null;
		if (objectType == null)
			queryStmt1 = "select count(*) from [SOXBusEntity]";
		else {
			queryStmt1 = "select count(*) from [" + objectType + "]";
		}
		// to execute query
		IQuery query1 = queryService1.buildQuery(queryStmt1);

		// to fetch the record
		ITabularResultSet resultset1 = query1.fetchRows(0);
		for (IResultSetRow row1 : resultset1) {
			// get access to each field in a row
			for (IField field1 : row1) {
				totalNumberOfRecords = ((IIntegerField) field1).getValue();
				// pw.println("Total number of records on ninth page : " +thistotalrecords);
			}
		}
		return totalNumberOfRecords;
	}

	public int getNotNullRecords(String objectType, IServiceFactory serviceFactory, String FieldGroup,
			String FieldValue) {
		IQueryService queryService2 = serviceFactory.createQueryService();
		String queryStmt2 = null;

		/*
		 * if (objectType == null) queryStmt2 =
		 * "select count(*) from [SOXBusEntity] where [SOXBusEntity].[Resource ID] IS NOT NULL"
		 * ; else {
		 */
		queryStmt2 = "select count(*) from [" + objectType + "]where[" + objectType + "].[" + FieldGroup + ":"
				+ FieldValue + "] IS NOT NULL";
		// to execute query
		IQuery query2 = queryService2.buildQuery(queryStmt2);

		// to fetch the record
		ITabularResultSet resultset2 = query2.fetchRows(0);
		String name = "s";

		for (IResultSetRow row2 : resultset2) {
			// get access to each field in a row
			for (IField field2 : row2) {
				totalNumberOfNotNullRecords = ((IIntegerField) field2).getValue();
			}
		}
		return totalNumberOfNotNullRecords;
	}

	public String showAllPercentage() {
		double percentage = (double) totalNumberOfNotNullRecords * 100f / totalNumberOfRecords;
		return String.format("%.2f", percentage);
	}
}
