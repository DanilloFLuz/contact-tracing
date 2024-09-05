({
    fetchResult : function(component, scope) {
        const action = scope === 'person' ? component.get("c.getRecentPersonHelthChanges") : component.get("c.getRecentLocationHealthChanges");
        action.setCallback(this, function (response){
            const state = response.getState();
            if(state === 'SUCCESS'){
                const resp = response.getReturnValue();
                component.set("v.data", resp);
                component.set("v.initialResponse", resp);
            }
        });
        $A.enqueueAction(action);
    },

    searchRecord : function (component, queryTerm) {
        const action = component.get("v.scope") === 'person' ? component.get("c.searchPeople") : component.get("c.searchLocations");
        action.setParams({
            "searchTerm": queryTerm
        });

        action.setCallback(this, function (response){
            const state = response.getState();
            if(state === 'SUCCESS'){
                const resp = response.getReturnValue();
                if(resp && resp.length > 0){
                    component.set("v.data", resp);
                }
                component.set('v.issearching', false);
            }
        });
        $A.enqueueAction(action);
    }
})
