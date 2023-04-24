global with sharing class PERecordTypeRequestor {
    
    @InvocableMethod(Label='Get PE Record Types' Description='Currently supports: "Term"')
    global static List<RecordType> getPERecordTypes(List<PERecordTypeRequest> requests) {
        List<RecordType> recordTypes = new List<RecordType>();
        for(PERecordTypeRequest request : requests) {
            switch on request.recordTypeName {
                when 'Term' {
                    recordTypes.add(PEHelpers.getNoncreditTermType());
                }
                when else {
                    recordTypes.add(null);
                }
            }
        }
        return recordTypes;
    }

    global class PERecordTypeRequest {
        @InvocableVariable(Required=true Description='e.g. Term for Noncredit Term RecordType')
        global String recordTypeName;

        public PERecordTypeRequest(){}
        public PERecordTypeRequest(String recordTypeName) {
            this.recordTypeName = recordTypeName;
        }
    }

}