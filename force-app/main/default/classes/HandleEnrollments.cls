global with sharing class HandleEnrollments {
    @InvocableMethod(Label='Handle Student Enrollment' Description='Creates or updates an enrollment for a student.')
    global static List<hed__Course_Enrollment__c> handleStudentEnrollment(List<EnrollmentRequest> requests) {
        List<hed__Course_Enrollment__c> returnList = new List<hed__Course_Enrollment__c>();
        for(EnrollmentRequest request : requests) {
            try {
                returnList.add(handleEnrollment(request.userId, request.offeringReference, request.isDrop));
            } catch(Exception e) {
                returnList.add(null);
            }
        }
        return returnList;
    }

    private static hed__Course_Enrollment__c handleEnrollment(String noncreditId, String reference, Boolean isDrop) {
        Contact contact = [select Id from Contact where csuoee__Noncredit_ID__c = :noncreditId LIMIT 1];
        if(contact == null) return null;

        hed__Course_Offering__c offering = null;
        try {
            offering = [select Id from hed__Course_Offering__c where lms_hed__LMS_Reference_Code__c = :reference LIMIT 1];
        } catch(QueryException qe) {
            return null;
        }

        hed__Course_Enrollment__c enrollment;
        hed__Course_Enrollment__c existing;
        try {
            existing = [Select Id, hed__Status__c from hed__Course_Enrollment__c where hed__Contact__c = :contact.Id and hed__Course_Offering__c = :offering.Id LIMIT 1];
        } catch(QueryException qe) {
            if(isDrop) return null;// Nothing to undo
            existing = null;
        }
        if(existing == null) {
            enrollment = new hed__Course_Enrollment__c(hed__Contact__c = contact.Id, hed__Course_Offering__c = offering.Id, hed__Status__c = 'Enrolled');
            insert enrollment;
        } else {
            enrollment = existing;
            if(isDrop) {
                enrollment.hed__Status__c = 'Withdrew';
            } else {
                enrollment.hed__Status__c = 'Enrolled';
            }

            update enrollment;
        }

        return enrollment;
    }

    global class EnrollmentRequest {
        @InvocableVariable(Required=true Description='User Id (Noncredit ID) of the Contact.')
        global String userId;

        @InvocableVariable(Required=true Description='Reference of the offering.')
        global String offeringReference;

        @InvocableVariable(Required=false Description='Is this a drop instead of a confirm?')
        global Boolean isDrop = false;

        public EnrollmentRequest(){}
        public EnrollmentRequest(String userId, String offeringReference, Boolean isDrop) {
            this.userId = userId;
            this.offeringReference = offeringReference;
            this.isDrop = isDrop;
        }
    }

}