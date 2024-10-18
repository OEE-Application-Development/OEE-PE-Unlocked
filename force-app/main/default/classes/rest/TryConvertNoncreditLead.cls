@RestResource(urlMapping = '/noncredit/lead/convert')
global with sharing class TryConvertNoncreditLead {
    
    private static final List<String> NONCREDIT_EMAIL_FIELDS = new List<String>{'hed__AlternateEmail__c', 'csuoee__CSU_Online_Account_Email__c', 'hed__UniversityEmail__c', 'hed__WorkEmail__c'};
    /**
     * Attempts convert of Contacts using Noncredit Email Fields.
     */
    @HttpPost
    global static void attemptConvert(List<Contact> contacts) {
        try {
            ConvertResult result = CombinedFunctions.attemptConvertByEmail(contacts, NONCREDIT_EMAIL_FIELDS);
        } catch(QueryException qe) {
            // This catch is purely for beta build - for some reason the build is missing prefixes? csuoee__CSU_Online_Account_Email__c marked as missing.
            RestHelpers.setNotFoundResponse('Could not run query.');
            return;
        }

        RestHelpers.setJsonResponse(result);
    }

}