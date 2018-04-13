global class PostInstallClass implements InstallHandler {
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
    global void onInstall(InstallContext context) {
        
        if(context.previousVersion() == null) {	
            createChartQueries();
            createListViewQueries();
        }
        else {
            
            if(context.previousVersion().compareTo(new Version(1,2,0)) == 0) {
                createChartQueries();
            	createListViewQueries();
            }
            if(context.isUpgrade()) {
                //Do nothing
            }
            if(context.isPush()) {
                //do nothing
            }
        }
    }
    public static void createChartQueries() {
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
    public static void createListViewQueries() {
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