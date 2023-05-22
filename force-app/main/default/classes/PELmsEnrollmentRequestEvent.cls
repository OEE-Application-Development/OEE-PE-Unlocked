global with sharing class PELmsEnrollmentRequestEvent {
    @InvocableMethod(Label='Enroll person in LMS Section' Description='Send an LMS Enrollment Request to Event Grid')
    global static List<AzureEventIntegration.AzureResponse> lmsEnrollmentRequest(List<PELmsEnrollmentRequestRequest> requests) {
        List<AzureEventIntegration.AzureEvent> events = new List<AzureEventIntegration.AzureEvent>();
        for(PELmsEnrollmentRequestRequest request : requests) {
            events.add(LmsEnrollmentRequest(request.type, request.loginId, request.sectionReference));
        }

        return new List<AzureEventIntegration.AzureResponse>{AzureEventIntegration.sendEvents(events, false)};
    }

    private static AzureEventIntegration.AzureEvent LmsEnrollmentRequest(String type, String loginId, String sectionReference) {
        return new AzureEventIntegration.AzureEvent(
            'lms', 
            'LmsEnrollmentRequest', 
            'csuoee/noncredit/lms', 
            new Map<String, Object>{'lms' => 'Canvas', 'loginId' => loginId, 'sectionReference' => sectionReference, 'type' => type}
        );
    }

    global class PELmsEnrollmentRequestRequest extends AzureEventIntegration.AzureRequest {
        @InvocableVariable(Required=false Description='Type of enrollment. Defaults to Student.')
        global String type = 'Student';

        @InvocableVariable(Required=true Description='Login name of the enrollment - e.g. 4LOGINID.')
        global String loginId;

        @InvocableVariable(Required=true Description='Section Reference for the enrollment.')
        global String sectionReference;

        global PELmsEnrollmentRequestRequest(){
            super(false);
        }
        global PELmsEnrollmentRequestRequest(String type, String loginId, String sectionReference) {
            super(false);
            this.type = type;
            this.loginId = loginId;
            this.sectionReference = sectionReference;
        }
    }
}