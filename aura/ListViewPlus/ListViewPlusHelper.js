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