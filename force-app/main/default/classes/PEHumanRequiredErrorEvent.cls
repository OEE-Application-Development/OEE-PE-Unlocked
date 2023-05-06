global with sharing class PEHumanRequiredErrorEvent {
    @InvocableMethod(Label='Send Error to Grid' Description='Sends an Error to the grid that should be responded to by a human.')
    global static List<AzureEventIntegration.AzureResponse> sendError(List<PEHumanRequiredRequest> requests) {
        List<AzureEventIntegration.AzureEvent> events = new List<AzureEventIntegration.AzureEvent>();
        for(PEHumanRequiredRequest request : requests) {
            events.add(HumanRequiredEvent(request.errorType, request.message));
        }

        return new List<AzureEventIntegration.AzureResponse>{AzureEventIntegration.sendEvents(events, false)};
    }

    private static AzureEventIntegration.AzureEvent HumanRequiredEvent(String errorType, String message) {
        return new AzureEventIntegration.AzureEvent(
            'error', 
            'HumanRequired', 
            'csuoee/noncredit/error', 
            new Map<String, Object>{'errorType' => errorType, 'message' => message}
        );
    }

    global class PEHumanRequiredRequest extends AzureEventIntegration.AzureRequest {
        @InvocableVariable(Required=true Description='Error Type')
        global String errorType;

        @InvocableVariable(Required=true Description='Error Message')
        global String message;

        global PEHumanRequiredRequest(String errorType, String message) {
            super(false);
            this.errorType = errorType;
            this.message = message;
        }
    }
    
}