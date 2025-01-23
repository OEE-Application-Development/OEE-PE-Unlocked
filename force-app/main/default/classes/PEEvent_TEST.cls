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
    private static void allHelperTypes() {
        Test.startTest();

        System.assert(PEHelpers.getNoncreditTermType() != null);
        System.assert(PEHelpers.getNoncreditDeptRecordType() != null);
        //System.assert(PEHelpers.getNoncreditInstitutionType() != null); This is a non-packaged RecordType
        System.assert(PEHelpers.getNoncreditStudentEnrollmentRecordType() != null);
        System.assert(PEHelpers.getNoncreditPendingStudentEnrollmentRecordType() != null);
        System.assert(PEHelpers.getNoncreditInstructorEnrollmentRecordType() != null);
        System.assert(PEHelpers.getNoncreditAccountRecordType() != null);

        Test.stopTest();
    }

}