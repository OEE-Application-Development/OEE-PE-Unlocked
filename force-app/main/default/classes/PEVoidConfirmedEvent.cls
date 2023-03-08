global with sharing class PEVoidConfirmedEvent {
    @InvocableMethod(Label='Enroll Student in Section' Description='Sends confirmation request')
    global static List<AzureEventIntegration.AzureResponse> unenrollStudent(List<PEConfirmedEvent.PEConfirmedRequest> requests) {
        List<AzureEventIntegration.AzureEvent> events = new List<AzureEventIntegration.AzureEvent>();
        for(PEConfirmedEvent.PEConfirmedRequest request : requests) {
            events.add(VoidConfirmedEvent(request.userId, request.offeringReference));
        }

        return new List<AzureEventIntegration.AzureResponse>{AzureEventIntegration.sendEvents(events, false)};
    }

    private static AzureEventIntegration.AzureEvent VoidConfirmedEvent(String studentId, String sectionReference) {
        return new AzureEventIntegration.AzureEvent(
            'registration', 
            'Dropped', 
            'csuoee/noncredit/registration', 
            new Map<String, Object>{'studentId' => studentId, 'sectionReference' => sectionReference}
        );
    }
    
}