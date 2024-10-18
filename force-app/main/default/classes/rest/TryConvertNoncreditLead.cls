@RestResource(urlMapping = '/noncredit/lead/convert')
global with sharing class TryConvertNoncreditLead {
    
    private static final List<String> NONCREDIT_EMAIL_FIELDS = new List<String>{'hed__AlternateEmail__c', 'csuoee__CSU_Online_Account_Email__c', 'hed__UniversityEmail__c', 'hed__WorkEmail__c'};
    /**
     * Attempts convert of Contacts using Noncredit Email Fields.
     */
    @HttpPost
    global static void attemptConvert(List<Contact> contacts) {
        ConvertResult result = CombinedFunctions.attemptConvertByEmail(contacts, NONCREDIT_EMAIL_FIELDS);

        RestHelpers.setJsonResponse(result);
    }

}