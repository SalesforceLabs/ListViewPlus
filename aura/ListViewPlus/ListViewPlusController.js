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
