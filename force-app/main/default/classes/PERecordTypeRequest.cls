global with sharing class PERecordTypeRequest {
    
    @InvocableMethod(Label='Handle Student Enrollment' Description='Creates or updates an enrollment for a student.')
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

        public EnrollmentRequest(){}
        public EnrollmentRequest(String recordTypeName) {
            this.recordTypeName = recordTypeName;
        }
    }

}