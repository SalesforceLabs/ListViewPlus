public with sharing class  ListViewPlusDataController {
    //Main Controller used by both Charts and List Components. This controller pulls queries from ChartComponent & ListComponent custom settings. 
    //The query retrieved is parsed to get the column headers, those fields are checked for type, labels & Api names. This is the metadata part.
    
	public static Map<String, Schema.SObjectType> gDescribe {get;set;}
    public static FINAL String LISTVIEW1 = 'ListView1';
    public static FINAL String LISTVIEW2 = 'ListView2';
    public static FINAL String LISTVIEW3 = 'ListView3';
    public static FINAL String CHART1 = 'Chart1';
    public static FINAL String CHART2 = 'Chart2';
    public static FINAL String CHART3 = 'Chart3';
    public static FINAL String INITLIMIT = '110'; //Not used. Should be integer, but it is used as string everywhere//
    public static FINAL String FINALLIMIT = '2000'; //Not used. Should be integer, but it is used as string everywhere//
    public static FINAL String CHART1_QUERY = 'SELECT count(ID ) val, CALENDAR_MONTH( createdDate ) key FROM lead WHERE createdDate = LAST_90_DAYS GROUP BY CALENDAR_MONTH( createdDate )';
    public static FINAL String CHART1_LISTQUERY = 'SELECT Name,email, phone,company,status FROM Lead WHERE CALENDAR_MONTH( createdDate ) =:mon LIMIT 200';
    public static FINAL String CHART2_QUERY = 'SELECT SUM(Amount) val, CALENDAR_MONTH( createdDate ) key FROM Opportunity WHERE createdDate = LAST_90_DAYS GROUP BY CALENDAR_MONTH(createdDate)';
    public static FINAL String CHART2_LISTQUERY = 'SELECT Name,Amount, Account.Name,closeDate,stageName,ForecastCategory FROM Opportunity WHERE CALENDAR_MONTH( createdDate ) =:mon LIMIT 200';                                        
    public static FINAL String CHART3_QUERY = 'SELECT COUNT(id ) val, CALENDAR_MONTH( createdDate ) key FROM Account WHERE createdDate = LAST_90_DAYS GROUP BY CALENDAR_MONTH(createdDate)';
    public static FINAL String CHART3_LISTQUERY = 'SELECT Name,Phone,billingcity,industry,Owner.Name FROM Account WHERE CALENDAR_MONTH( createdDate ) =:mon LIMIT 200';
    public static FINAL String LIST1_QUERY = 'SELECT Name, Account.Name, Owner.Name ,email,phone FROM contact WHERE createdDate = LAST_n_DAYS:365 limit 2000';
    public static FINAL String LIST2_QUERY = 'SELECT Subject,CaseNumber, status,Account.name, Owner.name FROM case WHERE createdDate = LAST_n_DAYS:365 limit 500';
    public static FINAL String LIST1_TITLE = 'Contacts List';
    public static FINAL String LIST2_TITLE = 'Cases List';
    public static FINAL String CHART1_TITLE = 'Leads Created By Quarter';
    public static FINAL String CHART2_TITLE = 'Opportunity Amounts By Quarter';
    public static FINAL String CHART3_TITLE = 'Accounts Created By Quarter';
    public static FINAL String COMPONENT_TITLE = 'Quarterly Overview';
    
    @AuraEnabled
    public static Map<String,String> getUserInfo() {
        //This method gets the initial user information when the component loads. It provides info on user type
        Map<String,String> usrInfo = new Map<String,String>();
        usrInfo.put('username', UserInfo.getName());
        Map<String,Schema.SObjectField> m = Schema.SObjectType.Profile.fields.getMap();        	
		if (!m.get('Name').getDescribe().isAccessible()) {  //Check Query fields for CRUD and FLS
            	throw new System.NoAccessException();           		
            	
        }
        else {
        	String profileName=[SELECT Name FROM Profile where id=:UserInfo.getProfileId()].Name;    
            usrInfo.put('profile',profileName);
        }    			           
        
        return usrInfo;
        
    }
    @AuraEnabled
    public static AggregateResult[] getChartData(String chartName) {
        //Get fields, group by and other information from custom setting for charttype 
        //Construct the query and send data back. 
        //If not information exists for charttype, the use default.
        
        String query;
        ChartComponent__c ls = ChartComponent__c.getInstance();
        if (chartName == CHART1) {
            if (!Schema.sObjectType.ChartComponent__c.fields.Chart1_query__c.isAccessible()) { //Check Query fields for CRUD and FLS
                throw new System.NoAccessException();
            }
            else {
           		query = ls.Chart1_query__c;     
            }
           
        }
        if (chartName == CHART2) {
           if (!Schema.sObjectType.ChartComponent__c.fields.Chart2_query__c.isAccessible()) { //Check Query fields for CRUD and FLS
                throw new System.NoAccessException();
            }
            else {
           		query = ls.Chart2_query__c;
            }
        }
        if (chartName == CHART3) {
           if (!Schema.sObjectType.ChartComponent__c.fields.Chart3_query__c.isAccessible()) { //Check Query fields for CRUD and FLS
                throw new System.NoAccessException();
            }
            else {
           		query = ls.Chart3_query__c;
            }
        }
        AggregateResult[] Result =  Database.query(query);
        return Result;
    }
    
    @AuraEnabled
    public static List<sObject> getListViewRecords(String ListViewName, boolean limitRows) {
        //Get fields, group by and other information from custom setting for charttype 
        //Construct the query and send data back. 
        //If not information exists for charttype, the use default.
        List<sObject> sobjects = new List<sObject>();
        String query;
        ListComponent__c ls = ListComponent__c.getInstance();
        if (ListViewName == LISTVIEW1) {
           if (!Schema.sObjectType.ListComponent__c.fields.List1_query__c.isAccessible()) { //Check Query fields for CRUD and FLS
                throw new System.NoAccessException();
            }
            else {
           		query = ls.List1_query__c;
           		
          	}
        }
        if (ListViewName == LISTVIEW2) {
            if (!Schema.sObjectType.ListComponent__c.fields.List2_query__c.isAccessible()) { //Check Query fields for CRUD and FLS
                throw new System.NoAccessException();
            }
            else {
           		query = ls.List2_query__c;
           		
            }
        }
        if (ListViewName == LISTVIEW3) {
            if (!Schema.sObjectType.ListComponent__c.fields.List3_query__c.isAccessible()) { //Check Query fields for CRUD and FLS
                throw new System.NoAccessException();
            }
            else {
                query = ls.List3_query__c;
           		
            }
        }
        System.debug(Database.query(query));
        return Database.query(query);
    }
    
    @AuraEnabled
    public static Map<String, List<String>> getListViewMetadata(String resource) {
        //Get Chart or ListView Metadata from custom setting  
        //Fieldnames, column headers, types are checked and returned. Common method used by all components.
        Map<String,List<String>> fielddata = new Map<String,List<String>>();    
        Map<String,List<String>> objfields = new Map<String,List<String>>();    
        List<String> title = new List<String>();
        
        List<String> fieldnames = new List<String>();
        List<Schema.DisplayType> v = Schema.DisplayType.values();
        String qstring;
        String thisobject;
        Map<String, List<String>> metamap = new Map<String, List<String>>();
        if (resource == LISTVIEW1) {
            ListComponent__c ls = ListComponent__c.getInstance();
            title.add(ls.List1_title__c);
        	qstring = ls.List1_query__c;
            if (qstring != null) {
                objfields = parseQuery(qstring);
                fieldnames = objfields.get('fieldnames');
                thisobject = objfields.get('object')[0];
            }
        }
        if (resource == LISTVIEW2) {
            ListComponent__c ls = ListComponent__c.getInstance();
            title.add(ls.List2_title__c);
        	qstring = ls.List2_query__c;
            if (qstring != null) {
                objfields = parseQuery(qstring);
                fieldnames = objfields.get('fieldnames');
                thisobject = objfields.get('object')[0];
            }
        }
        if (resource == LISTVIEW3) {
            ListComponent__c ls = ListComponent__c.getInstance();
            title.add(ls.List3_title__c);
        	qstring = ls.List3_query__c;
            if (qstring != null) {
                objfields = parseQuery(qstring);
                fieldnames = objfields.get('fieldnames');
                thisobject = objfields.get('object')[0];
            }
        }
        if (resource == CHART1) {
            ChartComponent__c ls = ChartComponent__c.getInstance();
            title.add(ls.Chart1_title__c);
            title.add(ls.Component_title__c);
        	qstring = ls.Chart1_ListQuery__c;    
            if (qstring != null) {
                objfields = parseQuery(qstring);
                fieldnames = objfields.get('fieldnames');
                thisobject = objfields.get('object')[0];
            }
        }
        if (resource == CHART2) {
            ChartComponent__c ls = ChartComponent__c.getInstance();
            title.add(ls.Chart2_title__c);
        	qstring = ls.Chart2_ListQuery__c;      
            if (qstring != null) {
                objfields = parseQuery(qstring);
                fieldnames = objfields.get('fieldnames');
                thisobject = objfields.get('object')[0];
            }
        }
        if (resource == CHART3) {
            ChartComponent__c ls = ChartComponent__c.getInstance();
            title.add(ls.Chart3_title__c);
        	qstring = ls.Chart3_ListQuery__c;            
            if (qstring != null) {
                objfields = parseQuery(qstring);
                fieldnames = objfields.get('fieldnames');
                thisobject = objfields.get('object')[0];
            }
        }            
        if (!fieldnames.isEmpty()) {
            
            fielddata = checkFieldType(thisobject,fieldnames);
            metamap.put('fieldnames', fielddata.get('fnames'));    
        	metamap.put('labels',fielddata.get('labels'));
            metamap.put('types',fielddata.get('types'));
        	metamap.put('title',title);
        	
        }
        return metamap;
            
    }
    
    public static Map<String,List<String>> parseQuery(String qstring) {
        List<String> fieldnames = new List<String>();
        Map<String, List<String>> qmap = new Map<String,List<string>>();
        List<String> objectnames= new List<String>();
        Integer sel = qstring.indexOf('SELECT',0);
		Integer cfrom = qstring.indexOf('FROM');
        Integer obj = qstring.indexOf('WHERE');
        String thisobject = qstring.substring(cfrom,obj).remove('FROM').trim();	
        objectnames.add(thisobject);
        qmap.put('object',objectnames);
        List<String> querystring = qstring.substring(sel,cfrom).remove('SELECT').split(',');                       
        for (String f1:querystring) {
            fieldnames.add(f1.trim());
        }
        qmap.put('fieldnames', fieldnames);
        return qmap;
    }
    
    
    
    public static Map<String, List<String>> checkFieldType(String ObjectName, List<String> fieldnames) {
        Map<String,List<String>> fieldinfo = new Map<String,List<String>>();
        List<String> types = new List<String>();
        List<String> labels = new List<String>();
        List<String> fnames = new List<String>();
        
        gDescribe = Schema.getGlobalDescribe();
        Map<String, Schema.SObjectField> fieldMap = gDescribe.get(ObjectName).getDescribe().fields.getMap();
        for ( String f:fieldnames ) {       
            
            if (f.indexOf('.') > -1) {// Check for lookups 
                types.add('text'); //This is temporary. Next patch check the Object and field type of this field
                labels.add(f);
                fnames.add(f);               
            }
            else {
            Schema.DescribeFieldResult dfr = fieldMap.get(f).getDescribe();
            Schema.DisplayType fielddatatype = dfr.getType();
            labels.add(dfr.getLabel());
            fnames.add(dfr.getName());
             if (!dfr.isAccessible()) { // While we are here check for Accessiblity of the stored query fields by this user. CRUD and FLS.//
            	throw new System.NoAccessException();   // If User does not have perms//        		
        	}
            if(fielddataType == Schema.DisplayType.address) {
				types.add('address');
			}
            if(fielddataType == Schema.DisplayType.email) {
				types.add('email');
			}
            if(fielddataType == Schema.DisplayType.currency) {
				types.add('currency'); 
			}
            if(fielddataType == Schema.DisplayType.phone) {
				types.add('phone');
			}
            if(fielddataType == Schema.DisplayType.percent) {
				types.add('percent');
			}
            if(fielddataType == Schema.DisplayType.url) {
				types.add('url');
			}
            if(fielddataType == Schema.DisplayType.datetime) {
				types.add('datetime');
			}
            if(fielddataType == Schema.DisplayType.Double) {
				types.add('number');
			}
            if(fielddataType == Schema.DisplayType.Integer) {
				types.add('number');
			}
            if(fielddataType == Schema.DisplayType.date) {
				types.add('datetime');
			}
            if(fielddataType == Schema.DisplayType.string) {
				types.add('text');
			}
            if(fielddataType == Schema.DisplayType.id) {
				types.add('id');
			}
            if(fielddataType == Schema.DisplayType.reference) {
				types.add('reference');
			}
            if(fielddataType == Schema.DisplayType.picklist) {
				types.add('picklist');
			}
          }
        }
        fieldInfo.put('labels', labels);
        fieldInfo.put('fnames', fnames);
        fieldInfo.put('types', types);
        return fieldinfo;
        
    } 
    
    @AuraEnabled
    public static List<sObject> getListFromChart(String ChartName, Integer pie) {
        //Get fields, group by and other information from custom setting when a list is generated by clicking a chart pie. 
        //Construct the query and send data back. 
        //If not information exists for charttype, the use default.        
        List<sObject> sobjects = new List<sObject>();
        String query;
        ChartComponent__c ls = ChartComponent__c.getInstance();
        Integer mon = Integer.valueOf(pie);
        
         if (chartName == CHART1) {
           if (!Schema.sObjectType.ChartComponent__c.fields.Chart1_ListQuery__c.isAccessible()) { //Check Query fields for CRUD and FLS
                throw new System.NoAccessException();
            }
            else {
           		query = ls.Chart1_ListQuery__c;
                sobjects = Database.query(query);
            }
        }
        if (chartName == CHART2) {
          if (!Schema.sObjectType.ChartComponent__c.fields.Chart2_ListQuery__c.isAccessible()) { //Check Query fields for CRUD and FLS
                throw new System.NoAccessException();
            }
            else {
           		query = ls.Chart2_ListQuery__c;
                sobjects = Database.query(query);
           }
        }
        if (chartName == CHART3) {
           if (!Schema.sObjectType.ChartComponent__c.fields.Chart3_ListQuery__c.isAccessible()) { //Check Query fields for CRUD and FLS
                throw new System.NoAccessException();
            }
            else {
           		query = ls.Chart3_ListQuery__c;
        		sobjects = Database.query(query);  
            }
        
        }
        return sobjects;
    }
    /** This section is used for resetting the Charts and ListViews. It updates the custom settings with default queries*/
    @AuraEnabled
    public static void resetCharts() {
        ChartComponent__c cc;	
        String [] ChartFields = new String [] { //Fields to check CRUD and FLS
            'kbu__Chart1_query__c',
                'kbu__Chart1_ListQuery__c',
                'kbu__Chart1_title__c',
                'kbu__Chart2_query__c',
                'kbu__Chart2_ListQuery__c',
                'kbu__Chart2_title__c',
                'kbu__Chart3_query__c',
                'kbu__Chart3_ListQuery__c',
                'kbu__Chart3_title__c'
                };  
                    cc = ChartComponent__c.getOrgDefaults();
        if (cc.Id == null) {
            cc = new ChartComponent__c();                       
        }                                            
        cc.Chart1_query__c = CHART1_QUERY;              
        cc.Chart1_ListQuery__c = CHART1_LISTQUERY;
        cc.Chart1_title__c = CHART1_TITLE;                                            
        cc.Chart2_query__c = CHART2_QUERY;
        cc.Chart2_ListQuery__c = CHART2_LISTQUERY;
        cc.Chart2_title__c = CHART2_TITLE;                                            
        cc.Chart3_query__c = CHART3_QUERY;
        cc.Chart3_ListQuery__c = CHART3_LISTQUERY;
        cc.Chart3_title__c = CHART3_TITLE;
        cc.Component_title__c = COMPONENT_TITLE; 
        
        
        Map<String,Schema.SObjectField> m = Schema.SObjectType.ChartComponent__c.fields.getMap();
        if (m != null) {
        	for (String fieldToCheck : ChartFields) { //Check all fields for CRUD and FLS
            // Check if the user has access to Update field
            System.debug(fieldToCheck);
            if (!m.get(fieldToCheck).getDescribe().isUpdateable()) {
                throw new System.NoAccessException();           		
            }
        }
        try {
            upsert cc;                            
        }
        catch(DmlException e) {
            System.debug('The following exception has occurred: ' + e.getMessage());	
        }    
        }
        else {
            System.debug('No fields for custom settings');
        }
        
    }            
    
    @AuraEnabled
	public static void resetListViews() {
    ListComponent__c lc;	
    String [] ListFields = new String [] { //Fields to check CRUD and FLS
            'kbu__List1_query__c',            
            'kbu__List1_title__c',
            'kbu__List2_query__c',            
            'kbu__List2_title__c',
            'kbu__List3_query__c',
            'kbu__List3_title__c'
            };        
    lc = ListComponent__c.getOrgDefaults();
    if (lc.Id == null) {
        lc = new ListComponent__c();                       
    }                                            
    
    lc.List1_query__c =  LIST1_QUERY;                                    
    lc.List1_title__c =  LIST1_TITLE;                                            
    lc.List2_query__c =  LIST2_QUERY;                                       
    lc.List2_title__c =  LIST2_TITLE; 
    
    Map<String,Schema.SObjectField> m = Schema.SObjectType.ListComponent__c.fields.getMap();
    if (m != null) {
        	for (String fieldToCheck : ListFields) { //Check all fields for CRUD and FLS
            // Check if the user has access to Update field
            if (!m.get(fieldToCheck).getDescribe().isUpdateable()) {
                throw new System.NoAccessException();           		
            }
        }
        try {
            upsert lc;                            
        }
        catch(DmlException e) {
            System.debug('The following exception has occurred: ' + e.getMessage());	
        }    
        }
        else {
            System.debug('No fields for custom settings');
        }
}   
    
}