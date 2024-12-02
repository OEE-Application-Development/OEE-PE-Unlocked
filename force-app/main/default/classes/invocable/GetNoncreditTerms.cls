global with sharing class GetNoncreditTerms {
    
    @InvocableMethod(Label='GetNoncreditTerms' Description = 'Get top X Terms ordering by Display Order descending.' Category = 'Noncredit')
    global static List<List<hed__Term__c>> getNoncreditTermsInvocable(List<Integer> pageSize) {
        List<List<hed__Term__c>> results = new List<List<hed__Term__c>>();
        RecordType noncreditTermType = PEHelpers.getNoncreditTermType();
        for(Integer size : pagesize) {
            results.add([SELECT Id, Name, RecordType.Id, RecordType.DeveloperName, lms_hed__LMS_Reference_Code__c FROM hed__Term__c WHERE RecordTypeId = :noncreditTermType.Id ORDER BY csuoee__Display_Order__c DESC LIMIT :size]);
        }

        return results;
    }
}