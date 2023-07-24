trigger CSUOEE_PE_RegBatchCreate on csuoee__Registration_Batch__c (after update) {
    Set<Id> batchIds = new Set<Id>();
    for(csuoee__Registration_Batch__c batch : (List<csuoee__Registration_Batch__c>) Trigger.new) {
        if(!batch.csuoee__Is_Ready__c) continue;
        if(!batch.csuoee__Contains_PE_Requests__c) continue;

        batchIds.add(batch.Id);
    }

    Map<Id, PERegistrationBatch.PERegistrationBatchRequest> batchMap = new Map<Id, PERegistrationBatch.PERegistrationBatchRequest>();
    for(csuoee__Registration_Request__c request : [select Id, csuoee__Registration_Batch__c, csuoee__Is_Credit__c, csuoee__Student__r.csuoee__Noncredit_ID__c, csuoee__Student__r.Email, csuoee__Course_Offering__r.lms_hed__LMS_Reference_Code__c, csuoee__Registration_Batch__r.csuoee__Default_Transfer__c, csuoee__Registration_Batch__r.csuoee__Sponsor__r.hed__School_Code__c, csuoee__Registration_Batch__r.csuoee__Sponsor__r.Name, csuoee__Line_Item_ID__c from csuoee__Registration_Request__c where csuoee__Registration_Batch__c in :batchIds and csuoee__Is_Credit__c = false]) {
        if(request.csuoee__Is_Credit__c) continue;
        
        PERegistrationBatch.PERegistrationBatchRequest batch = batchMap.get(request.csuoee__Registration_Batch__c);
        if(batch == null) {
            batch = new PERegistrationBatch.PERegistrationBatchRequest();
            
            batch.registrationBatchId = request.csuoee__Registration_Batch__c;
            if(String.isNotBlank(request.csuoee__Registration_Batch__r.csuoee__Sponsor__r.hed__School_Code__c)) {
                batch.sponsor = request.csuoee__Registration_Batch__r.csuoee__Sponsor__r.hed__School_Code__c;
            } else {
                batch.sponsor = request.csuoee__Registration_Batch__r.csuoee__Sponsor__r.Name;
            }
            batch.transferAmount = request.csuoee__Registration_Batch__r.csuoee__Default_Transfer__c;

            batch.lineItems = new List<PERegistrationBatch.PERegistrationBatchRequestLineItem>();
            batchMap.put(request.csuoee__Registration_Batch__c, batch);
        }

        PERegistrationBatch.PERegistrationBatchRequestLineItem lineItem = new PERegistrationBatch.PERegistrationBatchRequestLineItem();
        lineItem.id = request.csuoee__Line_Item_ID__c;
        lineItem.offeringReference = request.csuoee__Course_Offering__r.lms_hed__LMS_Reference_Code__c;
        if(String.isNotBlank(request.csuoee__Student__r.csuoee__Noncredit_ID__c)) {
            lineItem.userId = request.csuoee__Student__r.csuoee__Noncredit_ID__c;
        } else {
            lineItem.userId = request.csuoee__Student__r.Email;
        }

        batch.lineItems.add(lineItem);
    }

    PERegistrationBatch.createRegistrationBatch(batchMap.values());
}