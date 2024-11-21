global with sharing class ImportRegistration {

    @InvocableMethod(Label='Import Registration' Description = 'Given a registration with csuoee__Registration_Id__c set, run import from middleware.' Category = 'Opus')
    global static List<csuoee__Registration__c> queryRegistrationsInvocable(List<csuoee__Registration__c> registrations) {
        List<csuoee__Registration__c> results = new List<csuoee__Registration__c>();
        for(csuoee__Registration__c reg : registrations) {
            results.add(RegistrationValidation.validateRegistration(reg));
        }
        return results;
    }

}