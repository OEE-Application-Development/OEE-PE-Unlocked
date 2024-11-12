Id recordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'hed__Term__c' AND DeveloperName = 'Noncredit' LIMIT 1].Id;
List<hed__Term__c> terms = [SELECT Id, RecordTypeId FROM hed__Term__c WHERE RecordTypeId = ''];
for(hed__Term__c term : terms) {
    term.RecordTypeId = recordTypeId;
}
update terms;