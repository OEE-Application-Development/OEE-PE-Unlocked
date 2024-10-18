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

    @IsTest
    private static void attemptConvertByEmail() {
        Lead lead = new Lead(LastName = 'Test', Email = 'Email@123.com', Company = 'Test Company');
        insert lead;
        
        Lead lead1 = new Lead(LastName = 'Test', Email = 'Email1@123.com', Company = 'Test Company');
        insert lead1;
        Lead lead2 = new Lead(LastName = 'Test', Email = 'Email2@123.com', Phone = '+123456789', Company = 'Test Company');
        insert lead2;

        Contact contact = new Contact(LastName = 'Test', EID__c = 'test-eid', CSU_ID__c = '123456789', Email = 'Email@123.com', hed__AlternateEmail__c = 'AltEmail@123.com');
        insert contact;

        Contact contact2 = new Contact(LastName = 'Test2', EID__c = 'test-eid2', CSU_ID__c = '223456789', Email = 'Email2@123.com', hed__AlternateEmail__c = 'Email2@123.com');
        insert contact2;
        
        Account fakePEacct = new Account(Name = 'Opus Account', hed__School_Code__c = 'learn.colostate.edu.123456');
        insert fakePEacct;

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.httpMethod = 'POST';
        req.requestURI = '/noncredit/lead/convert';

        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();

        TryConvertNoncreditLead.attemptConvert(
            new List<Contact>{
                new Contact(LastName = 'Test', EID__c = 'test-eid', CSU_ID__c = '123456789', Email = 'AltEmail@123.com'),
                new Contact(LastName = 'Test1', EID__c = 'test-eid1', CSU_ID__c = '111111111', Email = 'Email@123.com'),
                new Contact(LastName = 'Test2', EID__c = 'test-eid2', CSU_ID__c = '222222222', Email = 'Email2@123.com', Account = new Account(hed__School_Code__c = 'learn.colostate.edu.123456'))
            }
        );

        Test.stopTest();
    }

}