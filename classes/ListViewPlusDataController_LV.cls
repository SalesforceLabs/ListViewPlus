public with sharing class  ListViewPlusDataController_LV {
	public static Map<String, Schema.SObjectType> gDescribe {get;set;}
    @AuraEnabled
    public static Map<String,String> getUserInfo() {
        //This method gets the initial user information when the component loads. It provides info on user type
        Map<String,String> usrInfo = new Map<String,String>();
        usrInfo.put('username', UserInfo.getName());
        String profileName=[SELECT Name FROM Profile where id=:UserInfo.getProfileId()].Name;
        usrInfo.put('profile',profileName);
        return usrInfo;
        
    }
    @AuraEnabled
    public static AggregateResult[] getChartData(String chartName) {
        //Get fields, group by and other information from custom setting for charttype 
        //Construct the query and send data back. 
        //If not information exists for charttype, the use default.
        String defaultstore = checkField();      // Use as a bind variable if needed. 
        String query;
        ChartComponent__c ls = ChartComponent__c.getInstance();
        if (chartName == 'Chart1') {
           query = ls.Chart1_query__c;
        }
        if (chartName == 'Chart2') {
           query = ls.Chart2_query__c;
        }
        if (chartName == 'Chart3') {
           query = ls.Chart3_query__c;
           System.debug('chart3 query' + query); 
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
        if (ListViewName == 'ListView1') {
           query = ls.List1_query__c;
           if(limitRows) {
                query = query.replace('2000', '110');
           }
        }
        if (ListViewName == 'ListView2') {
           query = ls.List2_query__c;
           if(limitRows) {
                query = query.replace('2000', '110');
           }
        }
        if (ListViewName == 'ListView3') {
           query = ls.List3_query__c;
           if(limitRows) {
                query = query.replace('2000', '110');
           }
        }
        sobjects = Database.query(query);
        
        return sobjects;
    }
    
    @AuraEnabled
    public static Map<String, List<String>> getListViewMetadata(String resource) {
        //Get Chart or ListView Metadata from custom setting  
        //Fieldnames, column headers, types are checked and returned. Common method used by all components.
        gDescribe = Schema.getGlobalDescribe();
        List<String> labels = new List<String>();
        List<String> types = new List<String>();
        List<String> title = new List<String>();
        List<String> fnames = new List<String>();
        List<String> fieldnames = new List<String>();
        List<Schema.DisplayType> v = Schema.DisplayType.values();
        String qstring;
        Map<String, List<String>> metamap = new Map<String, List<String>>();
        if (resource == 'ListView1') {
            ListComponent__c ls = ListComponent__c.getInstance();
            title.add(ls.List1_title__c);
        	qstring = ls.List1_query__c;
        }
        if (resource == 'ListView2') {
            ListComponent__c ls = ListComponent__c.getInstance();
            title.add(ls.List2_title__c);
        	qstring = ls.List2_query__c;
        }
        if (resource == 'ListView3') {
            ListComponent__c ls = ListComponent__c.getInstance();
            title.add(ls.List3_title__c);
        	qstring = ls.List3_query__c;
        }
        if (resource == 'Chart1') {
            ChartComponent__c ls = ChartComponent__c.getInstance();
            title.add(ls.Chart1_title__c);
            title.add(ls.Component_title__c);
        	qstring = ls.Chart1_ListQuery__c;           
        }
        if (resource == 'Chart2') {
            ChartComponent__c ls = ChartComponent__c.getInstance();
            title.add(ls.Chart2_title__c);
        	qstring = ls.Chart2_ListQuery__c;            
        }
        if (resource == 'Chart3') {
            ChartComponent__c ls = ChartComponent__c.getInstance();
            title.add(ls.Chart3_title__c);
        	qstring = ls.Chart3_ListQuery__c;            
        }            
        Integer sel = qstring.indexOf('SELECT',0);
		Integer cfrom = qstring.indexOf('FROM');
        Integer obj = qstring.indexOf('WHERE');
        String thisobject = qstring.substring(cfrom,obj).remove('FROM').trim();		
        List<String> querystring = qstring.substring(sel,cfrom).remove('SELECT').split(',');                       
        for (String f1:querystring) {
            fieldnames.add(f1.trim());
        }
        Map<String, Schema.SObjectField> fieldMap = gDescribe.get(thisobject).getDescribe().fields.getMap();
        for ( String f:fieldnames ) {           
            Schema.DescribeFieldResult dfr = fieldMap.get(f).getDescribe();
            Schema.DisplayType fielddatatype = dfr.getType();
            labels.add(dfr.getLabel());
            fnames.add(dfr.getName());
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
            metamap.put('fieldnames', fnames);    
        	metamap.put('labels',labels);
            metamap.put('types',types);
        	metamap.put('title',title);
        	return metamap;
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
        
         if (chartName == 'Chart1') {
           query = ls.Chart1_ListQuery__c;
        }
        if (chartName == 'Chart2') {
           query = ls.Chart2_ListQuery__c;
        }
        if (chartName == 'Chart3') {
           query = ls.Chart3_ListQuery__c;
        }
        System.debug('The chartlist query'+ query);
        sobjects = Database.query(query);
        return sobjects;
    }
    public static String checkField() {
        //An optional check, mostly not needed.
        gDescribe = Schema.getGlobalDescribe();
        Map<String, Schema.SObjectField> fieldMap = gDescribe.get('User').getDescribe().fields.getMap();
        if (fieldMap.containsKey('defaultstore__c')) {
            Id userId = UserInfo.getUserId();
            String query = 'select defaultstore__c from user where Id=:userId';
            User dstore = database.query(query);
            String storeId = dstore.defaultstore__c;
            return storeId;
        }
   		else{
        	return null;
    	}
        
    }
    
}