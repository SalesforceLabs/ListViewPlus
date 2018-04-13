@isTest
public class ListViewPlusDataControllerTestSuite {
   
    static testMethod void runUserInfoTestCases() {
        Map<String, String> testmap= new Map<String, String>();
        testmap = ListViewPlusDataController.getUserInfo();
        
    
    }
    
    static testmethod void runGetChartTestCases() {
    
    ChartComponent__c c1 = new ChartComponent__c();     
        c1.Chart3_query__c = 'SELECT COUNT(id ) val, CALENDAR_MONTH( createdDate ) key FROM Account WHERE createdDate = LAST_N_YEARS:1 GROUP BY CALENDAR_MONTH(createdDate)';
        insert c1;    
    
        AggregateResult[] Result = ListViewPlusDataController.getChartData('Chart3');
        System.debug(Result);
        
    
    }
    static testmethod void runGetListViewTestCases() {
         
    ListComponent__c c1 = new ListComponent__c();     
        c1.List1_query__c = 'SELECT name,accountid,id,stagename,amount FROM Opportunity WHERE createdDate = LAST_N_YEARS:1 LIMIT 2000';
        insert c1;    
    
        List<sObject> sobjects = new List<sObject>();
        sobjects = ListViewPlusDataController.getListViewRecords('ListView1',true);
        
    
    }
    
    static testmethod void ListViewMetaDataTestCases() {
    	
        ListComponent__c l1 = new ListComponent__c();     
        l1.List1_query__c = 'SELECT name,accountid,id,stagename,amount FROM Opportunity WHERE createdDate = LAST_N_YEARS:1 LIMIT 2000';
        l1.List1_title__c = 'test';
        upsert l1;  
        ListViewPlusDataController.getListViewMetadata('ListView1');
        
        l1.List2_title__c = 'test2';
        l1.List2_query__c = 'SELECT name,id FROM Account WHERE createdDate = LAST_N_YEARS:1 LIMIT 2000';
        upsert l1;  
        ListViewPlusDataController.getListViewMetadata('ListView2');
        
        l1.List3_title__c = 'test3';
        l1.List3_query__c = 'SELECT name,accountid,id,stagename,amount FROM Opportunity WHERE createdDate = LAST_N_YEARS:1 LIMIT 2000';
        upsert l1;  
		ListViewPlusDataController.getListViewMetadata('ListView3');                
        
        ChartComponent__c c1 = new ChartComponent__c();     
        c1.Chart1_listquery__c = 'SELECT name,accountid,id,stagename,amount FROM Opportunity WHERE createdDate = LAST_N_YEARS:1 LIMIT 200';
        c1.Chart1_title__c = 'charttest1';
        c1.Chart1_query__c = 'SELECT name,accountid,id,stagename,amount FROM Opportunity';
        upsert c1; 
		ListViewPlusDataController.getListViewMetadata('Chart1');
        c1.Chart2_query__c = 'SELECT name,accountid,id,stagename,amount FROM Opportunity'; 
        c1.Chart2_title__c = 'charttest1';
        c1.Chart2_listquery__c = 'SELECT name,accountid,id,stagename,amount FROM Opportunity WHERE createdDate = LAST_N_YEARS:1 LIMIT 200';
        upsert c1; 
        ListViewPlusDataController.getListViewMetadata('Chart2');
        ListViewPlusDataController.getListViewMetadata('Chart3');
        c1.Chart3_query__c = 'SELECT name,accountid,id,stagename,amount FROM Opportunity'; 
        c1.Chart3_title__c = 'charttest3';
        c1.Chart3_listquery__c = 'SELECT name,accountid,id,stagename,amount FROM Opportunity WHERE createdDate = LAST_N_YEARS:1 LIMIT 200';
        upsert c1; 

    }
    	static testmethod void ChartListTestCases() {
        ChartComponent__c c1 = new ChartComponent__c();     
        c1.Chart1_Listquery__c = 'SELECT name,accountid,id,stagename,amount FROM Opportunity WHERE createdDate = LAST_N_YEARS:1 LIMIT 200';
        upsert c1;  
        c1.Chart2_Listquery__c = 'SELECT name,accountid,id,stagename,amount FROM Opportunity WHERE createdDate = LAST_N_YEARS:1 LIMIT 200';
        upsert c1;  
        c1.Chart3_Listquery__c = 'SELECT name,accountid,id,stagename,amount FROM Opportunity WHERE createdDate = LAST_N_YEARS:1 LIMIT 200';
        upsert c1;  
        ListViewPlusDataController.getListFromChart('Chart1',2);
        ListViewPlusDataController.getListFromChart('Chart2',3);    
        ListViewPlusDataController.getListFromChart('Chart3',3);
        }
    
    
    
    static testmethod void checkFieldTestCases() {
    	List<String> fnames = new List<String>();
        fnames.add('Name');
        fnames.add('createddate');
        fnames.add('Id');
        Map<String,List<String>> fieldinfo = new Map<String,List<String>>();
 		fieldinfo = ListViewPlusDataController.checkFieldType('Account', fnames); 
        fnames.add('Amount');
        fnames.add('closedate');
        fnames.add('Id');
        fnames.add('AccountId');
        fieldinfo = ListViewPlusDataController.checkFieldType('Opportunity', fnames); 
        
	}
    
    
    static testmethod void parseQueryTestCases() {
        String qstring = 'SELECT name,accountid,id,stagename,amount FROM Opportunity WHERE createdDate = LAST_N_YEARS:1 LIMIT 2000';
        ListViewPlusDataController.parseQuery(qstring);
    }
    static testmethod void parseQuery2TestCases() {
        String qstring = 'SELECT name,id,createdDate FROM Account WHERE createdDate = LAST_N_YEARS:1 LIMIT 2000';
        ListViewPlusDataController.parseQuery(qstring);
    }
    
    static testmethod void resetListViewTestCase() {
         ListComponent__c lc;
        lc = ListComponent__c.getOrgDefaults();
        String qstring = 'SELECT name,id,createdDate FROM Account WHERE createdDate = LAST_N_YEARS:1 LIMIT 2000';
        ListViewPlusDataController.resetListViews();
    }
    static testmethod void resetChartsTestCase() {
        ChartComponent__c cc;
        cc = ChartComponent__c.getOrgDefaults();
        String qstring = 'SELECT name,id,createdDate FROM Account WHERE createdDate = LAST_N_YEARS:1 LIMIT 2000';
        ListViewPlusDataController.resetCharts();
    }
    
}