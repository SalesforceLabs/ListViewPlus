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
	showGoodToast: function(component,event,helper){   
        component.find('notifLib').showToast({
            "title": "Saved Successfully!",
            "message": "Configuration Saved. Please click config Icon above to close this window.",
            "mode":"dismissible"
        });
        
    },
    showBurntToast: function(component,event,helper){   
        component.find('notifLib').showToast({
            "title": "Save Not Successful!",
            "message": "Configuration is not saved. Please check debug logs",
            "mode":"dismissible"
        });
    }
})
