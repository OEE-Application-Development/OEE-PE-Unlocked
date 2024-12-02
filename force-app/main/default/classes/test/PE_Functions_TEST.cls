@IsTest
private class PE_Functions_TEST {

    @TestSetup
    private static void peData() {
        Account oee = new Account(Name = 'OEE', hed__School_Code__c = 'OEE');
        insert oee;

        hed__Term__c term = new hed__Term__c(Name = 'Summer 2024', RecordTypeId = [SELECT Id FROM RecordType WHERE SobjectType = 'hed__Term__c' AND DeveloperName = 'Noncredit' LIMIT 1].Id, lms_hed__LMS_Reference_Code__c = '2024SM', hed__Account__c = oee.Id);
        insert term;
    }
    
    @IsTest
    private static void getNoncreditTermsInvocable() {
        Test.startTest();

        List<hed__Term__c> ncTerms = GetNoncreditTerms.getNoncreditTermsInvocable(new List<Integer>{6}).get(0);
        System.assert(ncTerms.get(0).RecordType.DeveloperName == 'Noncredit', 'Term is not of type noncredit.');

        Test.stopTest();
    }

}