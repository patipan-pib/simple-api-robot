*** Settings ***
Library    RequestsLibrary

*** Variables ***
${BASE}           http://vm3.local
${EXPECT_CODE}    ABC123

*** Test Cases ***
Ping health
    Create Session    api    ${BASE}
    ${resp}=    GET    api    /healthz
    Should Be Equal As Integers    ${resp.status_code}    200

Getcode matches
    Create Session    api    ${BASE}
    ${resp}=    GET    api    /getcode
    Should Be Equal As Integers    ${resp.status_code}    200
    ${json}=    Evaluate    ${resp}.json()    modules=requests
    Should Be Equal    ${json['code']}    ${EXPECT_CODE}
