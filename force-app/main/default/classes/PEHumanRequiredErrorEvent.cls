global with sharing class PEHumanRequiredErrorEvent {
    @InvocableMethod(Label='Send Error to Grid' Description='Sends an Error to the grid that should be responded to by a human.')
    global static List<AzureEventIntegration.AzureResponse> sendError(List<PEHumanRequiredRequest> requests) {
        List<AzureEventIntegration.AzureEvent> events = new List<AzureEventIntegration.AzureEvent>();
        for(PEHumanRequiredRequest request : requests) {
            events.add(HumanRequiredEvent(request.errorType, request.errorSubType, request.message, request.data));
        }

        return new List<AzureEventIntegration.AzureResponse>{AzureEventIntegration.sendEvents(events, false)};
    }

    private static AzureEventIntegration.AzureEvent HumanRequiredEvent(String errorType, String errorSubType, String message, String data) {
        return new AzureEventIntegration.AzureEvent(
            'error', 
            'HumanRequired', 
            'csuoee/noncredit/error', 
            new Map<String, Object>{'errorType' => errorType, 'errorSubType' => errorSubType, 'message' => message, 'data' => data}
        );
    }

    global class PEHumanRequiredRequest extends AzureEventIntegration.AzureRequest {
        @InvocableVariable(Required=true Description='Error Type')
        global String errorType;

        @InvocableVariable(Required=false Description='Error Sub Type')
        global String errorSubType;

        @InvocableVariable(Required=true Description='Error Message')
        global String message;

        @InvocableVariable(Required=false Description='Error Data Map')
        global String data;



        global PEHumanRequiredRequest() {super(false);}
        global PEHumanRequiredRequest(String errorType, String message) {
            super(false);
            this.errorType = errorType;
            this.message = message;
        }
    }
    
}