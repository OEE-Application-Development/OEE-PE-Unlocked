Id recordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'hed__Course__c' AND DeveloperName = 'Noncredit' LIMIT 1].Id;
List<hed__Course__c> courses = [SELECT Id, RecordTypeId FROM hed__Course__c WHERE RecordTypeId = ''];
for(hed__Course__c course : courses) {
    course.RecordTypeId = recordTypeId;
}
update courses;