global with sharing class PERegistrationCancelEvent {
    @InvocableMethod(Label='Cancel Registration' Description='Cancels an entire registration... may include multiple invoices if there is a sponsor.')
    global static List<AzureEventIntegration.AzureResponse> cancelRegistration(List<PERegistrationCancelRequest> requests) {
        List<AzureEventIntegration.AzureEvent> events = new List<AzureEventIntegration.AzureEvent>();
        for(PERegistrationCancelRequest request : requests) {
            events.add(RegistrationCancelEvent(request.regId, request.reason));
        }

        return new List<AzureEventIntegration.AzureResponse>{AzureEventIntegration.sendEvents(events, false)};
    }

    private static AzureEventIntegration.AzureEvent RegistrationCancelEvent(String registrationId, String reason) {
        return new AzureEventIntegration.AzureEvent(
            'registration', 
            'RegistrationCancel', 
            'csuoee/noncredit/registration', 
            new Map<String, Object>{'registrationId' => registrationId, 'reason' => reason}
        );
    }

    global class PERegistrationCancelRequest extends AzureEventIntegration.AzureRequest {
        @InvocableVariable(Required=true Description='Registration ID to cancel.')
        global String regId;

        @InvocableVariable(Required=true Description='Reason for cancellation. Not required - in SF will default to \'Cancelled by SF Admin\'')
        global String reason = 'Cancelled by SF Admin';

        global PERegistrationCancelRequest(String regId) {
            this(regId, null);
        }

        global PERegistrationCancelRequest(String regId, String reason) {
            super(false);
            this.regId = regId;
            if(reason != null)
                this.reason = reason;
        }
    }
}