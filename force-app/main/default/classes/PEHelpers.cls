global with sharing class PEHelpers {

    global static RecordType noncreditTermRecordType = null;
    global static RecordType getNoncreditTermType() {
        if(noncreditTermRecordType == null) {
            noncreditTermRecordType = [select Id from RecordType where NamespacePrefix = 'csuoee' and SobjectType = 'hed__Term__c' and DeveloperName = 'Noncredit' LIMIT 1];
        }

        return noncreditTermRecordType;
    }

}