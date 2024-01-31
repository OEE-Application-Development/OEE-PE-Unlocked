@IsTest
private class PEHelpers_TEST {
    
    @IsTest
    private static void recordTypeTest() {
        List<RecordType> types = PERecordTypeRequestor.getPERecordTypes(new List<PERecordTypeRequestor.PERecordTypeRequest>{new PERecordTypeRequestor.PERecordTypeRequest('Term'), new PERecordTypeRequestor.PERecordTypeRequest('Department'), new PERecordTypeRequestor.PERecordTypeRequest('Instructor Enrollment'), new PERecordTypeRequestor.PERecordTypeRequest('Student Enrollment'), new PERecordTypeRequestor.PERecordTypeRequest('Student Pending Enrollment'), new PERecordTypeRequestor.PERecordTypeRequest('')});

        System.assertEquals(6, types.size());
        System.assert(types.get(0) != null);
        System.assert(types.get(5) == null);
    }

    @IsTest
    private static void createEnrollmentTest() {
        //hed__Course_Enrollment__c courseConnection, Account account
        hed__Course_Enrollment__c courseConnection = new hed__Course_Enrollment__c(csuoee__PE_Enrollment_Reference__c = '123456');
        Map<String, String> results;
        Account account = new Account();
        results = CreatePEEnrollmentViaAccount.createEnrollment(courseConnection, account);

        System.assert(results.get('success') == 'false');

        account = new Account(Name = 'Acct1', hed__School_Code__c = 'TestAccount1');
        insert account;
        Account testAccount = new Account(Name = 'Acct2', hed__School_Code__c = 'TestAccount2');
        insert testAccount;
        
        Account fakeout = new Account(Id = testAccount.Id, hed__School_Code__c = account.hed__School_Code__c);
        results = CreatePEEnrollmentViaAccount.createEnrollment(courseConnection, fakeout);

        System.assert(results.get('success') == 'false');
        results = CreatePEEnrollmentViaAccount.createEnrollment(courseConnection, account);

        System.assert(results.get('success') == 'false');

        Contact c = new Contact(LastName = 'LastName');
        insert c;
        account.hed__Primary_Contact__c = c.Id;
        update account;
        results = CreatePEEnrollmentViaAccount.createEnrollment(courseConnection, account);

        System.assert(results.get('success') == 'false');
        hed__Course__c course = new hed__Course__c(Name = 'Test', csuoee__Course_Code__c = 'ABCD 1200', hed__Account__c = account.Id);
        insert course;
        hed__Term__c term = new hed__Term__c(Name = 'TestTerm', hed__Account__c= account.Id);
        insert term;
        hed__Course_Offering__c offering = new hed__Course_Offering__c(Name = 'Test 1', lms_hed__LMS_Reference_Code__c = 'ABCD-1200-100', hed__Course__c = course.Id, hed__Term__c = term.Id);
        insert offering;

        courseConnection.hed__Course_Offering__c = offering.Id;
        courseConnection.hed__Contact__c = c.Id;
        results = CreatePEEnrollmentViaAccount.createEnrollment(courseConnection, account);

        System.assert(results.get('success') == 'true');
    }

}