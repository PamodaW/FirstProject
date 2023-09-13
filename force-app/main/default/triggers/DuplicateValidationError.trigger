trigger DuplicateValidationError on LeadClientInsurance__c (before insert, before update) {
    Set<String> payerAndMemberIDSet = new Set<String>();

    for (LeadClientInsurance__c record : Trigger.new) {
        // Construct a unique identifier by combining Payer__c Id and Member_ID__c value
        String uniqueIdentifier = (record.Payer__c != null ? String.valueOf(record.Payer__c) : 'null') + '-' + record.Member_ID__c;

        // Check if the unique identifier already exists in the Set
        if (payerAndMemberIDSet.contains(uniqueIdentifier)) {
            record.Member_ID__c.addError('A record with the same Payer and Member ID combination already exists.');
        } else {
            payerAndMemberIDSet.add(uniqueIdentifier);
        }
    }
}
