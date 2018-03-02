#-------------------------------------------------------------------------------
# /* 
#  * Copyright (c) 2018, salesforce.com, inc.
#  * All rights reserved.
#  * Licensed under the BSD 3-Clause license. 
#  * For full license text, see LICENSE.txt file in the repo root  or https://opensource.org/licenses/BSD-3-Clause
#  */
# /*
# *ListView Plus* is a set of Lightning components which can be added to any page in Lightning experience to provide users with quick access to relevant and frequently used data in the form of interactive and dynamic Charts and Listviews.
# Listview plus can be installed from *Salesforce Labs *into any Lightning enabled Organization. 
# */
#-------------------------------------------------------------------------------
({  
   //doInit is executed when the ListView loads.
    doInit: function(component, event, helper){      
        var calledFrom = component.get("v.ListViewName");
        var triggered = component.get("v.triggered"); /* If Called from chart */
        console.log('t'+triggered);
       	var filterCriteria = component.get("v.filterCriteria");
        var limitrows; 
        var LVname = calledFrom;
        if (triggered.match("Chart*")) { //Triggered from a chart to show a list 
            helper.getListMetadata(component,triggered);
            helper.getChartListRecords(component,triggered,filterCriteria); 
        }
       else if (triggered.match("ChartXX")) {
           console.log("wrong chart");
       } 
        else 
        {
           helper.getListMetadata(component,LVname);
           helper.getListRecords(component,LVname); //gets only 100 rows
           helper.getAllListRecords(component,LVname); //Gets all 2000 rows//
        }
   },
    getMetadata: function(component,event,helper) {
        //Build table columns names, Component titles, Listview titles from custom settings
        helper.buildMetadata(component);
        
    },
   itemsChange: function(component,event,helper) {
            
       		var listsize = component.get("v.listsize");
        	var records = [];
        	var records1 = []
            var columns = [];
            records=component.get("v.records");
       		
            component.set("v.records",records);
            var currentrecords=component.get("v.records").slice(0,listsize);    
            component.set("v.currentrecords",currentrecords);
       		console.log(component.get("v.currentrecords"));
      	    component.set("v.leftIndex",1);
       		component.set("v.recordCountDisplay",(component.get("v.records")).length); 
            if(records.length> listsize){
                    component.set("v.rightIndex",listsize); 
                	component.set("v.rightDisabled",false);
            }
            else{
                component.set("v.rightIndex",currentrecords.length);
                component.set("v.rightDisabled",true);
                component.set("v.leftDisabled",true);
            } 		
    },
    
    AllRecChange: function(component, event, helper) {
        	var ll = [];
        	ll = component.get("v.currentrecords");
        	ll.forEach(function(item){
            	(component.get("v.records")).push(item);
                
        	}); 
    },
    minimizeList : function(component, event, helper) {
        var currentview = component.get("v.hidelist");
        if (currentview) {
            component.set("v.hidelist",false);
            component.set("v.defaultview",true);
        }
        else{
            component.set("v.hidelist",true);
        	component.set("v.defaultview",false);
        }        
	},
    
    Search:function(component,event,helper){
        //This method searches data that is already in the UI/browser. Using regex.
        helper.refresh(component,event,helper);
        var listsize = component.get("v.listsize");
		var searchkey= component.get("v.searchKey");
        var templist,searchrecs,matches_array = [];
        searchrecs = component.get("v.records");                
        var pattern = new RegExp(searchkey,"i");
        function getItems(item, index, array) {
            var labels = Object.keys(item);            	
            	for (var x in labels) {
                    if (item[labels[x]] != undefined) {
                        var ss = (item[labels[x]]).toString();                     
            			if ((ss).match(pattern)){
                			matches_array.push(item);
           			}
            	}
                else {
                console.log("Search failed for some reason");
            	}    
            }
        }
        searchrecs.forEach(getItems);     
        if (matches_array.length == 0) {
            helper.showSearchToast(component); //Show user nothing came from their search///
        }
        else {
            component.set("v.searchrecords",matches_array);
        }
        
        var currentrecords=component.get("v.searchrecords").slice(0,listsize);
        component.set("v.currentrecords",currentrecords);
        component.set("v.records",component.get("v.searchrecords"));
        component.set("v.recordCountDisplay",(component.get("v.searchrecords")).length);         
        if (component.get("v.records").length < listsize) {
            component.set("v.rightDisabled",true);
            component.set("v.leftDisabled",true);
            component.set("v.rightIndex",currentrecords.length);
        }
        else {
            
            component.set("v.rightDisabled",false);
        }
        
        component.set("v.resetDisable",false);
    },
    pressRight : function(component, event, helper) {
        	//The flow: store right clicks and count. if > 3 show message
        //recordCountDisplay is length of the records array at this time.
        //Increase by listsize each right click and decrease by listsize each left click upto total records right or 0 for left.
            //helper.showToast(component);    
        	var listsize = component.get("v.listsize");
            //component.get("v.records").length;
        	var right = parseInt(component.get("v.rightIndex"),10);
        	var left =  parseInt(component.get("v.leftIndex"),10);
        	var total = component.get("v.recordCountDisplay");
        	var diff = total - right;
        	left = right;
        	right = right + listsize;
        	var nextrecords = [];        
       		
        	nextrecords = (component.get("v.records")).slice(left,right);
        	component.set("v.currentrecords",nextrecords);
        	component.set("v.rightIndex",right);
            component.set("v.leftIndex",left);
        	if (diff <= listsize) {
                component.set("v.rightIndex",total);
            	component.set("v.rightDisabled",true); 
        	}
        	else {
        		component.set("v.currentrecords",nextrecords);
        		component.set("v.rightIndex",right);
            	component.set("v.leftIndex",left);
            	component.set("v.leftDisabled",false);
        	}
        	
    },
    pressLeft: function(component, event, helper){
        var listsize = component.get("v.listsize");
        var right = parseInt(component.get("v.rightIndex"),10);
        var left =  parseInt(component.get("v.leftIndex"),10);
           
        right = left;
        left = left - listsize;
        var nextrecords = [];
           
        if (left != 0) {
            nextrecords = (component.get("v.records")).slice(left,right);
            component.set("v.currentrecords",nextrecords);
        	component.set("v.rightIndex",right);
            component.set("v.leftIndex",left);          
            component.set("v.rightDisabled",false);
        }
        else {
            nextrecords = (component.get("v.records")).slice(left,right);
            component.set("v.currentrecords",nextrecords);
            component.set("v.rightIndex",right);
            component.set("v.leftIndex",1);
            component.set("v.leftDisabled",true);
        }
    },
    // Client-side controller called by the onsort event handler
    updateColumnSorting: function (component, event, helper) {
        var fieldName = event.getParam('fieldName');                
        var sortDirection = event.getParam('sortDirection');
        // assign the latest attribute with the sorted column fieldName and sorted direction
        component.set("v.sortedBy", fieldName);
        component.set("v.sortedDirection", sortDirection);
        helper.sortData(component, fieldName, sortDirection);  
    },
    refresh : function(component, event, helper) {
        helper.refresh(component,event,helper);
    },
    doConfigure: function(component,event,helper) {
        var currentview = component.get("v.showsetup");
        if (currentview) {
            component.set("v.showsetup",false);
            component.set("v.defaultview",true);
        }
        else{
            component.set("v.showsetup",true);
        component.set("v.defaultview",false);
        }        
    },
    helpText: function(component,event,helper){
        
        component.find('notifLib').showToast({
            "title": "Using ListViewPlus Lists",
            "message": "This list view shows data for an object based on configuration. The search box can search on an column and search is with the localy available records. The view can be refreshed by clicking the refresh button.",
            "mode":"dismissible"
        });
        
    }
      
})
