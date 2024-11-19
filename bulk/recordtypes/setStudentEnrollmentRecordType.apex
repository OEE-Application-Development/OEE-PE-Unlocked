Id recordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'hed__Course_Enrollment__c' AND DeveloperName = 'Student' LIMIT 1].Id;
List<hed__Course_Enrollment__c> enrollments = [SELECT Id, RecordTypeId FROM hed__Course_Enrollment__c WHERE RecordTypeId = ''];
for(hed__Course_Enrollment__c enrollment : enrollments) {
    enrollment.RecordTypeId = recordTypeId;
}
update enrollments;