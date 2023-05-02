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

}