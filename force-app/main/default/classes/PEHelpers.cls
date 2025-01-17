global with sharing class PEHelpers {

    global static RecordType noncreditTermRecordType = null;
    global static RecordType getNoncreditTermType() {
        if(noncreditTermRecordType == null) {
            noncreditTermRecordType = [select Id from RecordType where NamespacePrefix = 'csuoee' and SobjectType = 'hed__Term__c' and DeveloperName = 'Noncredit' LIMIT 1];
        }

        return noncreditTermRecordType;
    }

    global static RecordType noncreditDeptRecordType = null;
    global static RecordType getNoncreditDeptRecordType() {
        if(noncreditDeptRecordType == null) {
            noncreditDeptRecordType = [select Id from RecordType where SobjectType = 'Account' and DeveloperName = 'University_Department' LIMIT 1];
        }

        return noncreditDeptRecordType;
    }

    global static RecordType noncreditInstitutionType = null;
    global static RecordType getNoncreditInstitutionType() {
        if(noncreditInstitutionType == null) {
            noncreditInstitutionType = [select Id from RecordType where SobjectType = 'Account' and DeveloperName = 'Educational_Institution' LIMIT 1];
        }

        return noncreditInstitutionType;
    }

    global static RecordType noncreditStudentEnrollmentRecordType = null;
    global static RecordType getNoncreditStudentEnrollmentRecordType() {
        if(noncreditStudentEnrollmentRecordType == null) {
            noncreditStudentEnrollmentRecordType = [select Id from RecordType where SobjectType = 'hed__Course_Enrollment__c' and DeveloperName = 'Student' LIMIT 1];
        }

        return noncreditStudentEnrollmentRecordType;
    }

    global static RecordType noncreditPendingStudentEnrollmentRecordType = null;
    global static RecordType getNoncreditPendingStudentEnrollmentRecordType() {
        if(noncreditPendingStudentEnrollmentRecordType == null) {
            noncreditPendingStudentEnrollmentRecordType = [select Id from RecordType where SobjectType = 'hed__Course_Enrollment__c' and DeveloperName = 'Student_Pending' LIMIT 1];
        }

        return noncreditPendingStudentEnrollmentRecordType;
    }

    global static RecordType noncreditInstructorEnrollmentRecordType = null;
    global static RecordType getNoncreditInstructorEnrollmentRecordType() {
        if(noncreditInstructorEnrollmentRecordType == null) {
            noncreditInstructorEnrollmentRecordType = [select Id from RecordType where SobjectType = 'hed__Course_Enrollment__c' and DeveloperName = 'Faculty' LIMIT 1];
        }

        return noncreditInstructorEnrollmentRecordType;
    }

    global static RecordType noncreditAccountRecordType = null;
    global static RecordType getNoncreditAccountRecordType() {
        if(noncreditAccountRecordType == null) {
            noncreditAccountRecordType = [select Id from RecordType where SobjectType = 'Account' and DeveloperName = 'PE_Account' LIMIT 1];
        }

        return noncreditAccountRecordType;
    }

}