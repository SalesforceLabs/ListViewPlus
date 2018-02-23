({
    scriptsLoaded : function(component, event, helper) {     
      var d= new Date();
      var quarter=Math.floor((d.getMonth() + 3) / 3)-1;
      var yr=d.getFullYear();   
      var Charts = ['Chart1','Chart2','Chart3'];
        for (var chart in Charts) {
            helper.buildDefaultChart(component,event,helper,Charts[chart]);
            helper.getChartData(component,event,helper,Charts[chart]);
            helper.getChartMetaData(component,event,helper,Charts[chart]);
        }
    },
    
    //Building the 3 charts. Update to use only 1 method in next release///
    buildChart1: function(component,event,helper) {
      
       if (component.get("v.Chart1Ready") == true) {
           var chartObject =  component.get("v.Chart1");
           
           chartObject.destroy(); //Destroy the static chart and build a new one. Better option is to just update data/
      	   var ctx1 = component.find("Chart1").getElement();
             var chart1 = new Chart(ctx1, {
            	type: 'doughnut',
            	data: helper.buildChartData(component,component.get("v.records")),
           		options: {                    
                    		animation : false,
               			 	responsive: true,
                			maintainAspectRatio: true,
                			legend:{
                					display:true,
                                position: 'bottom',
                                labels: {
                                boxWidth:15
                            }
                                }}});
               component.set("v.Chart1", chart1); 
     }
        else {
            helper.showErrorToast(component);
            helper.buildDefaultChart(component,event,helper,"Chart1");
        }
    },
      
   buildChart2: function(component,event, helper) {
       	  
          if (component.get("v.Chart2Ready") == true) {     
              var chartObject =  component.get("v.Chart2");
              chartObject.destroy();
              var ctx2 = component.find("Chart2").getElement();
              var chart2 = new Chart(ctx2, {
            	type: 'doughnut',
            	data: helper.buildChartData(component,component.get("v.records")),
           		 options: {
                			animation : false,
               			 	responsive: true,
                			maintainAspectRatio: true,
                			legend:{
                					display:true,
                                	position: 'bottom',
                                	 labels: {
                                		boxWidth:15
                            		}
                					}}});
                component.set("v.Chart2", chart2);
                
          }
       else {
           helper.buildDefaultChart(component,event,helper,"chart1");
       }
    },  
    
   buildChart3: function(component,event, helper) {
       var chartObject =  component.get("v.Chart3");
       var ctx3 = component.find("Chart3").getElement();
       if (component.get("v.Chart3Ready") == true) {
           chartObject.destroy();
           var chart3 = new Chart(ctx3, {
            	type: 'doughnut',
            	data: helper.buildChartData(component,component.get("v.records")),
           		 options: {
                			animation : false,
               			 	responsive: true,
                			maintainAspectRatio: true,
                			legend:{
                					display:true,
                                	position: 'bottom',
                                	 labels: {
                                		boxWidth:15
                            		}
                					}}});
                component.set("v.Chart3", chart3);
      }
       else {
           helper.buildDefaultChart(component,event,helper,"chart1");
       }
 },
   chartClicked:function(component, event, helper, chartid){
        	
        	var activePoints = [];
            var chartid = event.path[0].id;
        	var ChartName = null;
        	var chartData, idx, label = null;
        	if (chartid == 'Chart1') {
            	activePoints=component.get("v.Chart1").getElementsAtEvent(event);                	 
                if (activePoints.length != 0) {
                    ChartName = "Chart1";
                     chartData = activePoints[0]['_chart'].config.data
                     idx = activePoints[0]['_index'];
                	 label = chartData.labels[idx];
                     console.log("label"+label);
                     helper.getListChart(component,event,helper,ChartName,label);
                }
        	}
        	else if (chartid == 'Chart2') {
            		activePoints=component.get("v.Chart2").getElementsAtEvent(event);
                	if (activePoints.length != 0) {
                		ChartName = "Chart2";
                		chartData = activePoints[0]['_chart'].config.data
                    	idx = activePoints[0]['_index'];
                		label = chartData.labels[idx];
                        helper.getListChart(component,event,helper,ChartName,label);
        		}
            }
                else {
                    activePoints=component.get("v.Chart3").getElementsAtEvent(event);
                    if (activePoints.length != 0) {
	                    ChartName = "Chart3";
    	                chartData = activePoints[0]['_chart'].config.data
        	            idx = activePoints[0]['_index'];
            	    	label = chartData.labels[idx];
                        helper.getListChart(component,event,helper,ChartName,label);
    		        }
                }
	                    
    },
    closeList:function(component, event, helper){
        component.set("v.body", []);
    },
    moveout: function(component,event,helper){
        component.set("v.body",[]);
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
            "title": "Using Karibu Charts",
            "message": "Charts show quarterly data for different objects. Click on a pie to see a detailed list of records.",
            "mode":"dismissible"
        });
    }
    
})