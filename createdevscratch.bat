REM Create scratch org w/ sf since CCI fails now.
call sf org create scratch -a OEE-PE-Unlocked__dev -f orgs/dev.json -w 10

REM Set newly created scratch org as default org.
call sf config set target-org OEE-PE-Unlocked__dev

REM Import newly created org into CCI for setup commands.
start "CCI Import" /wait /b cci org import OEE-PE-Unlocked__dev dev

REM dev_org and all that good stuff
start "Org Setup" /wait /b cci flow run dev_org --org dev

REM Load Sample Data
call bulk/loadAll.bat

REM Open the Org & Quit Script
start "CCI Org Browser" /wait /b cci org browser dev
exit