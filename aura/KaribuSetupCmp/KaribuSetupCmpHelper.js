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