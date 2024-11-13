global with sharing class CanvasValidation {
    
    /**
     * /salesforce/action/canvas/{studentId}/login
     */
    @AuraEnabled
    public static lms_hed__LMS_Account__c getNoncreditCanvasLogin(Account account) {
        String path = '/salesforce/action/canvas/'+account.hed__School_Code__c+'/login';
        HttpResponse response = MiddlewareIntegration.sendMiddlewareRequest('GET', path);
        if(response.getStatusCode() == 404) return null;
        try {
            return(lms_hed__LMS_Account__c)JSON.deserialize(response.getBody(), SObject.class);
        } catch (Exception e) {
            throw new AuraException(e.getMessage());
        }
    }
    
    /**
     * /salesforce/action/canvas/{studentId}/login
     */
    @AuraEnabled
    public static List<lms_hed__LMS_Course_Enrollment__c> getNoncreditCanvasEnrollments(csuoee__Registration__c registration) {
        String path = '/salesforce/action/canvas/'+registration.csuoee__Registration_Id__c+'/enrollments';
        HttpResponse response = MiddlewareIntegration.sendMiddlewareRequest('GET', path);
        if(response.getStatusCode() == 404) return null;
        try {
            return(List<lms_hed__LMS_Course_Enrollment__c>)JSON.deserialize(response.getBody(), List<SObject>.class);
        } catch (Exception e) {
            throw new AuraException(e.getMessage());
        }
    }

}