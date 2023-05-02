global with sharing class PERecordTypeRequestor {
    
    @InvocableMethod(Label='Get PE Record Types' Description='Currently supports: "Term", "Department"')
    global static List<RecordType> getPERecordTypes(List<PERecordTypeRequest> requests) {
        List<RecordType> recordTypes = new List<RecordType>();
        for(PERecordTypeRequest request : requests) {
            try {
                switch on request.recordTypeName {
                    when 'Term' {
                        recordTypes.add(PEHelpers.getNoncreditTermType());
                    }
                    when 'Educational Institution' {
                        recordTypes.add(PEHelpers.getNoncreditInstitutionType());
                    }
                    when 'Department' {
                        recordTypes.add(PEHelpers.getNoncreditDeptRecordType());
                    }
                    when else {
                        recordTypes.add(null);
                    }
                }
            } catch(System.QueryException qe) {
                recordTypes.add(null);
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