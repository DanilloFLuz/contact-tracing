({
    fetchResult : function(component, scope) {
        let action = scope === 'person' ? component.get("c.getRecentPersonHelthChanges") : component.get("c.getRecentLocationHealthChanges");
        action.setCallback(this, function (response){
            const state = response.getState();
            if(state === 'SUCCESS'){
                const resp = response.getReturnValue();
                component.set("v.data", resp);
            }
        });
        $A.enqueueAction(action);
    }
})
