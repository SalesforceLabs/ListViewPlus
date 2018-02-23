@isTest
public class KaribuSetupControllerTestSuite {
	static testMethod void runUserInfoTestCases() {
         
    
        //KaribuDataController kdc = new KaribuDataController();
        KaribuSetupController.getObjects();
        KaribuSetupController.getObjectFields('Account');
        String Chart1query = 'select Id, name from Account';
        String Chart2query = 'select Id, name from Account';
        String Chart3query = 'select Id, name from Account';
        String list1query = 'select Id, name from Account';
        String list2query = 'select Id, name from Account';
        String list3query = 'select Id, name from Account';
        KaribuSetupController.SaveCharts('Chart', 'Chart1',Chart1query, 'testchart' ,chart1query, 'testcomponent'); 
        KaribuSetupController.SaveCharts('Chart', 'Chart2',Chart2query, 'testchart2' ,chart1query, 'testcomponent2'); 
        KaribuSetupController.SaveCharts('Chart', 'Chart3',Chart3query, 'testchart3' ,chart1query, 'testcomponent3'); 
        KaribuSetupController.SaveLists('ListView', 'ListView1',list1query, 'testlist1');
        KaribuSetupController.SaveLists('ListView', 'ListView2',list2query, 'testlist2');
        KaribuSetupController.SaveLists('ListView', 'ListView3',list3query, 'testlist3');
    
    }
    
}