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
        if(noncreditTermRecordType == null) {
            noncreditTermRecordType = [select Id from RecordType where SobjectType = 'Account' and DeveloperName = 'University_Department' LIMIT 1];
        }

        return noncreditTermRecordType;
    }

}