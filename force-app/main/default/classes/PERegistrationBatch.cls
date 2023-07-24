global with sharing class PERegistrationBatch {

    global static List<AzureEventIntegration.AzureResponse> createRegistrationBatch(List<PERegistrationBatchRequest> requests) {
        List<AzureEventIntegration.AzureEvent> events = new List<AzureEventIntegration.AzureEvent>();
        for(PERegistrationBatchRequest batch : requests) {
            events.add(convertRegistrationBatch(batch));
        }
        return new List<AzureEventIntegration.AzureResponse>{AzureEventIntegration.sendEvents(events, false)};
    }

    private static AzureEventIntegration.AzureEvent convertRegistrationBatch(PERegistrationBatchRequest batch) {
        List<Map<String, String>> registrations = new List<Map<String, String>>();
        for(PERegistrationBatchRequestLineItem lineItem : batch.lineItems) {
            registrations.add(new Map<String, String> {'offeringReference' => lineItem.offeringReference, 'studentId' => lineItem.userId, 'lineItemId' => lineItem.id});
        }
        return new AzureEventIntegration.AzureEvent(
            'registration', 
            'RegistrationBatch', 
            'csuoee/noncredit/registration', 
            new Map<String, Object>{'id' => batch.registrationBatchId, 'provider' => batch.sponsor, 'amount' => batch.transferAmount, 'registration' => registrations}
        );
    }

    global class PERegistrationBatchRequestLineItem {
        @InvocableVariable(Required=false Description='Id generated here for reference externally.')
        global String id;

        @InvocableVariable(Required=true Description='User Id (Noncredit ID) of the Contact.')
        global String userId;

        @InvocableVariable(Required=true Description='Reference of the offering.')
        global String offeringReference;

    }

    global class PERegistrationBatchRequest extends AzureEventIntegration.AzureRequest {

        @InvocableVariable(Required=true Description='Id from the Registration Batch.')
        global Id registrationBatchId;

        @InvocableVariable(Required=false Description='Identifier (noncredit id / name) of a sponsor.')
        global String sponsor;

        @InvocableVariable(Required=true Description='% value of the payment transfer')
        global Double transferAmount;

        @InvocableVariable(Required=true Description='Actual line items.')
        global List<PERegistrationBatchRequestLineItem> lineItems;

        global PERegistrationBatchRequest() {
            super(false);
        }

    }
}