({
    doInit : function(component, event, helper) {
        let scope = component.get("v.scope");

        const columns = scope === 'person' ? [
            {label: "Name", fieldName: "Name", type: "text"},
            {label: "Phone", fieldName: "Mobile__c", type: "text"},
            {label: "Token", fieldName: "Token__c", type: "text"},
            {label: "Health Status", fieldName: "Health_Status__c", type: "text"},
            {label: "Status Update Date", fieldName: "Status_Update_Date__c", type: "date"},
            {label: "View/Update", type: 'button', initialWidth: 135, typeAttributes: { label: 'View Details', name: 'view_details', title: 'Click to View Details'}},
        ] : 
        [
            {label: "Name", fieldName: "Name", type: "text"},
            {label: "Status", fieldName: "Status__c", type: "text"},
            {label: "Pincode", fieldName: "Pincode__c", type: "text"},
            {label: "Address", fieldName: "Address__c", type: "text"},
            {label: "Red Score", fieldName: "Red_Score__c", type: "number"},
            {label: "Status Update Date", fieldName: "Status_Update_Date__c", type: "date"},
            {label: "View/Update", type: 'button', initialWidth: 135, typeAttributes: { label: 'View Details', name: 'view_details', title: 'Click to View Details'}},
        ];
        
        helper.fetchResult(component, scope);
        component.set("v.columns", columns);
    },

    handleKeyUp : function (cmp, evt, helper) {
        var isEnterKey = evt.keyCode === 13;
        var queryTerm = cmp.find('enter-search').get('v.value');
        if(!queryTerm){
            cmp.set("v.data", cmp.get("v.initialResponse"));
        }
        if (isEnterKey) {
            cmp.set('v.issearching', true);
            helper.searchRecord(cmp, queryTerm);
        }
    },

    handleRowAction: function (component, event, helper) {
        const action = event.getParam("action");
        const row = event.getParam("row");
        const scope = component.get("v.scope");

        switch (action.name) {
            case "view_details":
                const appEvent = scope === "person" ? $A.get("e.c:CTPersonSelectEvent") : $A.get("e.c:CTLocationSelectEvent");
                appEvent.setParams({
                    recordId: row.Id,
                    status: scope === "person" ? row.Health_Status__c : row.Status__c
                });
                appEvent.fire();
                break;
        }
    }
})
