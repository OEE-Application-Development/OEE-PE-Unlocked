@IsTest
private class PEHelpers_TEST {
    
    @IsTest
    private static void recordTypeTest() {
        List<RecordType> types = PERecordTypeRequestor.getPERecordTypes(new List<PERecordTypeRequestor.PERecordTypeRequest>{new PERecordTypeRequestor.PERecordTypeRequest('Term'), new PERecordTypeRequestor.PERecordTypeRequest('Department'), new PERecordTypeRequestor.PERecordTypeRequest('Educational Institution'), new PERecordTypeRequestor.PERecordTypeRequest('')});

        System.assertEquals(4, types.size());
        System.assert(types.get(0) != null);
        System.assert(types.get(3) == null);
    }

}