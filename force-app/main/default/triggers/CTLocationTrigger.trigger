trigger CTLocationTrigger on Location__c (before insert, after insert, before update, after update) {
    switch on Trigger.operationType {
        when BEFORE_INSERT {
            CTLocationTriggerHandle.beforeInsertHandle(Trigger.new);
        }
        when BEFORE_UPDATE {
            CTLocationTriggerHandle.beforeUpdateHandle(Trigger.new, Trigger.oldMap);
        }
    }
}