@isTest
public class PostInstallTestSuite {
	 static testmethod void resetListViewTestCase() {
        ListComponent__c lc;
        lc = ListComponent__c.getOrgDefaults();
        PostInstallClass.createListViewQueries();
        
    }
    static testmethod void resetChartsTestCase() {
        ChartComponent__c cc;
        cc = ChartComponent__c.getOrgDefaults();
        PostInstallClass.createChartQueries();
    }
}