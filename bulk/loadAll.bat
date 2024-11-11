REM Organization Accounts
call sf data import bulk -s Account --file "bulk/data/InstitutionAccounts.csv" -w 10
call sf apex run --file bulk/recordtypes/setInstitutionRecordType.apex

call sf data import bulk -s Account --file "bulk/data/CollegeAccounts.csv" -w 10
call sf apex run --file bulk/recordtypes/setCollegeRecordType.apex

REM PE Account/Contact Pull -- Get Accounts / Link Contacts / Re-update primary Contact on Account
call sf data import bulk -s Account --file "bulk/data/PEAccounts.csv" -w 10
call sf apex run --file bulk/recordtypes/setPEAccountRecordType.apex
call sf data import bulk -s Contact --file "bulk/data/PEContacts.csv" -w 10
call sf data upsert bulk -s Account -i hed__School_Code__c --file "bulk/data/PEAccountsPrimaryContact.csv" -w 10

REM EDA Objects Terms/Courses/Course Offerings/Enrollments
call sf data import bulk -s hed__Term__c --file "bulk/data/NCTerms.csv" -w 10
call sf apex run --file bulk/recordtypes/setNCTermRecordType.apex
call sf data import bulk -s hed__Course__c --file "bulk/data/NCCourses.csv" -w 10
call sf apex run --file bulk/recordtypes/setNCCourseRecordType.apex
call sf data import bulk -s hed__Course_Offering__c --file "bulk/data/NCSections.csv" -w 10
call sf apex run --file bulk/recordtypes/setStudentEnrollmentRecordType.apex
call sf data import bulk -s hed__Course_Enrollment__c --file "bulk/data/NCStudentEnrollments.csv" -w 10