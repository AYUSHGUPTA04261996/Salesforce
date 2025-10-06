trigger AccountTrigger on Account (before insert, after update, before update,before delete) {
    if(Trigger.isInsert){
        if(Trigger.isbefore){
             AccountTriggerHandler.scenario12(Trigger.new, Trigger.oldMap);
        }
    }
    if(Trigger.isUpdate){
        if(Trigger.isBefore){
            AccountTriggerHandler.scenario10(Trigger.new, Trigger.oldMap);
            AccountTriggerHandler.scenario12(Trigger.new, Trigger.oldMap);
        }
        if(Trigger.isAfter){
            AccountTriggerHandler.scenario14(Trigger.new, Trigger.oldMap);
        }
    }
    if(Trigger.isDelete && Trigger.isBefore){
        AccountTriggerHandler.scenario255(Trigger.new);
    }
}