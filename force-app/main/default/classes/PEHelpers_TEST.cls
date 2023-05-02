@IsTest
private class PEHelpers_TEST {
    
    @IsTest
    private static void recordTypeTest() {
        List<RecordType> types = PERecordTypeRequestor.getPERecordTypes(new List<PERecordTypeRequestor.PERecordTypeRequest>{new PERecordTypeRequestor.PERecordTypeRequest('Term'), new PERecordTypeRequestor.PERecordTypeRequest('Department'), new PERecordTypeRequestor.PERecordTypeRequest('')});

        System.assertEquals(2, types.size());
        System.assert(types.get(0) != null);
        System.assert(types.get(2) == null);
    }

}