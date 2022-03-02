*** Settings ***
Documentation     Get data from Dana
Library           RPA.Browser.Selenium    auto_close=${FALSE}
Library           RPA.HTTP
Library           RPA.Excel.Files
Library           RPA.PDF
Library           RPA.Word.Application
Library           RPA.FileSystem
Library           RPA.Tables
Library           RPA.Robocorp.Vault

*** Variables ***
${URL}=           https://dashboard.dana.id/app/
${GLOBAL_RETRY_AMOUNT}=    3x
${GLOBAL_RETRY_INTERVAL}=    0.5s


*** Tasks ***
Get data form Dana
    Send GET request and keep checking until success
    Open browser and keep checking until success
    Open the intranet website
    Log in
    Open Disbursement
    Collect the results
    Export the table as PDF
    Export the table as Excel
    Export to Text as Variable
    Export the Balance as Text


*** Keywords ***
Send GET request and keep checking until success
    Wait Until Keyword Succeeds
    ...    ${GLOBAL_RETRY_AMOUNT}
    ...    ${GLOBAL_RETRY_INTERVAL}
    ...    Send GET request

Send GET request
    ${headers}=    Create Dictionary    Content-Type    text/plain
    ${http_response}=    GET
    ...    url=${URL}/418
    ...    params=sleep=3000
    ...    expected_status=418
    ...    headers=${headers}
    Log To Console    ${http_response.text}
    Log    ${http_response.text}

Open browser and keep checking until success
    Open Available Browser    ${URL}/200?sleep=3000
    Wait Until Keyword Succeeds
    ...    ${GLOBAL_RETRY_AMOUNT}
    ...    ${GLOBAL_RETRY_INTERVAL}
    ...    Wait Until Page Contains
    ...    200 OK
    ...    0.5s
    Capture Page Screenshot

Open the intranet website
    Open Available Browser    ${URL}

Log in
    ${secret}=    Get Secret    credentials
    Input Text    loginEmailInput    ${secret}[username]
    Input Password    //input[@type="password"]    ${secret}[password]
    Submit Form
    Wait Until Page Contains Element    id:portal

Open Disbursement
    Go To    https://dashboard.dana.id/app/dana-disbursement/account

Collect the results
    Wait Until Element Is Visible    css:div.detail-body
    Screenshot    css:div.detail-body    ${OUTPUT_DIR}${/}Dana.png

Export the table as PDF
    Wait Until Element Is Visible    css:div.detail-body
    ${dana_results_html}=    Get Element Attribute    css:div.detail-body    outerHTML
    Html To Pdf    ${dana_results_html}    ${OUTPUT_DIR}${/}dana_results.pdf

Export the table as Excel
    Wait Until Element Is Visible    css:div.detail-body
    ${text}=    Get Text    css:div.detail-body
    Create File    ${OUTPUT_DIR}${/}dana_result_excel.csv    ${text}    overwrite=True

Export to Text as Variable
    Wait Until Element Is Visible    css:div.detail-body
    ${text}=    Get Text    css:div.detail-body
    Create File    ${OUTPUT_DIR}${/}dana_result_text.txt    ${text}    overwrite=True

Export the Balance as Text
    Wait Until Element Is Visible    css:div.ant-col-lg-16
    ${text}=    Get Text    css:div.ant-col-lg-16
    Create File    ${OUTPUT_DIR}${/}dana_result_balance.txt    ${text}    overwrite=True

