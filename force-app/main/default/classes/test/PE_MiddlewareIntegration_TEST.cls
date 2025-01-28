@IsTest
global class PE_MiddlewareIntegration_TEST {
    
    @IsTest
    private static void getNoncreditCanvasLogin() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, BaseTestUtil.getBasicMiddlewareMock('{"attributes": {"type": "lms_hed__LMS_Account__c"}, "lms_hed__Account_Owner__c": "a05VA0000089pM6YAI", "lms_hed__Primary_Login__c": "4test1", "lms_hed__LMS__c": "a05VA0000089pM6YAI"}'));

        lms_hed__LMS_Account__c result = CanvasValidation.getNoncreditCanvasLogin(new Account(hed__School_Code__c = 'learn.colostate.edu.1'));
        System.assert(result != null);

        Test.stopTest();
    }
    
    @IsTest
    private static void getNoncreditCanvasLoginFail() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, BaseTestUtil.getBasicMiddlewareMock(''));

        try {
            lms_hed__LMS_Account__c result = CanvasValidation.getNoncreditCanvasLogin(new Account(hed__School_Code__c = 'learn.colostate.edu.1'));
            System.assert(false, 'This should have errored.');
        } catch(AuraException ae) {

        }

        Test.stopTest();
    }
    
    @IsTest
    private static void getNoncreditCanvasEnrollments() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, BaseTestUtil.getBasicMiddlewareMock('[{"attributes": {"type": "lms_hed__LMS_Course_Enrollment__c"}, "lms_hed__Course_Connection__c": "a05VA0000089pM6YAI", "lms_hed__Course_Offering__c": "a05VA0000089pM6YAI", "lms_hed__LMS_Account__c": "a05VA0000089pM6YAI", "lms_hed__LMS_Course_Term__c": "a05VA0000089pM6YAI"}, {"attributes": {"type": "lms_hed__LMS_Course_Enrollment__c"}, "lms_hed__Course_Connection__c": "a05VA0000089pM6YAI", "lms_hed__Course_Offering__c": "a05VA0000089pM6YAI", "lms_hed__LMS_Account__c": "a05VA0000089pM6YAI", "lms_hed__LMS_Course_Term__c": "a05VA0000089pM6YAI"}]'));

        List<lms_hed__LMS_Course_Enrollment__c> results = CanvasValidation.getNoncreditCanvasEnrollments(new csuoee__Registration__c(csuoee__Registration_Id__c = 1));
        System.assert(results.size() == 2);

        Test.stopTest();
    }
    
    @IsTest
    private static void getNoncreditCanvasEnrollmentsFail() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, BaseTestUtil.getBasicMiddlewareMock(''));

        try {
            List<lms_hed__LMS_Course_Enrollment__c> results = CanvasValidation.getNoncreditCanvasEnrollments(new csuoee__Registration__c(csuoee__Registration_Id__c = 1));
            System.assert(false, 'This should have errored.');
        } catch(AuraException ae) {

        }

        Test.stopTest();
    }

    @IsTest
    private static void syncOpusLmsLoginId() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, BaseTestUtil.getBasicMiddlewareMock('{"attributes": {"type": "lms_hed__LMS_Account__c"}, "lms_hed__Account_Owner__c": "a05VA0000089pM6YAI", "lms_hed__Primary_Login__c": "4test1", "lms_hed__LMS__c": "a05VA0000089pM6YAI"}'));

        lms_hed__LMS_Account__c result = CanvasValidation.syncOpusLmsLoginId(new Account(hed__School_Code__c = 'learn.colostate.edu.1'));
        System.assert(result != null);

        Test.stopTest();
    }

    @IsTest
    private static void syncOpusLmsLoginIdFail() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, BaseTestUtil.getBasicMiddlewareMock(''));

        try {
            lms_hed__LMS_Account__c result = CanvasValidation.syncOpusLmsLoginId(new Account(hed__School_Code__c = 'learn.colostate.edu.1'));
            System.assert(false, 'This should have errored.');
        } catch(AuraException ae) {

        }

        Test.stopTest();
    }

    @IsTest
    private static void matchLogin() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CanvasLoginsMock());

        CanvasValidation.CanvasLogin login = CanvasValidation.matchLogin(new lms_hed__LMS_Account__c(lms_hed__Primary_Login__c = '5WINTERRK', lms_hed__LMS_External_ID__c = '229424'));
        System.assert(login != null);
        
        login = CanvasValidation.matchLogin(new lms_hed__LMS_Account__c(lms_hed__Alternate_Login__c = '5WINTERRK', lms_hed__LMS_External_ID__c = '229424'));
        System.assert(login != null);

        Test.stopTest();
    }

    class CanvasLoginsMock implements HttpCalloutMock {
        CanvasLoginsMock() {}

        public HttpResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatus('OK');
            res.setStatusCode(200);
            res.setBody('[{"id":229445,"user_id":229424,"account_id":1,"workflow_state":"active","unique_id":"winterrk","created_at":"2020-07-16T19:57:41Z","sis_user_id":"Student1462027","integration_id":null,"authentication_provider_id":null,"declared_user_type":null},{"id":229445,"user_id":229424,"account_id":1,"workflow_state":"active","unique_id":"5WINTERRK","created_at":"2020-07-16T19:57:41Z","sis_user_id":"Student1462027","integration_id":null,"authentication_provider_id":null,"declared_user_type":null}]');
            return res;
        }
    }

    @IsTest
    private static void sendPasswordResetFail() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CanvasPasswordUpdateMock());

        CanvasValidation.CanvasLogin login = new CanvasValidation.CanvasLogin();
        login.id = 229445;
        login.unique_id = '5WINTERRK';

        try {
            CanvasValidation.sendPasswordReset(login);
            System.assert(false);
        } catch(AuraHandledException ahe) {

        }

        Test.stopTest();
    }

    @IsTest
    private static void sendPasswordReset() {
        insert new csuoee__OEE_Settings__c();

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CanvasPasswordUpdateMock());

        CanvasValidation.CanvasLogin login = new CanvasValidation.CanvasLogin();
        login.id = 229445;
        login.unique_id = '5WINTERRK';

        CanvasValidation.sendPasswordReset(login);

        Test.stopTest();
    }

    @IsTest
    private static void sendGeneratedPasswordReset() {
        insert new csuoee__OEE_Settings__c(csuoee__Simple_PE_Password__c = false);

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CanvasPasswordUpdateMock());

        CanvasValidation.CanvasLogin login = new CanvasValidation.CanvasLogin();
        login.id = 229445;
        login.unique_id = '5WINTERRK';

        CanvasValidation.sendPasswordReset(login);

        Test.stopTest();
    }

    class CanvasPasswordUpdateMock implements HttpCalloutMock {
        CanvasPasswordUpdateMock() {}

        public HttpResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatus('OK');
            res.setStatusCode(200);
            res.setBody('{"id":229445,"user_id":229424,"account_id":1,"workflow_state":"active","unique_id":"5WINTERRK","created_at":"2020-07-16T19:57:41Z","sis_user_id":"Student1462027","integration_id":null,"authentication_provider_id":null,"declared_user_type":null}');
            return res;
        }
    }

    @IsTest
    private static void resetPassword() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CanvasLoginsMock());

        try {
            CanvasValidation.resetPassword(new lms_hed__LMS_Account__c(lms_hed__LMS_External_ID__c = '229424'));
            System.assert(false);
        } catch(AuraHandledException ahe) {
            // No login specified
        }

        try {
            CanvasValidation.resetPassword(new lms_hed__LMS_Account__c(lms_hed__Primary_Login__c = '5WINTERRK', lms_hed__LMS_External_ID__c = '229424'));
        } catch(AuraHandledException ahe) {
            // No settings, that's ok.
        }

        Test.stopTest();
    }

}