global with sharing class PELmsEnrollmentCompleteEvent {
    @InvocableMethod(Label='Student Enrolled in LMS Section' Description='Send an LMS Enrollment Complete to Event Grid')
    global static List<AzureEventIntegration.AzureResponse> lmsEnrollmentComplete(List<PELmsEnrollmentCompleteRequest> requests) {
        List<AzureEventIntegration.AzureEvent> events = new List<AzureEventIntegration.AzureEvent>();
        for(PELmsEnrollmentCompleteRequest request : requests) {
            events.add(LmsEnrollmentComplete(request.lmsId, request.loginId, request.sectionReference, request.link));
        }

        return new List<AzureEventIntegration.AzureResponse>{AzureEventIntegration.sendEvents(events, false)};
    }

    private static AzureEventIntegration.AzureEvent LmsEnrollmentComplete(String lmsId, String loginId, String sectionReference, String link) {
        return new AzureEventIntegration.AzureEvent(
            'lms', 
            'LmsEnrollmentComplete', 
            'csuoee/noncredit/lms', 
            new Map<String, Object>{'lmsId' => lmsId, 'lms' => 'Canvas', 'loginId' => loginId, 'sectionReference' => sectionReference, 'link' => link}
        );
    }

    global class PELmsEnrollmentCompleteRequest extends AzureEventIntegration.AzureRequest {
        @InvocableVariable(Required=false Description='Canvas ID of the enrollment.')
        global String lmsId;

        @InvocableVariable(Required=true Description='Login name of the enrollment - e.g. 4LOGINID.')
        global String loginId;

        @InvocableVariable(Required=true Description='Section Reference for the enrollment.')
        global String sectionReference;

        @InvocableVariable(Required=true Description='Link to the enrollment e.g. https://colostate.test.instructure.com/courses/12345')
        global String link;

        global PELmsEnrollmentCompleteRequest(){
            super(false);
        }
        global PELmsEnrollmentCompleteRequest(String lmsId, String loginId, String sectionReference, String link) {
            super(false);
            this.lmsId = lmsId;
            this.loginId = loginId;
            this.sectionReference = sectionReference;
            this.link = link;
        }
    }
}