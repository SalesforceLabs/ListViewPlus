public with sharing class KaribuSetupController {

    public static String selectedObject {get;set;}
    public static String selectedFields {get;set;}
    public static String selectedGroupBy {get;set;}
    public static String selectedFilterBy {get;set;}
    public static String chartName {get;set;}
    public static Final String ADM_CONFIG = 'Admin Config';
    public static Final String DEFAULT_CONFIG = 'Default Config';
    public static Map<String, Schema.SObjectType> gDescribe {get;set;}
    
    public static ObjectMetadata oMetaData { get; set; }
    
    public class ObjectMetadata {
        public Map<String,String> groupByFieldsMap { get; set; }
    	public Map<String,String> filterByFieldsMap { get; set; }
    	public Map<String,String> fieldsMap { get; set; } //Values of fields of object selected //
    
        public ObjectMetadata ( Map<String,String> gFieldsMap, Map<String,String> fFieldsMap, Map<String,String> fMap) {
            this.fieldsMap = fMap;
            this.groupByFieldsMap = gFieldsMap;
            this.filterByFieldsMap = fFieldsMap;
        }
    }
    
    public KaribuSetupController() {
        
    } 
   @AuraEnabled  
   public static Map<String,String> getObjects() {
    List<Schema.SObjectType> gd = Schema.getGlobalDescribe().Values();     
    Map<String,String> objectNames = new Map<String,String>();
    
    for(Schema.SObjectType f : gd)
    {
       objectNames.put(f.getDescribe().getName(),f.getDescribe().getLabel());
    }
    System.debug(objectNames);   
    return objectNames;
       
   }
    
    @AuraEnabled
    public static List<Map<String, String>> getObjectFields(String objName) {
        gDescribe = Schema.getGlobalDescribe();
        Map<String,String> gFieldsMap = new Map<String,String>();
        Map<String,String> fFieldsMap = new Map<String,String>();
    	Map<String,String> fMap = new Map<String,String>(); //Values of fields of object selected //
        List<Map<String,String>> rlist = new List<Map<String,String>>();
        
        Map<String, Schema.SObjectField> fieldMap = gDescribe.get(objName).getDescribe().fields.getMap();
        for (String f:fieldMap.keySet()) {
            Schema.DescribeFieldResult dfr = fieldMap.get(f).getDescribe();
            fMap.put(dfr.getLabel(),f);     
            if (dfr.isGroupable()) {
                gFieldsMap.put(dfr.getLabel(),f);
            }    
        }
        //Add dfr.isFilterable() if condition later for filterable fields//
        rlist.add(fMap);
        rlist.add(gFieldsMap);
        return rlist;
    }
 
    @AuraEnabled
    public static void SaveCharts(String viewtype, String chartName,String chartquery, String charttitle,String chartlistquery, String componenttitle) {
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
       
        if (viewtype == 'Chart') {
            	cc = ChartComponent__c.getOrgDefaults();
            if (cc.Id == null) {
            	cc = new ChartComponent__c();                       
            }                                            
            if (chartName == 'Chart1') { 
				
                cc.Chart1_query__c = chartquery;               
                cc.Chart1_ListQuery__c = chartlistquery;                  
                cc.Chart1_title__c = charttitle;                                            
            }					
            if (chartName == 'Chart2') {        
                cc.Chart2_query__c = chartquery;
                cc.Chart2_ListQuery__c = chartlistquery;                                        
                cc.Chart2_title__c = charttitle;                                            
            }
            if (chartName == 'Chart3') {
            	cc.Chart3_query__c = chartquery;
                cc.Chart3_ListQuery__c = chartlistquery;
                cc.Chart3_title__c = charttitle;
            }
            if (componenttitle != null) {
            	cc.Component_title__c = componenttitle; 
            }
            Map<String,Schema.SObjectField> m = Schema.SObjectType.ChartComponent__c.fields.getMap();
        	for (String fieldToCheck : ChartFields) { //Check all fields for CRUD and FLS
        	// Check if the user has access to Update field
        	System.debug(m);
                
			if (!m.get(fieldToCheck).getDescribe().isUpdateable()) {
            	throw new System.NoAccessException();           		
        		}
    		}	            
            upsert cc;                            
        }                                                                       
    }
     
    @AuraEnabled
    public static void SaveLists(String viewtype, String ListViewName,String listquery, String listtitle) {
    	ListComponent__c lc;	
        String [] ListFields = new String [] { //Fields to check CRUD and FLS
            'kbu__List1_query__c',            
            'kbu__List1_title__c',
            'kbu__List2_query__c',            
            'kbu__List2_title__c',
            'kbu__List3_query__c',
            'kbu__List3_title__c'
            };  
        if (viewtype == 'ListView') {
            	lc = ListComponent__c.getOrgDefaults();
            if (lc.Id == null) {
            	lc = new ListComponent__c();                       
            }                                            
            if (ListViewName == 'ListView1') {                                	
                lc.List1_query__c = Listquery;                                    
                lc.List1_title__c = Listtitle;                                            
            }					
            if (ListViewName == 'ListView2') {                                                	
                lc.List2_query__c = Listquery;                                        
                lc.List2_title__c = Listtitle;                                            
            }
            if (ListViewName == 'ListView3') {
            	lc.List3_query__c = Listquery;
                lc.List3_title__c = Listtitle;
            }
            Map<String,Schema.SObjectField> m = Schema.SObjectType.ListComponent__c.fields.getMap();
        	for (String fieldToCheck : ListFields) { //Check all fields for CRUD and FLS
        	// Check if the user has access to view field
			if (!m.get(fieldToCheck).getDescribe().isUpdateable()) {
            	throw new System.NoAccessException();           		
        		}
    		}
            upsert lc;
        }   
    }
}