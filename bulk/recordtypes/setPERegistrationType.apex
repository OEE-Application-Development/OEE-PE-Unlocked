Id recordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'csuoee__Registration__c' AND DeveloperName = 'PE_Registration' LIMIT 1].Id;
List<csuoee__Registration__c> regs = [SELECT Id, RecordTypeId FROM csuoee__Registration__c WHERE RecordTypeId = ''];
for(csuoee__Registration__c reg : regs) {
    reg.RecordTypeId = recordTypeId;
}
update regs;