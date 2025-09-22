*** Settings ***
Library    RequestsLibrary

*** Variables ***
${BASE}     http://127.0.0.1:5000/
${SESSION}        api

*** Keywords ***

Get Calculation JSON
    [Arguments]    ${num1}    ${num2}
    ${resp}=     GET    http://127.0.0.1:5000/plus/${num1}/${num2}

    # Verify the status code is 200 (OK)
    Should Be Equal    ${resp.status_code}    ${200}

    # Get the response content as a JSON object
    RETURN    ${resp.json()}



*** Test Cases ***
Getcode matches

    Create Session    ${SESSION}    ${BASE}
    ${resp}=    GET On Session    ${SESSION}    /getcode
    Should Be Equal As Integers    ${resp.status_code}    200
    ${json}=    Evaluate    $resp.json()
    Should Be Equal    ${json['code']}  SUCCESS

GET /plus/5/7 sums correctly 

    Create Session    ${SESSION}    ${BASE}
     ${resp}=     GET On Session    ${SESSION}    /plus/5/7
    Should Be Equal As Integers    ${resp.status_code}    200
    ${json}=    Evaluate    $resp.json()
    Should Be Equal As Numbers    ${json['result']}    12

GET /plus/5/6 sums correctly 

    Create Session    ${SESSION}    ${BASE}
     ${resp}=     GET On Session    ${SESSION}    /plus/5/6
    Should Be Equal As Integers    ${resp.status_code}    200
    ${json}=    Evaluate    $resp.json()
    Should Be Equal As Numbers    ${json['result']}    11

GET /plus/0/0 returns 0
    Create Session    ${SESSION}    ${BASE}
    ${resp}=    GET On Session    ${SESSION}    /plus/0/0
    Should Be Equal As Integers    ${resp.status_code}    200
    ${json}=    Evaluate    $resp.json()
    Should Be Equal As Numbers    ${json['result']}    0

GET /plus/-3/7 returns 4
    Create Session    ${SESSION}    ${BASE}
    ${resp}=    GET On Session    ${SESSION}    /plus/-3/7
    Should Be Equal As Integers    ${resp.status_code}    200
    ${json}=    Evaluate    $resp.json()
    Should Be Equal As Numbers    ${json['result']}    4