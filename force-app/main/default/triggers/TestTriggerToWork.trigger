trigger TestTriggerToWork on Lead (before insert, after update, after insert) {
    for (lead record : Trigger.new) {
        if (record.Funding_Method__c == 'Other' && String.isBlank(record.Funding_Method_Other__c)) {
            record.Funding_Method_Other__c.addError('Textbox is required when SpecificValue is selected.');
        }
    }
}