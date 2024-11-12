Id recordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'Account' AND DeveloperName = 'Educational_Institution' LIMIT 1].Id;
List<Account> accounts = [SELECT Id, RecordTypeId FROM Account WHERE RecordTypeId = ''];
for(Account acct : accounts) {
    acct.RecordTypeId = recordTypeId;
}
update accounts;