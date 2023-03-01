@IsTest
private class HandleEnrollments_TEST {

    private static final String TEST_USER_ID = 'test-noncredit-id';
    private static final String TEST_SECTION_REFERENCE = 'test-reference';
    @IsTest
    private static void handleStudentEnrollment() {
        csuoee__Confirmation_Publish__e event = new csuoee__Confirmation_Publish__e(csuoee__User_Id__c = TEST_USER_ID, csuoee__Section_Reference__c = TEST_SECTION_REFERENCE);

        Account fakeDept = new Account(Name = 'Fake Dept');
        insert fakeDept;

        hed__Course__c fakeCourse = new hed__Course__c(hed__Account__c = fakeDept.Id, Name = 'Fake Course', csuoee__Course_Code__c = 'FK 100');
        insert fakeCourse;

        hed__Term__c fakeTerm = new hed__Term__c(Name = 'Fake Term', hed__Account__c = fakeDept.Id);
        insert fakeTerm;

        hed__Course_Offering__c fakeOffering = new hed__Course_Offering__c(hed__Course__c = fakeCourse.Id, hed__Term__c = fakeTerm.Id, Name = 'Fake Course Offering', lms_hed__LMS_Reference_Code__c = TEST_SECTION_REFERENCE);
        insert fakeOffering;

        Contact fakeContact = new Contact(AccountId = fakeDept.Id , FirstName = 'Fake', LastName = 'Contact', Noncredit_ID__c = TEST_USER_ID);
        insert fakeContact;

        List<HandleEnrollments.EnrollmentRequest> requests = new List<HandleEnrollments.EnrollmentRequest>();
        requests.add(new HandleEnrollments.EnrollmentRequest(TEST_USER_ID, TEST_SECTION_REFERENCE));
        
        hed__Course_Enrollment__c enrollment = HandleEnrollments.handleStudentEnrollment(requests)[0];
        System.assert(enrollment != null);
        Id generatedId = enrollment.Id;

        enrollment = HandleEnrollments.handleStudentEnrollment(requests)[0];
        System.assertEquals(generatedId, enrollment.Id);
    }

}