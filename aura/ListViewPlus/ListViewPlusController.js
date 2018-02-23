/*JS to handle actions from UI*/
({
    doInit: function(component,event,helper) {
        helper.getUserInfo(component,event,helper);
    },
    handleActive: function(component,event,helper) { //Not used currently
        var tab = event.getSource();
        var attrs = {"ListViewName":"ListView1","isAdmin":component.get("v.isAdmin")}; 
        helper.injectComponent('c:ListDataCmp',attrs,tab);
    },
    
    toggleKaribu: function(component,event,helper) {
        var k = component.find("karibuparent");
        $A.util.toggleClass(k,"slds-hide");
    },
    showKaribu: function(component,event,helper) {
        var k = component.find("karibuparent");
        $A.util.toggleClass(k,"slds-hide");
    }
    
        
})