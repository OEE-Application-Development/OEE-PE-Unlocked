global with sharing class PEHandleEnrollments {
    @InvocableMethod(Label='Handle Student Enrollment' Description='Creates or updates an enrollment for a student.')
    global static List<hed__Course_Enrollment__c> handleStudentEnrollment(List<CombinedFunctions.EnrollmentRequest> requests) {
        List<hed__Course_Enrollment__c> returnList = new List<hed__Course_Enrollment__c>();
        for(CombinedFunctions.EnrollmentRequest request : requests) {
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

        return CombinedFunctions.handleStudentEnrollment(contact, reference, isDrop);
    }

}