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

        lms_hed__LMS_Account__c result = CanvasValidation.syncOpusLmsLoginId(new Account(hed__School_Code__c = 'learn.colostate.edu.1'));
        System.assert(result != null);

        Test.stopTest();
    }

}