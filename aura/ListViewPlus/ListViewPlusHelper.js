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
	injectComponent: function (name,attr, target) {
        
        $A.createComponent(name, attr, function (contentComponent, status, error) {
            if (status === "SUCCESS") {
                target.set('v.body', contentComponent);
            } else {
                throw new Error(error);
            }
        });
    },
    closeList:function(component, event, helper){
        component.set("v.body", []);
    },
    getUserInfo: function(component,event,helper) {
        var metaMap = new Map();
        var metaaction = component.get("c.getUserInfo");
        metaaction.setStorable();
        metaaction.setCallback(this,function(response){
            var state= response.getState();
            if(component.isValid() && state == "SUCCESS"){
                var metaMap=response.getReturnValue();
                
                component.set("v.username",metaMap['username']);
                component.set("v.userprofile",metaMap['profile']);
                if (metaMap["profile"] == "System Administrator") {
                    component.set("v.isAdmin",true);
                }
                else {
                    component.set("v.isAdmin",true);
                }
            }
            else {
                console.log("Failed State");
            }
        });
        $A.enqueueAction(metaaction);
    },
    
})
