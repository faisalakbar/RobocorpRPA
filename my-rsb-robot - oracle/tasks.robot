*** Settings ***
Documentation     Template robot main suite.
Library           RPA.Browser.Selenium
Library           DatabaseLibrary

*** Variables ***
${username_oracle}    C##hr
${password_oracle}    oracle
${username_dana}    testingmp@mailinator.com
${password_dana}    !Password01
${DB_CONNECT_STRING} =    '${username_oracle}/${password_oracle}@(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=127.0.0.1)(PORT=1521))(CONNECT_DATA=(SERVER=DEDICATED)(SERVICE_NAME=XE)))'

*** Tasks ***
Get Balance and Insert to Table
    Open the intranet website
    Log in
    Open Disbursement
    Insert Balance
    Connect
    Disconnect

*** Keywords ***
Open the intranet website
    Open Available Browser    https://dashboard.dana.id/app/

Log in
    Input Text    loginEmailInput    ${username_dana}
    Input Password    //input[@type="password"]    ${password_dana}
    Submit Form
    Wait Until Page Contains Element    id:portal

Open Disbursement
    Go To    https://dashboard.dana.id/app/dana-disbursement/account

Insert Balance
    Wait Until Element Is Visible    css:div.ant-row:nth-child(3) .value-info
    ${V_BALANCE}=    Get Text    css:div.ant-row:nth-child(3) .value-info
    #Log    ${V_BALANCE}
    Connect
    Execute SQL String    insert into test_rpa (balance, tgl_check) values (REPLACE(SUBSTR('${V_BALANCE}', 3),'.',null), sysdate)
    @{queryResults}    Query    select * from test_rpa
    Log Many    @{queryResults}
    Disconnect

Connect
    connect to database using custom params    cx_Oracle    ${DB_CONNECT_STRING}

Disconnect
    disconnect from database
    Log    Done.
