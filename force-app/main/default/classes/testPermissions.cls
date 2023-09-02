public class testPermissions {
    
    
    public static void checkPermissions(){
        
        String countryISO;
        Map<Object,Object> mapData = new Map<Object,Object>();
        string verificationStatusField;
        string lookUpResultField;
        string access_token;
        string payerName;
        string vobFieldId;
        string requestLabel;
        String returnedContinuationId ;
        List<VerifyTx__Mappings_Data__c> mappData;
        
        if (VerificationUpdate.canReadField('VerifyTx__Mappings_Data__c','VerifyTx__Client_Status__c') &&
            VerificationUpdate.canReadField('VerifyTx__Mappings_Data__c','VerifyTx__Facility__c') &&
            VerificationUpdate.canReadField('VerifyTx__Mappings_Data__c','VerifyTx__Lookup_Id__c') &&
            VerificationUpdate.canReadField('VerifyTx__Mappings_Data__c','VerifyTx__Member_Id__c') &&
            VerificationUpdate.canReadField('VerifyTx__Mappings_Data__c','VerifyTx__Patient_Birth_Date__c') &&
            VerificationUpdate.canReadField('VerifyTx__Mappings_Data__c','VerifyTx__Patient_First_Name__c') &&
            VerificationUpdate.canReadField('VerifyTx__Mappings_Data__c','VerifyTx__Patient_Gender__c') &&
            VerificationUpdate.canReadField('VerifyTx__Mappings_Data__c','VerifyTx__Patient_Last_Name__c') &&
            VerificationUpdate.canReadField('VerifyTx__Mappings_Data__c','VerifyTx__Payer_Name__c') &&
            VerificationUpdate.canReadField('VerifyTx__Mappings_Data__c','VerifyTx__Subscriber_Relationship__c') &&
            VerificationUpdate.canReadField('VerifyTx__Mappings_Data__c','VerifyTx__Verification_Status__c')&&
            VerificationUpdate.canReadField('VerifyTx__Mappings_Data__c','VerifyTx__Verify_Once__c')&&
            VerificationUpdate.canReadField('VerifyTx__Mappings_Data__c','VerifyTx__VOB_Id__c'))
        {
            mappData = [
                Select id,VerifyTx__VOB_Id__c,VerifyTx__Client_Status__c,VerifyTx__Facility__c,VerifyTx__Lookup_Id__c,
                VerifyTx__Member_Id__c,VerifyTx__Patient_Birth_Date__c,VerifyTx__Patient_First_Name__c,
                VerifyTx__Patient_Gender__c,VerifyTx__Patient_Last_Name__c,VerifyTx__Payer_Name__c,
                VerifyTx__Subscriber_Relationship__c,VerifyTx__Verification_Status__c,VerifyTx__Verify_Once__c
                from VerifyTx__Mappings_Data__c Limit 1
            ];
        }
        
        final String Map_Field_For_PayerName = mappData[0].VerifyTx__Payer_Name__c;
        system.debug('Map_Field_For_PayerName'+Map_Field_For_PayerName);
        final String Map_Field_For_MemberId = mappData[0].VerifyTx__Member_Id__c;
        final String Map_Field_For_Patient_First_Name = mappData[0].VerifyTx__Patient_First_Name__c;
        final String Map_Field_For_Patient_Last_Name = mappData[0].VerifyTx__Patient_Last_Name__c;
        final String Map_Field_For_Patient_Birthdate = mappData[0].VerifyTx__Patient_Birth_Date__c;
        final String Map_Field_For_Client_Status = mappData[0].VerifyTx__Client_Status__c;
        final String Map_Field_For_Subscribe_Relationship = mappData[0].VerifyTx__Subscriber_Relationship__c;
        final string Map_Field_For_Status = mappData[0].VerifyTx__Verification_Status__c;
        final string Map_Field_For_Gender = mappData[0].VerifyTx__Patient_Gender__c;
        final string Map_Field_For_Facility = mappData[0].VerifyTx__Facility__c;
        final string Map_Field_For_Lookup_id = mappData[0].VerifyTx__Lookup_Id__c;
        final string Map_Field_For_VOB_Id = mappData[0].VerifyTx__VOB_Id__c;
        verificationStatusField = mappData[0].VerifyTx__Verification_Status__c;
        lookUpResultField = mappData[0].VerifyTx__Lookup_Id__c;
        vobFieldId = mappData[0].VerifyTx__VOB_Id__c;
        
        string  mystrQuery;
        String objectName = 'Lead';
        
        if(VerificationUpdate.canReadObject(objectName) &&
           VerificationUpdate.canReadField(objectName,'id') &&
           VerificationUpdate.canReadField(objectName,Map_Field_For_PayerName) &&
           VerificationUpdate.canReadField(objectName,Map_Field_For_MemberId) &&
           VerificationUpdate.canReadField(objectName,Map_Field_For_Patient_First_Name) &&
           VerificationUpdate.canReadField(objectName,Map_Field_For_Patient_Last_Name) &&
           VerificationUpdate.canReadField(objectName,Map_Field_For_Patient_Birthdate) &&
           VerificationUpdate.canReadField(objectName,Map_Field_For_Client_Status) &&
           VerificationUpdate.canReadField(objectName,Map_Field_For_Subscribe_Relationship) &&
           VerificationUpdate.canReadField(objectName,Map_Field_For_Status) &&
           VerificationUpdate.canReadField(objectName,Map_Field_For_Gender) &&
           VerificationUpdate.canReadField(objectName,Map_Field_For_Facility))
            
        {
            
            // query on object that we are using for verification.
            mystrQuery = 'Select id,'+Map_Field_For_PayerName+','+Map_Field_For_VOB_Id+','+Map_Field_For_MemberId+
                ','+Map_Field_For_Patient_First_Name+','+Map_Field_For_Patient_Last_Name+','+Map_Field_For_Patient_Birthdate+
                ','+Map_Field_For_Client_Status+','+Map_Field_For_Subscribe_Relationship+','+Map_Field_For_Status+
                ','+Map_Field_For_Gender+','+ Map_Field_For_Facility +' from '+ objectName+
                ' where id = '+ '\''+String.escapeSingleQuotes('')+ '\'' +' Limit 1';
            
            System.debug('myStrQuery '+mystrQuery);
            
        }
        else
            system.debug('No');
        
    }
    
}