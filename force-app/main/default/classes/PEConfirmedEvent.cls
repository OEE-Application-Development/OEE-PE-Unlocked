global with sharing class PEConfirmedEvent {
    @InvocableMethod(Label='Enroll Student in Section' Description='Sends confirmation request')
    global static List<AzureEventIntegration.AzureResponse> enrollStudent(List<PEConfirmedRequest> requests) {
        List<AzureEventIntegration.AzureEvent> events = new List<AzureEventIntegration.AzureEvent>();
        for(PEConfirmedRequest request : requests) {
            events.add(ConfirmedEvent(request.userId, request.offeringReference));
        }

        return new List<AzureEventIntegration.AzureResponse>{AzureEventIntegration.sendEvents(events, false)};
    }

    private static AzureEventIntegration.AzureEvent ConfirmedEvent(String studentId, String sectionReference) {
        return new AzureEventIntegration.AzureEvent(
            'registration', 
            'Confirmed', 
            'csuoee/noncredit/registration', 
            new Map<String, Object>{'studentId' => studentId, 'sectionReference' => sectionReference}
        );
    }

    global class PEConfirmedRequest extends AzureEventIntegration.AzureRequest {
        @InvocableVariable(Required=true Description='User Id (Noncredit ID) of the Contact.')
        global String userId;

        @InvocableVariable(Required=true Description='Reference of the offering.')
        global String offeringReference;

        global PEConfirmedRequest(String userId, String offeringReference) {
            super(false);
            this.userId = userId;
            this.offeringReference = offeringReference;
        }
    }
}