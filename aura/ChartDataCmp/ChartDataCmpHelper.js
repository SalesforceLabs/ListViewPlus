({
    buildDefaultChart : function(component,helper,event,chartName) {
        var ctx = component.find(chartName).getElement();
      //helper.buildDefaultChart(component,helper,event,ctx1);
       var chart = new Chart(ctx,{type: 'doughnut',
            	data: this.getCasesData(component),
           		options: {
                			animation : false,
               			 	responsive: true,
                			maintainAspectRatio: true,
                			legend:{
                					display:true,
                                position: 'bottom'
                					}}});
        if (chartName == 'Chart1') {
        	component.set("v.Chart1",chart);      
        }
        if (chartName == 'Chart2') {
        	component.set("v.Chart2",chart);      
        }
		if (chartName == 'Chart3') {
        	component.set("v.Chart3",chart);      
        }                          
        
    },
    buildRealChart : function(component,helper,event,chartName) { //Not used
        var ctx = component.find(chartName).getElement();
      //helper.buildDefaultChart(component,helper,event,ctx1);
       var chart = new Chart(ctx,{type: 'doughnut',
            	data: this.buildChartData(component,component.get("v.records")),
           		options: {
                			animation : false,
               			 	responsive: true,
                			maintainAspectRatio: true,
                			legend:{
                					display:true,
                                position: 'bottom'
                					}}});
      component.set("v.chartObject",chart);  //Not used
    },
    
    convertMonthToName: function(component, month){
        var months=['January','February','March','April','May','June','July','August','September','October','November','Decemeber'];
        return months[month-1];
    },
    
    convertNameToMonthNumber: function(component, monthNumber){
        
     var monthsObject = { 
      "January" : 1, 
      "February" : 2,
      "March" : 3,
      "April" : 4,
      "May" : 5,
      "June" : 6,
      "July" : 7,
      "August" : 8,
      "September" : 9,
      "October" : 10,
      "November" : 11,
      "December" : 12};
        
      return monthsObject[monthNumber];
    },
   
	getOppData : function(component) {
        
        var accData= new Map();
    	accData.set('January',23433.90);
    	accData.set('February',74647.90);
    	accData.set('March',74647.90);
        return accData;
	},
    
    getActivitiesData : function(component) {
        var actData= new Map();
    	actData.set('January',84);
    	actData.set('February',67);
    	actData.set('March',20);
        return actData;
	},
    
    getCasesData : function(component) {
        var actData1= new Map();
    	actData1.set('January',30);
        var casesLabels= []
        var casesValues=[];
        for(var key of actData1.keys()){
            casesLabels.push(key);
            casesValues.push(actData1.get(key));
        }
        var casData={
        labels:casesLabels,
        datasets:[ {
        				data:casesValues,// for map.key(Q1)//
        				backgroundColor:["#2ecc71",
        								 "#3498db",
        								 "#95a5a6"]
        
        }]
        };
		return casData;
    },
    
    getListChart: function(component,event,helper,ChartName,label) {
        console.log(ChartName);
        $A.createComponent(
            "c:ListDataCmp",
            {
                "filterCriteria": this.convertNameToMonthNumber(component,label),
                "triggered":ChartName,
                "isChartList":"true"
             },
            
            function(child, status, errorMessage){
                //Add the new button to the body array
                if (status === "SUCCESS") {
                    
                    component.set("v.body", child);
                }
                else if (status === "INCOMPLETE") {
                    console.log("No response from server or client is offline.")
                    // Show offline error
                }
                else if (status === "ERROR") {
                    console.log("Error: " + errorMessage);
                    // Show error message
                }
            }
        );
    },
    
    getChartData: function(component,event,helper,chartName) {
        var chart = chartName;
        var spinner = component.find("mySpinner");
        var actAction= component.get("c.getChartData");
        actAction.setParams({"chartName":chart});
      	//actAction.setStorable();
      	actAction.setCallback(this,function(response){
          	
            var state= response.getState();
            if(component.isValid() && state == "SUCCESS"){
                var records=response.getReturnValue();   
                component.set("v.records",records);                               
                if (chartName == "Chart1") {
                    if (Object.keys(records).length == 0) {
    				 this.showDataInfoToast(component,"Right side chart");             	
                	}
                    else {
                	component.set("v.Chart1Ready",true); 
                    }
                } 
                if (chartName == "Chart2") {
                    if (Object.keys(records).length == 0) {
    				 this.showDataInfoToast(component,"Middle Chart");             	
                	}
                    else {
                    	component.set("v.Chart2Ready",true);
                    }    
                    }
                if (chartName == "Chart3") {
                    if (Object.keys(records).length == 0) {
    				 this.showDataInfoToast(component,"Left side chart");             	
                	}
                    else {
                    component.set("v.Chart3Ready",true); 
                    }
                }
                component.set("v.dataloaded",false);
                if (!component.get("v.dataloaded")) {
                    //$A.util.toggleClass(spinner, "slds-hide");  
                }
            
            else {
                this.showErrorToast(component,event,helper);
                //$A.util.toggleClass(spinner, "slds-hide"); 
                console.log('Failed state');
            }
       	 }
       	});
        $A.enqueueAction(actAction);
    },
    
    getChartMetaData:function(component,event,helper,chartName) {
        
        var metaMap = new Map();
        var metaaction = component.get("c.getListViewMetadata");
        metaaction.setParams({"resource":chartName});
        //metaaction.setStorable();
        metaaction.setCallback(this,function(response){
            var state= response.getState();
            if(component.isValid() && state == "SUCCESS"){
                var metaMap=response.getReturnValue();
                
                 if (Object.keys(metaMap).length == 0) {
    				 this.showErrorToast(component);             	
	                 console.log("no config");  
                     
                }
                else {
                if (chartName == "Chart1") {
                    
                   component.set("v.chart1Title",metaMap.title[0]);
                   component.set("v.componentTitle",metaMap.title[1]);
                }
                if (chartName == "Chart2") {
                   component.set("v.chart2Title",metaMap.title[0]);  
                }
                if (chartName == "Chart3") {
                   component.set("v.chart3Title",metaMap.title[0]);
                }     
                }
            }
            else {
                console.log('Failed state');
            } 
        });
        $A.enqueueAction(metaaction);
    },

    buildChartData : function(component,dbData){
      var labels= []
      var values=[];
      var sum=0;
      
      for(var key in dbData){
          if (typeof(dbData[key].key) == "number") {
            labels.push(this.convertMonthToName(component,dbData[key].key));
          }
          else if (typeof(dbData[key].key) == "string") {
            labels.push(dbData[key].key);
          }
              else {
                  console.log("undefined"+dbData[key].key);
              }
            values.push(dbData[key].val);
          	sum+=dbData[key].val;
      }
      var chartData={
        labels:labels,
        datasets:[{
        				data:values,
        				backgroundColor:["#2ecc71","#3498db","#95a5a6"]
        
        		}]
        }; 
        return chartData;
    },
    
    getRandomNumber : function(min, max) {
		return Math.random() * (max - min) + min;
    },
    showErrorToast : function(component) {
     component.find('notifLib').showToast({
            "title": "Error! One or more of charts failed to load",
            "message": "Unable to retrieve data from server. If this is a 1st time usage it's possible configuration is not complete. Please contact your system administrator.",
            "mode":"dismissible"
        });
	},
    showDataInfoToast : function(component, chartname) {
     component.find('notifLib').showToast({
            "title": chartname + " failed to load",
            "message": "It's possible the chart did not get any data. Please contact your system administrator to set the right configuration.",
            "mode":"dismissible"
        });
	},
})