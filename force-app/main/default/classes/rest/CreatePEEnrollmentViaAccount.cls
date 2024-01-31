@RestResource(urlMapping = '/pe/registration/enroll')
global class CreatePEEnrollmentViaAccount {

    @HttpPost
    global static Map<String, String> createEnrollment(hed__Course_Enrollment__c courseConnection, Account account) {
        List<Account> accounts;
        try {
            accounts = [select Id, hed__Primary_Contact__c from Account where Id = :account.Id or hed__School_Code__c = :account.hed__School_Code__c];
        } catch(QueryException qe) {
            return new Map<String, String>{'success' => 'false', 'message' => qe.getMessage()};
        }
        if(accounts.size() == 0) return new Map<String, String>{'success' => 'false', 'message' => 'Account not found!'};
        if(accounts.size() > 1) return new Map<String, String>{'success' => 'false', 'message' => 'Multiple accounts match! (Please only send Id or hed__School_Code__c)'};

        if(accounts.get(0).hed__Primary_Contact__c == null) return new Map<String, String>{'success' => 'false', 'message' => 'This account is not associated with a Contact!'};

        courseConnection.hed__Contact__c = accounts.get(0).hed__Primary_Contact__c;

        try {
            upsert courseConnection csuoee__PE_Enrollment_Reference__c;
        } catch(DmlException de) {
            return new Map<String, String>{'success' => 'false', 'message' => de.getMessage()};
        }
        return new Map<String, String>{'success' => 'true', 'message' => 'Enrollment Upserted.', 'Id' => courseConnection.Id};
    }
    
}