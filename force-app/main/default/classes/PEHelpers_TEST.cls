@IsTest
private class PEHelpers_TEST {
    
    @IsTest
    private void recordTypeTest() {
        List<RecordType> types = PERecordTypeRequest.getPERecordTypes(new List<PERecordTypeRequest>{new PERecordTypeRequest('Term'), new PERecordTypeRequest('')});

        System.assertEquals(2, types.size());
        System.assert(types.get(0) != null);
        System.assert(types.get(1) == null);
    }

}