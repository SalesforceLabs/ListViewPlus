({
    getListRecords: function(component,listname) {
        var spinner = component.find("mySpinner");
        var records = [];
        var dataload = component.get("v.dataloaded");
        var action= component.get("c.getListViewRecords");        
        action.setParams({"ListViewName":listname,"limitRows":true});	
        action.setCallback(this,function(response){
        var state= response.getState();
        if(component.isValid() && state == "SUCCESS"){
                records=response.getReturnValue();
            	component.set("v.records",this.processRecords(component,event,records));
            	component.set("v.dbrecords",this.processRecords(component,event,records));
                component.set("v.recordschanged",true);
            	component.set("v.dataloaded",false);
                if (!component.get("v.dataloaded")) {
                    $A.util.toggleClass(spinner, "slds-hide");  
                }             
            else{
                this.showErrorToast(component);
                component.set("v.defaultview",false);
                component.set("v.showsetup",true);
                $A.util.toggleClass(spinner, "slds-hide"); 
                console.log('Failed state');
                console.log(response);
            }
        }          
        });
        $A.enqueueAction(action);    
    },
    getAllListRecords: function(component,listname) {
        var spinner = component.find("mySpinner");
        var records = [];
        var action= component.get("c.getListViewRecords");        
        action.setParams({"ListViewName":listname,"limitRows":false});	
        action.setBackground();
        action.setCallback(this,function(response){
        var state= response.getState();
        if(component.isValid() && state == "SUCCESS"){
                records=response.getReturnValue();
            	component.set("v.records",this.processRecords(component,event,records));
            	component.set("v.dbrecords",this.processRecords(component,event,records));
                component.set("v.Allrecordschanged",true);                
        }
            else {
                this.showErrorToast(component);
                $A.util.toggleClass(spinner, "slds-hide"); 
                console.log('Failed state');
                console.log(response);
            }
        });
        $A.enqueueAction(action);    
    },
    getListMetadata: function(component,listviewname) {
        var spinner = component.find("mySpinner");
        var metaMap = new Map();
    	var metaaction = component.get("c.getListViewMetadata");
        metaaction.setParams({"resource":listviewname});
        metaaction.setCallback(this,function(response){
        var state= response.getState();
        if(component.isValid() && state == "SUCCESS"){
            metaMap =  response.getReturnValue();      
            console.log(metaMap);
            component.set("v.fieldLabels",metaMap['labels']);
            component.set("v.fieldTypes",metaMap['types'])
            component.set("v.fieldNames",metaMap['fieldnames']);
            component.set("v.metadataready",true);    
            if (metaMap['title'] !== undefined ) {
            	component.set("v.listviewTitle",metaMap.title[0]);    
            }
            else {
                console.log("No metadata retrieved");
            } 
        }
        else {                
            	this.showErrorToast();
                $A.util.toggleClass(spinner, "slds-hide"); 
            	console.log('Failed state');
                console.log(response);
        } 
        });
        $A.enqueueAction(metaaction);
   },
    getChartListRecords: function(component,viewname,filter) {
        var spinner = component.find("mySpinner");
        var records = [];
        var action= component.get("c.getListFromChart");
        action.setParams({"ChartName":viewname,"pie":filter});
        action.setCallback(this,function(response){
        var state= response.getState();
        if(component.isValid() && state == "SUCCESS"){
                records=response.getReturnValue();
				component.set("v.records",this.processRecords(component,event,records));
            	component.set("v.dbrecords",this.processRecords(component,event,records));
                component.set("v.recordschanged",true);
            	component.set("v.dataloaded",false);
                if (!component.get("v.dataloaded")) {
                    $A.util.toggleClass(spinner, "slds-hide");  
                }
             
       		else{
                this.showErrorToast();
                $A.util.toggleClass(spinner, "slds-hide"); 
                console.log('Failed state');
                console.log(response);
            }
        }
    	});
        $A.enqueueAction(action); 
    },                   
    buildMetadata: function(component) { 
        
            var tablecolumns = []
            var fieldnames = component.get("v.fieldNames");
            var fieldlabels = component.get("v.fieldLabels");
            var fieldtypes = component.get("v.fieldTypes");
            
            for (var item in fieldnames) {
                var obj = new Object();
                obj.fieldName = fieldnames[item];
                obj.label = fieldlabels[item];
                obj.type = fieldtypes[item];
                obj.sortable = 'true';
                tablecolumns.push(obj);
            }
            component.set("v.mycolumns",tablecolumns);
            
     },
    processRecords: function(component,event,records) {
         //var records = component.get("v.records");
         var meta = component.get("v.metadataready");
         var cols = component.get("v.fieldNames");
         var finaldata = [];
         for (var x in records) {
             var rowobj = {};
                for (var col in cols) {
                    if (cols[col].indexOf('.') > -1) {
                    	rowobj[cols[col]] = this.resolveObject(component,records[x],cols[col]);      
                    }
                    else {
                        rowobj[cols[col]] =  records[x][cols[col]];
                    }   
                }
             finaldata.push(rowobj);
         }
       
        return finaldata;
    },
    resolveObject : function(component,obj, colname) {
    	var a = colname.split('.')[0];
        var b = colname.split('.')[1];
        var objdata = obj[a][b];
    return objdata;
		
	},
     showToast : function(component, event, helper) {
     component.find('notifLib').showToast({
            "title": "Suggestion!",
            "message": "Do a search for easier access to records.",
            "mode":"dismissible"
        });
	},
   
   showErrorToast : function(component) {
     component.find('notifLib').showToast({
            "title": "Error! List failed to load.",
            "message": "Unable to retrieve data from server. Please contact your system administrator.",
            "mode":"dismissible"
        });
	},
    showSearchToast : function(component) {
     component.find('notifLib').showToast({
            "title": "No Results! No data returned from search.",
            "message": "Change your search term or use global search.",
            "mode":"dismissible"
        });
	},
   
  
    refresh : function(component, event, helper) {
        var listsize = component.get("v.listsize");
        component.set("v.records",component.get("v.dbrecords"));
        
        var currentrecords=component.get("v.records").slice(0,listsize);
        if (component.get("v.records").length < listsize) {
            component.set("v.currentrecords",currentrecords);
            component.set("v.rightDisabled",true);
            component.set("v.leftDisabled",true);
            component.set("v.rightIndex",currentrecords.length);
            component.set("v.recordCountDisplay",(component.get("v.records")).length); 
        }
        else {
            
            component.set("v.rightDisabled",false);
        
        component.set("v.currentrecords",currentrecords);
        component.set("v.leftDisabled",true);
        component.set("v.rightDisabled",false);
        component.set("v.recordCountDisplay",(component.get("v.records")).length); 
        component.set("v.rightIndex",component.get("v.currentrecords").length);
        component.set("v.leftIndex",1);
        }
    },
   
    sortData: function (component, fieldName, sortDirection) {
        //Used for column header sorting
        component.set("v.Allrecordschanged",false);
        var data = component.get("v.records");
        var reverse = sortDirection !== 'desc';
        //sorts the rows based on the column header that's clicked
        data.sort(this.sortBy(fieldName, reverse));
        component.set("v.records", data);
        component.set("v.Allrecordschanged",true);
    },
    sortBy: function (field, reverse, primer) {
        var key = primer ?
            function(x) {return primer(x[field])} :
            function(x) {return x[field]};
        //checks if the two rows should switch places
        reverse = !reverse ? 1 : -1;
        return function (a, b) {
            return a = key(a), b = key(b), reverse * ((a > b) - (b > a));
        }
    }
})