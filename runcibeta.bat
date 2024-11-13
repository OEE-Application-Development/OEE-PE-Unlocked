REM Create scratch org w/ sf since CCI fails now.
call sf org create scratch -a OEE-PE-Unlocked__beta -f orgs/beta.json -w 10 -y 1

REM Import newly created org into CCI for setup commands.
start "CCI Import" /wait /b cci org import OEE-PE-Unlocked__beta beta

REM Run Beta tests
start "CCI ci_beta" /wait /b cci flow run ci_beta --org beta