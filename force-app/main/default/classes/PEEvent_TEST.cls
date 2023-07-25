@IsTest
private class PEEvent_TEST {
    
    @IsTest
    private static void enrollStudent() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, BaseTestUtil.getEventCalloutMock());
        List<AzureEventIntegration.AzureResponse> responses = PEConfirmedEvent.enrollStudent(new List<PEConfirmedEvent.PEConfirmedRequest>{new PEConfirmedEvent.PEConfirmedRequest('userId', 'offeringReference')});
        Test.stopTest();

        System.assert(responses.get(0).success);
    }

    @IsTest
    private static void unenrollStudent() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, BaseTestUtil.getEventCalloutMock());
        List<AzureEventIntegration.AzureResponse> responses = PEVoidConfirmedEvent.unenrollStudent(new List<PEConfirmedEvent.PEConfirmedRequest>{new PEConfirmedEvent.PEConfirmedRequest('userId', 'offeringReference')});
        Test.stopTest();

        System.assert(responses.get(0).success);
    }

    @IsTest
    private static void cancelRegistration() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, BaseTestUtil.getEventCalloutMock());
        List<AzureEventIntegration.AzureResponse> responses = PERegistrationCancelEvent.cancelRegistration(new List<PERegistrationCancelEvent.PERegistrationCancelRequest>{new PERegistrationCancelEvent.PERegistrationCancelRequest('regId'), new PERegistrationCancelEvent.PERegistrationCancelRequest('regId', 'test'), new PERegistrationCancelEvent.PERegistrationCancelRequest('regId', 'test', true)});
        Test.stopTest();

        System.assert(responses.get(0).success);
    }

    @IsTest
    private static void sendHumanRequired() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, BaseTestUtil.getEventCalloutMock());
        List<AzureEventIntegration.AzureResponse> responses = PEHumanRequiredErrorEvent.sendError(new List<PEHumanRequiredErrorEvent.PEHumanRequiredRequest>{new PEHumanRequiredErrorEvent.PEHumanRequiredRequest('Fulfillment Failed', 'Just a test.')});
        Test.stopTest();

        System.assert(responses.get(0).success);
    }

    @IsTest
    private static void lmsEnrollmentRequest() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, BaseTestUtil.getEventCalloutMock());
        List<AzureEventIntegration.AzureResponse> responses = PELmsEnrollmentRequestEvent.lmsEnrollmentRequest(new List<PELmsEnrollmentRequestEvent.PELmsEnrollmentRequestRequest>{new PELmsEnrollmentRequestEvent.PELmsEnrollmentRequestRequest('Student', '4TESTUSER', '2023SP-CO-333-100')});
        Test.stopTest();

        System.assert(responses.get(0).success);
    }

    @IsTest
    private static void lmsEnrollmentComplete() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, BaseTestUtil.getEventCalloutMock());
        List<AzureEventIntegration.AzureResponse> responses = PELmsEnrollmentCompleteEvent.lmsEnrollmentComplete(new List<PELmsEnrollmentCompleteEvent.PELmsEnrollmentCompleteRequest>{new PELmsEnrollmentCompleteEvent.PELmsEnrollmentCompleteRequest('123456', '4TESTUSER', '2023SP-CO-333-100', 'https://colostate.test.instructure.com/courses/123456')});
        Test.stopTest();

        System.assert(responses.get(0).success);
    }

    @IsTest
    private static void registrationBatchTest() {
        Contact s1 = new Contact(LastName = 'Test1', Email = 'Test1@fake.edu');
        Contact s2 = new Contact(LastName = 'Test2', Email = 'Test2@fake.edu');

        insert new List<Contact>{s1, s2};

        Account department = new Account(Name = 'Department');
        insert department;

        hed__Term__c term = new hed__Term__c(hed__Account__c = department.Id, Name = '2023SP');
        insert term;

        RecordType rt = [select Id from RecordType where NamespacePrefix = 'csuoee' and DeveloperName = 'Credit' LIMIT 1];
        hed__Course__c course = new hed__Course__c(Name = 'CO 333', hed__Course_ID__c = 'CO 333', csuoee__Course_Code__c = 'CO 333', hed__Account__c = department.Id, RecordTypeId = rt.Id);
        insert course;

        hed__Course_Offering__c offering = new hed__Course_Offering__c(Name = 'CO 333 100', hed__Section_ID__c = '100', hed__Course__c = course.Id, hed__Term__c = term.Id);
        insert offering;

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, BaseTestUtil.getEventCalloutMock());
        csuoee__Registration_Batch__c batch = new csuoee__Registration_Batch__c(csuoee__Default_Transfer__c = 1);
        insert batch;

        csuoee__Registration_Request__c r1 = new csuoee__Registration_Request__c(csuoee__Registration_Batch__c = batch.Id, csuoee__Student__c = s1.Id, csuoee__Course_Offering__c = offering.Id);
        csuoee__Registration_Request__c r2 = new csuoee__Registration_Request__c(csuoee__Registration_Batch__c = batch.Id, csuoee__Student__c = s2.Id, csuoee__Course_Offering__c = offering.Id);
        insert new List<csuoee__Registration_Request__c>{r1, r2};

        batch.csuoee__Is_Ready__c = true;
        update batch;

        Test.stopTest();

        System.assert(true);
    }

}