public with sharing class AzureEventIntegration {
    
    private static Http http = new Http();
    private static HTTPResponse sendEvent(AzureEvent event) {
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:Azure_PE_Creds');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');

        request.setBody(JSON.serialize(event));
        return http.send(request);
    }

    @InvocableMethod(Label='Unenroll Student from Section' Description='Sends unenroll request')
    public static Boolean unenrollStudent() {

    }

    @InvocableMethod(Label='Enroll Student in Section' Description='Sends confirmation request')
    public static Boolean enrollStudent() {

    }

    public static class AzureEvent {
        String id = (new Auth.JWT()).get;
        String topic;
        String eventType;
        String subject;
        Calendar eventTime = Calendar.getInstance();
        Map<String, Object> data;
        String dataVersion = '1.0';

        public AzureEvent(){}
        private AzureEvent(String topic, String eventType, String subject, Map<String, Object> data) {
            this.topic = topic;
            this.eventType = eventType;
            this.subject = subject;
            this.data = data;
        }

        public static AzureEvent ConfirmedEvent(String studentId, String sectionReference) {
            return new AzureEvent(
                '', 
                'Confirmed', 
                '', 
                new Map<String, Object>{'studentId' => studentId, 'sectionReference' => sectionReference}
            );
        }

    }

}