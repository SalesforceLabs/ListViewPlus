public with sharing class  ListViewPlusTestController {
    //Main Controller used by both Charts and List Components. This controller pulls queries from ChartComponent & ListComponent custom settings. 
    //The query retrieved is parsed to get the column headers, those fields are checked for type, labels & Api names. This is the metadata part.
    
	public static Map<String, Schema.SObjectType> gDescribe {get;set;}
    public static FINAL String LISTVIEW1 = 'ListView1';
    public static FINAL String LISTVIEW2 = 'ListView2';
    public static FINAL String LISTVIEW3 = 'ListView3';
    public static FINAL String CHART1 = 'Chart1';
    public static FINAL String CHART2 = 'Chart2';
    public static FINAL String CHART3 = 'Chart3';
    public static FINAL String INITLIMIT = '10'; //Should be integer, but it is used as string everywhere//
    public static FINAL String FINALLIMIT = '2000'; //Should be integer, but it is used as string everywhere//
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
        
        String query;
        ChartComponent__c ls = ChartComponent__c.getInstance();
        if (chartName == CHART1) {
           query = ls.Chart1_query__c;
        }
        if (chartName == CHART2) {
           query = ls.Chart2_query__c;
        }
        if (chartName == CHART3) {
           query = ls.Chart3_query__c;
           
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
           query = ls.List1_query__c;
           if(limitRows) {
                query = query.replace('2000', INITLIMIT);
           }
        }
        if (ListViewName == LISTVIEW2) {
           query = ls.List2_query__c;
           if(limitRows) {
                query = query.replace('2000', INITLIMIT);
           }
        }
        if (ListViewName == LISTVIEW3) {
           query = ls.List3_query__c;
           if(limitRows) {
                query = query.replace('2000', INITLIMIT);
           }
        }
        return Database.query(query);
        //System.debug(sobjects);
        //return sobjects;
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
            System.debug('f is'+f);
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
           query = ls.Chart1_ListQuery__c;
        }
        if (chartName == CHART2) {
           query = ls.Chart2_ListQuery__c;
        }
        if (chartName == CHART3) {
           query = ls.Chart3_ListQuery__c;
        }
        sobjects = Database.query(query);
        return sobjects;
    }
    
}