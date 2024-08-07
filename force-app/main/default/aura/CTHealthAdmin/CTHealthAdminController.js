({
    tabSelectHandler: function (cmp, event, helper) {
        const selectedTabId = event.getParam("id");
        if(selectedTabId === 'person'){
            cmp.set("v.headerTitle", "Person View");
        } else {
            cmp.set("v.headerTitle", "Location View");
        }
        cmp.set("v.scope", selectedTabId);
        
        const healthHeaderComp = cmp.find("health-header");
        healthHeaderComp.fetchCount();

    }
})
