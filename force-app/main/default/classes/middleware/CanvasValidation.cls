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
    public static List<lms_hed__LMS_Course_Enrollment__c> getNoncreditCanvasEnrollments(csuoee__Registration__c reg) {
        String path = '/salesforce/action/canvas/'+reg.csuoee__Registration_Id__c+'/enrollments';
        HttpResponse response = MiddlewareIntegration.sendMiddlewareRequest('GET', path);
        if(response.getStatusCode() == 404) return null;
        try {
            return(List<lms_hed__LMS_Course_Enrollment__c>)JSON.deserialize(response.getBody(), List<SObject>.class);
        } catch (Exception e) {
            throw new AuraException(e.getMessage());
        }
    }

    /**
     * /salesforce/action/canvas/{studentId}/opus/sync
     */
    @AuraEnabled
    public static lms_hed__LMS_Account__c syncOpusLmsLoginId(Account account) {
        String path = '/salesforce/action/canvas/'+account.hed__School_Code__c+'/opus/sync';
        HttpResponse response = MiddlewareIntegration.sendMiddlewareRequest('POST', path);
        if(response.getStatusCode() != 200) return null;
        try {
            return (lms_hed__LMS_Account__c)JSON.deserialize(response.getBody(), SObject.class);
        } catch (Exception e) {
            throw new AuraException(e.getMessage());
        }
    }

    @AuraEnabled
    public static String resetPassword(lms_hed__LMS_Account__c canvasAccount) {
        if(canvasAccount.lms_hed__LMS_External_ID__c == null) throw new AuraHandledException('lms_hed__LMS_External_ID__c not set on lms_hed__LMS_Account__c.');
        CanvasLogin login = matchLogin(canvasAccount);
        if(login == null) {
            throw new AuraHandledException('Could not find '+login+ 'in Canvas!');
        }

        return sendPasswordReset(login);
    }

    public static CanvasLogin matchLogin(lms_hed__LMS_Account__c canvasAccount) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:can_hed__Canvas/api/v1/users/'+canvasAccount.lms_hed__LMS_External_ID__c+'/logins');
        request.setHeader('Content-Type', 'application/json');
        request.setMethod('GET');
        String body;
        try {
            body = http.send(request).getBody();
        } catch (CalloutException ce) {
            throw new AuraHandledException('Canvas Credentials are missing or not configured correctly. Please refer to Canvas Home Page to see how to set it up. '+ce.getMessage());
        }

        String loginToReset;
        if(canvasAccount.lms_hed__Primary_Login__c != null && (canvasAccount.lms_hed__Primary_Login__c.startsWith('4') || canvasAccount.lms_hed__Primary_Login__c.startsWith('5'))) {
            loginToReset = canvasAccount.lms_hed__Primary_Login__c;
        } else if(canvasAccount.lms_hed__Alternate_Login__c != null && (canvasAccount.lms_hed__Alternate_Login__c.startsWith('4') || canvasAccount.lms_hed__Alternate_Login__c.startsWith('5'))) {
            loginToReset = canvasAccount.lms_hed__Alternate_Login__c;
        } else {
            throw new AuraHandledException('Could not determine PE login on Account.');
        }

        CanvasLogin login = null;
        List<CanvasLogin> logins = (List<CanvasLogin>)JSON.deserialize(body, List<CanvasLogin>.class);
        for(CanvasLogin found : logins) {
            if(found.unique_id.equals(loginToReset)) {
                login = found;
                break;
            }
        }

        return login;
    }

    public static String sendPasswordReset(CanvasLogin login) {
        Http http = new Http();
        Boolean useSimple;
        try {
            useSimple = [SELECT csuoee__Simple_PE_Password__c FROM csuoee__OEE_Settings__c LIMIT 1].csuoee__Simple_PE_Password__c;
        } catch(QueryException qe) {
            throw new AuraHandledException('csuoee__OEE_Settings__c is missing!');
        }
        
        String newPassword;
        if(useSimple) {
            newPassword = login.unique_id;
        } else {
            newPassword = OEEPassword.generatePassword(16);
        }

        HttpRequest updateRequest = new HttpRequest();
        updateRequest.setEndpoint('callout:can_hed__Canvas/api/v1/accounts/1/logins/'+login.id.toString());
        updateRequest.setHeader('Content-Type', 'application/json');
        updateRequest.setMethod('PUT');
        updateRequest.setBody('{"login": {"password":"'+newPassword+'"}}');
        try {
            // Ensure it was successful by attempting a deserialize
            login = (CanvasLogin)JSON.deserialize(http.send(updateRequest).getBody(), CanvasLogin.class);
        } catch (CalloutException ce) {
            throw new AuraHandledException('Canvas Credentials are missing or not configured correctly. Please refer to Canvas Home Page to see how to set it up. '+ce.getMessage());
        }

        return newPassword;
    }

    public class CanvasLogin {

        public Long id;
        public Long user_id;
        public String workflow_state;
        public String unique_id;
        public String sis_user_id;

    }

}