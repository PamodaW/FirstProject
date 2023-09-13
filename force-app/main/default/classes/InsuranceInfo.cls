public with sharing class InsuranceInfo {
    public String FirstName { get; set; }
    public String LastName { get; set; }
    public String MiddleName { get; set; }
    public String Suffix { get; set; }
    public Date DateOfBirth { get; set; }
    public String Email { get; set; }
    public Decimal PhoneNumber { get; set; }

    // Constructor
    public InsuranceInfo() {
        FirstName = ApexPages.ShowLeadClientInfo().getParameters().get('First_Name__c');
        LastName = ApexPages.ShowLeadClientInfo().getParameters().get('Last_Name__c');
        MiddleName = ApexPages.ShowLeadClientInfo().getParameters().get('Middle_Name__c');
        Suffix = ApexPages.ShowLeadClientInfo().getParameters().get('Suffix__c');
        DateOfBirth = ApexPages.ShowLeadClientInfo().getParameters().get('Date_Of_Birth__c');
        Email = ApexPages.ShowLeadClientInfo().getParameters().get('Email__c');
        PhoneNumber = Decimal.valueOf(ApexPages.ShowLeadClientInfo().getParameters().get('Phone_Number__c'));
    }
    
}