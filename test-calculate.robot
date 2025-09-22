*** Settings ***
Library           RequestsLibrary
Library           Collections
Suite Setup       Create Session    api    ${BASE}
Suite Teardown    Delete All Sessions
Test Teardown     Run Keyword If Test Failed    Log Response If Any

*** Variables ***
# ปรับ BASE และ EXPECT_CODE ตามสภาพแวดล้อมจริง
${BASE}           http://vm3.local
${EXPECT_CODE}    ABC123

# คีย์ชื่อ session
${SESSION}        api

*** Test Cases ***
GET /getcode returns expected teacher code
    [Documentation]    ตรวจว่า /getcode ส่ง 200 และได้ code ตามที่ผู้สอนกำหนด
    ${resp}=           GET    ${SESSION}    /getcode
    Should Be Status   ${resp}    200
    ${json}=           To JSON   ${resp}
    Dictionary Should Contain Key    ${json}    code
    Should Be Equal    ${json['code']}    ${EXPECT_CODE}

GET /plus sums integers correctly
    [Documentation]    ตรวจ /plus ด้วยเลขจำนวนเต็ม a=5, b=7 ต้องได้ sum=12
    ${resp}=           GET    ${SESSION}    /plus    params=a=5&b=7
    Should Be Status   ${resp}    200
    ${json}=           To JSON   ${resp}
    Should Be Equal As Numbers    ${json['a']}    5
    Should Be Equal As Numbers    ${json['b']}    7
    Should Be Equal As Numbers    ${json['sum']}  12

GET /plus sums floats correctly
    [Documentation]    ตรวจ /plus ด้วยเลขทศนิยม a=1.5, b=2.25 ต้องได้ sum=3.75
    ${resp}=           GET    ${SESSION}    /plus    params=a=1.5&b=2.25
    Should Be Status   ${resp}    200
    ${json}=           To JSON   ${resp}
    Should Be Equal As Numbers    ${json['a']}    1.5
    Should Be Equal As Numbers    ${json['b']}    2.25
    Should Be Equal As Numbers    ${json['sum']}  3.75

GET /plus defaults to zero when params missing
    [Documentation]    ไม่ส่ง a,b เลย -> ควรตีความเป็น 0+0 = 0
    ${resp}=           GET    ${SESSION}    /plus
    Should Be Status   ${resp}    200
    ${json}=           To JSON   ${resp}
    Should Be Equal As Numbers    ${json['a']}    0
    Should Be Equal As Numbers    ${json['b']}    0
    Should Be Equal As Numbers    ${json['sum']}  0

GET /plus returns 400 for invalid param
    [Documentation]    ส่ง a=xyz ที่ไม่ใช่ตัวเลข -> ควรได้ 400 พร้อม error message
    ${resp}=           GET    ${SESSION}    /plus    params=a=xyz&b=1
    Should Be Status   ${resp}    400
    ${json}=           To JSON   ${resp}
    Dictionary Should Contain Key    ${json}    error

*** Keywords ***
Should Be Status
    [Arguments]    ${resp}    ${expected}
    Should Be Equal As Integers    ${resp.status_code}    ${expected}

To JSON
    [Arguments]    ${resp}
    ${json}=    Evaluate    ${resp}.json()    modules=requests
    [Return]    ${json}

Log Response If Any
    # call นี้ใช้เฉพาะตอนเทสล้มเหลว เพื่อช่วย debug
    Run Keyword And Ignore Error    Log    Status: ${resp.status_code}
    Run Keyword And Ignore Error    Log    Body: ${resp.text}
