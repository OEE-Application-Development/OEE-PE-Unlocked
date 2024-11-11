REM Organization Accounts
call sf data export bulk --query-file "bulk/query/InstitutionAccounts.soql" --output-file "bulk/data/InstitutionAccounts.csv" -w 10
call sf data export bulk --query-file "bulk/query/CollegeAccounts.soql" --output-file "bulk/data/CollegeAccounts.csv" -w 10

REM PE Account/Contact Pull -- Get Accounts / Link Contacts / Re-update primary Contact on Account
call sf data export bulk --query-file "bulk/query/PEAccounts.soql" --output-file "bulk/data/PEAccounts.csv" -w 10
call sf data export bulk --query-file "bulk/query/PEContacts.soql" --output-file "bulk/data/PEContacts.csv" -w 10
call sf data export bulk --query-file "bulk/query/PEAccountsPrimaryContact.soql" --output-file "bulk/data/PEAccountsPrimaryContact.csv" -w 10

REM EDA Objects Terms/Courses/Course Offerings/Enrollments
call sf data export bulk --query-file "bulk/query/NCTerms.soql" --output-file "bulk/data/NCTerms.csv" -w 10
call sf data export bulk --query-file "bulk/query/NCCourses.soql" --output-file "bulk/data/NCCourses.csv" -w 10
call sf data export bulk --query-file "bulk/query/NCSections.soql" --output-file "bulk/data/NCSections.csv" -w 10
call sf data export bulk --query-file "bulk/query/NCStudentEnrollments.soql" --output-file "bulk/data/NCStudentEnrollments.csv" -w 10