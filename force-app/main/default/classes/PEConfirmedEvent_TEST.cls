@IsTest
private class PEConfirmedEvent_TEST {
    
    @IsTest
    private static void enrollStudent() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, BaseTestUtil.getEventCalloutMock());
        List<AzureEventIntegration.AzureResponse> responses = PEConfirmedEvent.enrollStudent(new List<PEConfirmedEvent.PEConfirmedRequest>{new PEConfirmedEvent.PEConfirmedRequest('userId', 'offeringReference')});
        Test.stopTest();

        System.assert(responses.get(0).success);
    }

}