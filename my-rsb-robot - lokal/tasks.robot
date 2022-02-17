*** Settings ***
Documentation     Get data from Dana
Library           RPA.Browser.Selenium    auto_close=${FALSE}
Library           RPA.HTTP
Library           RPA.Excel.Files
Library           RPA.PDF
Library           RPA.Word.Application
Library           RPA.FileSystem
Library           RPA.Tables

*** Tasks ***
Get data form Dana
    Open the intranet website
    Log in
    Open Disbursement
    Collect the results
    Export the table as PDF
    Export the table as Excel
    Export to Text as Variable
    Export the Balance as Text

*** Keywords ***
Open the intranet website
    Open Available Browser    https://dashboard.dana.id/app/

Log in
    Input Text    loginEmailInput    testingmp@mailinator.com
    Input Password    //input[@type="password"]    !Password01
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

Input to Command Prompt

