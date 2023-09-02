trigger LeadTrigger on Lead (before insert, after insert, before update, after update, before delete) 
{
    if (trigger.isBefore && trigger.isInsert)
    {
        LeadTriggerHandler.beforeInsert(Trigger.new);
    }
    if (trigger.isAfter && trigger.isInsert)
    {
        LeadTriggerHandler.afterInsert(trigger.newMap);
    }
    if (trigger.isBefore && trigger.isUpdate) 
    {
        LeadTriggerHandler.beforeUpdate(trigger.oldMap, trigger.newMap);
    }
    if (trigger.isAfter && trigger.isUpdate) 
    {
        LeadTriggerHandler.afterUpdate(trigger.oldMap, trigger.newMap);
    }
    if(trigger.isBefore && trigger.isDelete)
    {
        LeadTriggerHandler.beforeDelete(trigger.oldMap);
    }
}