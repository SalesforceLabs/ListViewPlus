({
	
    ChartSelected: function (component, event, helper) {
         var selectedchart = event.getParam("value");
         component.set("v.ChartName",selectedchart);
         component.set("v.ViewType",selectedchart);
         console.log("MyView"+component.get("v.ViewType"));
         //component.set("v.configlist", opts);
         
    },

    loadObjects1: function(component,event,helper) {
        //Get a list of objects in the Org//
        var objectnames = new Map();
        var options = [];
        var action=component.get("c.getObjects");
        //action.setParams({'objName':component.get("v.objectSelected")});
        action.setCallback(this,function(response){
            var state= response.getState();
            if(component.isValid() && state == "SUCCESS"){
                objectnames = response.getReturnValue();
                
                for (var key in objectnames) {
                    options.push({ label: key, value:objectnames[key] })
                }
                component.set("v.objectList", options);
            }
            else {
                console.log('Failed state');
                console.log(response);
            }
            });
            $A.enqueueAction(action);
    },
     
    getFieldValues: function (component, event, helper) {
        //Get all fields for the Object selected and populate the UI multi-select//
        component.set("v.isobjselected",true);
        component.set("v.objectSelected",component.find("ObjectSelect").get("v.value"));
        
        var action=component.get("c.getObjectFields");
        var fieldMap = new Map();
        var options = [];
        action.setParams({'objName':component.get("v.objectSelected")});
        action.setCallback(this,function(response){
            var state= response.getState();
            if(component.isValid() && state == "SUCCESS"){
                fieldMap = response.getReturnValue()[0];
                component.set("v.fieldMap",fieldMap);
                
                for (var key in fieldMap) {
                    options.push({ label: key, value:fieldMap[key] });
            	}
                component.set("v.listOptions", options);
                
                if (component.get("v.isChart")) {
                    var gFields = new Map();
                    var goptions = [];
                	gFields = response.getReturnValue()[1];
                	for (var key in gFields) {
                    	goptions.push({ label: key, value:gFields[key] })
                	}
                	component.set("v.glistoptions", goptions); 
                }
            }
            else {
                console.log('Failed state');
                console.log(response);
            }
            });
            $A.enqueueAction(action);
    },
    handleChange: function (component, event) {
        // Get the list of the "value" attribute on all the selected options
        // Add labels to columnheaders variable for listviews.
        var fields = new Array();
        fields = component.find("FieldNames").get("v.options");
        var selectedOptionsList = event.getParam("value");
        var labels = [];
        var x = 0;
        selectedOptionsList.forEach(function(sitem){
            fields.forEach(function(item){     
                if (sitem == item.value) {
                    labels.push(item.label);
                }
        	})
        })
        component.set("v.columnheaders",labels); 
        console.log(component.get("v.columnheaders"));    
    },
    summaryfieldchange: function (component, event) {
        var summaryfield = event.getParam("value");
        component.set("v.selectedsumaryfield",summaryfield);
        
        console.log(component.get("v.selectedsumaryfield")); 
    },
   
    aggChange: function (component, event) {
        // Get the list of the "value" attribute on all the selected options
        var selectedagg = event.getParam("value");
        component.set("v.aggvalue",selectedagg);
        console.log(component.get("v.aggvalue"));
    },
    
    Save: function(component,event,helper) {
        
        var action=null;
        var viewType = component.get("v.configselected");
        var IsChart = component.get("v.isChart");
        var IsListView = component.get("v.isListView");
        var componenttitle = "Quarterly View";
        var object = component.get("v.objectSelected");
        console.log(object);
        
        if (IsChart) {
            var aggfunc = component.get("v.aggvalue");
            var title = component.get("v.Title");
            console.log(aggfunc);
            var selectedFields = (component.get("v.selectedfieldlist")).join(); 
            console.log(selectedFields);
 			var summaryfield = aggfunc + "(" + component.get("v.selectedsumaryfield") + " )";
            console.log(summaryfield);
            action = component.get("c.SaveCharts");
            var query = "SELECT " + summaryfield + " val, " + "CALENDAR_MONTH( createdDate ) key " + " FROM " + object + " WHERE  createdDate = LAST_N_MONTHS:3 GROUP BY CALENDAR_MONTH(createdDate)";
            var chartlistquery = "SELECT " + selectedFields + " FROM " + object + " WHERE CALENDAR_MONTH( createdDate )  =:mon LIMIT 200";
            console.log(query + chartlistquery);
            //var viewtype = component.get("v.ViewType");
            var ChartName = component.get("v.ChartName");
            console.log(ChartName);
            action.setParams({"viewtype":"Chart","chartName":ChartName,"chartquery": query, "charttitle":title, "chartlistquery":chartlistquery,"componenttitle":componenttitle}); 
        }
        
        if (IsListView) {
            var selectedFields = (component.get("v.selectedfieldlist")).join(); 
            var title = component.get("v.Title");
            var query = "SELECT " + selectedFields + " FROM " + object + " WHERE  createdDate = LAST_N_MONTHS:12 LIMIT 2000";
            var ListViewName = component.get("v.ViewType");
            console.log(ListViewName);
            action = component.get("c.SaveLists");
            action.setParams({"viewtype":"ListView","ListViewName":ListViewName,"listquery": query, "listtitle":title}); 
        }
        
        action.setCallback(this,function(response){
            var state= response.getState();
            if(component.isValid() && state == "SUCCESS"){
                console.log('Configuration Updated'); //Show a popup later on
                helper.showGoodToast(component,event,helper);
            }
            else {
                helper.showBurntToast(component,event,helper);
                console.log('Failed state');
                console.log(response);
            }
            });
            $A.enqueueAction(action);
      }
})