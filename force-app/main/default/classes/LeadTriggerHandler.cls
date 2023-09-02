public without sharing class LeadTriggerHandler
{        
    public static void beforeInsert(List<Lead> triggerNew)
    {
        automaticRouting(triggerNew);
    }
    public static void afterInsert(Map<Id, Lead> triggerNewMap)
    {
        providerHandler(triggerNewMap);
    }
    public static void beforeUpdate(Map<Id, Lead> triggerOldMap, Map<Id, Lead> triggerNewMap)
    {
    }
    public static void afterUpdate(Map<Id, Lead> triggerOldMap, Map<Id, Lead> triggerNewMap)
    {
        providerHandler(triggerNewMap);
    }
    public static void beforeDelete(Map<Id, Lead> triggerOldMap)
    {
    }
    public static void automaticRouting(List<Lead> triggerNew)
    {   
        User backupUser = [SELECT Id FROM User WHERE Profile.Name = 'System Administrator' AND IsActive = TRUE LIMIT 1];
        
        //these users will trigger assignment rules to run if they are the created by
        Map<Id, User> assignmentRulesUserMap = new Map<Id, User>([SELECT Id,Name FROM User WHERE Name IN('Emily Gendreau','Maks Danilin') AND IsActive = TRUE]);

		Map<Id, Group> groupMap = new Map<Id, Group>([SELECT Id,Name FROM Group WHERE Type = 'Queue' ORDER BY NAME]);
        Map<string, Id> groupNameMap = new Map<string, Id>();
        for(Group g : groupMap.values())
        {
            groupNameMap.put(g.Name, g.Id);
        }
        
        Set<string> priorityInsuranceCarrier = new Set<string>();
        priorityInsuranceCarrier.add('Anthem');
        priorityInsuranceCarrier.add('BCBS Other');
        priorityInsuranceCarrier.add('Tufts');
        priorityInsuranceCarrier.add('Unicare');
        
        Set<string> priorityInsuranceOther = new Set<string>();
        priorityInsuranceOther.add('Empire BCBS');
        priorityInsuranceOther.add('Federal BCBS');
        priorityInsuranceOther.add('Blue Cross Blue Shield of Florida');
        priorityInsuranceOther.add('Blue Cross Blue Shield of Massachusetts');
        priorityInsuranceOther.add('Blue Cross Blue Shield of Rhode Island');
        
        Set<string> northeastRegion = new Set<string>();
        northeastRegion.add('CT');
        northeastRegion.add('RI');
        northeastRegion.add('MA');
        northeastRegion.add('NH');
        northeastRegion.add('ME');
        
        Set<string> midwestRegion = new Set<string>();
        midwestRegion.add('KY');
        midwestRegion.add('IN');
        midwestRegion.add('OH');
        
        Set<string> southernRegion = new Set<string>();
        southernRegion.add('FL');
        southernRegion.add('GA');
        southernRegion.add('VA');
        
		Id northeastOwnerId = groupNameMap.get('Northeast New Leads Queue');
        Id midwestOwnerId = groupNameMap.get('Midwest New Leads Queue');
        Id southernOwnerId = groupNameMap.get('Southern New Leads Queue');
        Id genericNewLeadsOwnerId = groupNameMap.get('New Leads Queue');
        
        Id northeastMAPOwnerId = groupNameMap.get('Northeast MAP Calls');
        Id midwestMAPOwnerId = groupNameMap.get('Midwest MAP Calls');
        Id southernMAPOwnerId = groupNameMap.get('Southern MAP Calls');
        Id genericMAPOwnerId = groupNameMap.get('MAP Calls');
        
        List<AssignmentRule> rules = [SELECT Id 
                                      FROM AssignmentRule
                                      WHERE SObjectType = 'Lead'
                                      AND Active = TRUE
                                      LIMIT 1];
        if(rules.isEmpty())
            return;
        
        AssignmentRule activeRule = rules[0];
        Database.DMLOptions dmloptions = new Database.DMLOptions();
        dmloptions.AssignmentRuleHeader.assignmentRuleId = activeRule.Id;
        
        
        
        for(Lead l : triggerNew)
        {
            if(assignmentRulesUserMap.containsKey(l.CreatedById))
                l.setOptions(dmloptions);
        }
        
        /*
        for(Lead l : triggerNew)
        {
            l.State = Utilities.CleanState(l.State);
            if(l.Created_By_MAP__c == true)
            {
               //MAP created Lead logic
               if(northeastRegion.contains(l.State))
                   l.OwnerId = northeastMapOwnerId;
                else if(midwestRegion.contains(l.State))
                    l.OwnerId = midwestMAPOwnerId;
                else if(southernRegion.contains(l.State))
                    l.OwnerId = southernMAPOwnerId;
                else
                    l.OwnerId = genericMAPOwnerId;
            }
            else
            {
                //Standard NON-MAP Logic
                if(northeastRegion.contains(l.State))
                    l.OwnerId = northeastOwnerId;
                else if(midwestRegion.contains(l.State))
                    l.OwnerId = midwestOwnerId;
                else if(southernRegion.contains(l.State))
                    l.OwnerId = southernOwnerId;
                else
                    l.OwnerId = genericNewLeadsOwnerId;
            }
        }
        */
        
        
        /* code that existed and was working before AWARE/EMILY changed the routing logic definitions
        for(Lead l : triggerNew)
        {
            if(l.Created_By_MAP__c == true)
            {
                //answering service logic
                l.OwnerId = groupNameMap.containsKey('New Leads Queue') ? groupNameMap.get('New Leads Queue') : backupUser.Id;
            }
            //high priority web
            else if(l.Reason_for_Seeking_Treatment__c != null && !string.isBlank(l.Reason_for_Seeking_Treatment__c) && l.Phone != null && priorityInsuranceCarrier.contains(l.Insurance_Carrier_Name__c))
            {
				if(l.Insurance_Carrier_Name__c == 'BCBS Other')
                {
                    if(priorityInsuranceOther.contains(l.Insurance_Carrier_Other__c))
                        l.OwnerId = groupNameMap.containsKey('New Leads Queue') ? groupNameMap.get('New Leads Queue') : backupUser.Id;  
                }
                else
                {
                    l.OwnerId = groupNameMap.containsKey('New Leads Queue') ? groupNameMap.get('New Leads Queue') : backupUser.Id;                    
                }
            }
            else if(l.FirstName != null && l.LastName != null && l.Phone != null)
            {
                l.OwnerId = groupNameMap.containsKey('New Leads Queue') ? groupNameMap.get('New Leads Queue') : backupUser.Id;
            }
        }
		*/
    }
    public static void providerHandler(Map<Id, Lead> triggerNewMap)
    {
        Map<Id, Id> leadProviderMap = new Map<Id, Id>();
        for(Lead l : triggerNewMap.values())
        {
            if(l.Provider_Referral_Account__c != null)
            {
                leadProviderMap.put(l.Id, l.Provider_Referral_Account__c);
            }
        }
        
        if(!leadProviderMap.isEmpty())
        {
            List<Client_Contact__c> clientContacts = [SELECT Id,
                                                      Lead__c,
                                                      Account__c
                                                      FROM Client_Contact__c
                                                      WHERE Lead__c IN :leadProviderMap.keySet()
                                                      AND Account__c != null];
            
            Map<Id, Id> matchingProviderMap = new Map<Id, Id>();
            for(Client_Contact__c cc : clientContacts)
            {
                matchingProviderMap.put(cc.Lead__c, cc.Account__c);
            }
            List<Sigmund_Contact_Type__c> contactTypes = [SELECT Id FROM Sigmund_Contact_Type__c WHERE Name = 'Referent' LIMIT 1];
            List<Sigmund_Relationship__c> relationshipTypes = [SELECT Id FROM Sigmund_Relationship__c WHERE Name = 'Case Worker' LIMIT 1];
            List<Client_Contact__c> clientContactsToInsert = new List<Client_Contact__c>();
            for(Id key : leadProviderMap.keySet())
            {
                if(matchingProviderMap.isEmpty() || clientContacts.isEmpty())
                {
                    Client_Contact__c cx = new Client_Contact__c();
                    cx.Lead__c = key;
                    cx.Account__c = leadProviderMap.get(key);
                    cx.Sigmund_Contact_Type__c = contactTypes.isEmpty() ? null : contactTypes[0].Id;
                    cx.Sigmund_Relationship__c = relationshipTypes.isEmpty() ? null : relationshipTypes[0].Id;
                    clientContactsToInsert.add(cx);
                }
                //do we have some account contacts already, but not this particular one?
                else if(matchingProviderMap.containsKey(key) && matchingProviderMap.get(key) != leadProviderMap.get(key))
                {
                    Client_Contact__c cx = new Client_Contact__c();
                    cx.Lead__c = key;
                    cx.Account__c = leadProviderMap.get(key);
                    cx.Sigmund_Contact_Type__c = contactTypes.isEmpty() ? null : contactTypes[0].Id;
                    cx.Sigmund_Relationship__c = relationshipTypes.isEmpty() ? null : relationshipTypes[0].Id;
                    clientContactsToInsert.add(cx);
                }
            }
            if(!clientContactsToInsert.isEmpty())
                insert clientContactsToInsert;
        }
    }
}