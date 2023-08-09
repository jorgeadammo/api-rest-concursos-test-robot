*** Settings ***
Variables                 ../Libraries/screenshots-test.py
#Library                   SeleniumLibrary
Documentation   Documentação da API: n/a
Library         RequestsLibrary
Library         Collections
#Library         HttpRequestLibrary

*** Variable ***
${URL_API}          http://localhost:8095/api-cnc
${BANCA_ESPERADA}   {"id":2,"nome":"Instituto Brasileiro","apelido":"IBRAE@@@@@@","telefoneFixo":"61988888888","endereco":"Brasília","ativo":true,"data":"2020-02-21"}


*** Keywords ***
#### DADO
que o endereço da API para manter o cadastro de Banca
    Conectar a minha API

#### QUANDO
realizar uma requisição passando o ID da banca
    Buscar uma banca

#realizar uma requisição passando o ID da banca "${ID_BANCA}"
    #Buscar uma banca  ${ID_BANCA}

realizar uma requisição para cadastrar uma banca
    #Fail
    Cadastrar uma banca

realizar uma requisição para alterar uma banca
    Alterar uma banca

realizar uma requisição para excluir uma banca
    Deletar uma banca

#### ENTÃO
a API irá retornar os dados da Banca correspondente "${MENSAGEM}"
    Conferir mensagem GET  ${MENSAGEM}

a API irá retornar os dados do cadastro da Banca "${MENSAGEM}"
    Conferir mensagem POST  ${MENSAGEM}

a API irá retornar os dados da Banca alterada "${MENSAGEM}"
    Conferir mensagem PUT  ${MENSAGEM}

a API deverá retornar os dados da exclusão "${MENSAGEM}"
    Conferir mensagem DELETE  ${MENSAGEM}

#### E
respondendo o código "${STATUSCODE_DESEJADO}"
    Conferir status code  ${STATUSCODE_DESEJADO}

conferir se retorna todos os dados cadastrados para a nova banca
    Conferir objeto completo

############################################################################################################################

#SETUP AND
Conectar a minha API
  Create Session    APIConcursos   ${URL_API}

############################################################################################################################

#### PASSOS    
Cadastrar uma banca
  ${HEADERS}    Create Dictionary     content-type=application/json     #token=${TOKEN}
  #${RESPOSTA_HTTP}   Post Request      APIConcursos     uri=/banca
  ${RESPOSTA_HTTP}   POST On Session    APIConcursos     /banca
  ...                             data= {"nome": "Instituto Brasileiro", "endereco": "Brasilia", "apelido": "IBRAE@@@@@@", "telefoneFixo": "61988888888", "data": "2023-08-01", "ativo": true}
  ...                             headers=${HEADERS}
  Log                  ${RESPOSTA_HTTP.json()}
  Set Test Variable    ${RESPOSTA_HTTP}
  ${ID_BNC}            Set Variable  ${RESPOSTA_HTTP.json()["data"]["id"]}  #Aqui eu pego o id da banca gerado para fazer as outras operacoes
  Log                  ${ID_BNC}
  Set Global Variable  ${ID_BNC}

Buscar uma banca
    #[Arguments]                       ${ID_BANCA}
    ${HEADERS}    Create Dictionary     content-type=application/json
    #${RESPOSTA_HTTP}   Get Request      APIConcursos     uri=banca/${ID_BANCA}   #uri=banca/${ID_BANCA}
    ${RESPOSTA_HTTP}   GET On Session    APIConcursos     /banca/${ID_BNC}   #/banca/${ID_BANCA}
    ...                            headers=${HEADERS}
    Log                 ${RESPOSTA_HTTP.json()}
    Set Test Variable    ${RESPOSTA_HTTP}

Alterar uma banca
    #[Arguments]                       ${ID_BANCA}
    ${HEADERS}    Create Dictionary     content-type=application/json
    #${RESPOSTA_HTTP}   Put Request      APIConcursos     uri=banca/${ID_BNC}   #uri=banca/${ID_BANCA}  
    ${RESPOSTA_HTTP}   PUT On Session    APIConcursos     /banca/${ID_BNC}   #/banca/${ID_BANCA}  
    ...                            data= {"nome": "Instituto Brasileiro", "endereco": "Brasilia", "apelido": "IBRAE", "telefoneFixo": "61988888888", "data": "2023-08-01", "ativo": false}
    ...                            headers=${HEADERS}
    Log                 ${RESPOSTA_HTTP.json()}
    Set Test Variable   ${RESPOSTA_HTTP}

Deletar uma banca
    #[Arguments]                       ${ID_BANCA}
    ${HEADERS}    Create Dictionary     content-type=application/json
    #${RESPOSTA_HTTP}   Delete Request      APIConcursos     uri=banca/${ID_BNC}   #uri=banca/${ID_BANCA}  
    ${RESPOSTA_HTTP}   DELETE On Session    APIConcursos     /banca/${ID_BNC}   #/banca/${ID_BANCA}  
    ...                            headers=${HEADERS}
    Log                 ${RESPOSTA_HTTP.json()}
    Set Test Variable   ${RESPOSTA_HTTP}

Conferir status code
  [Arguments]                       ${STATUSCODE_DESEJADO}
  Should Be Equal As Strings        ${RESPOSTA_HTTP.status_code}   ${STATUSCODE_DESEJADO}
  Log                               ${RESPOSTA_HTTP.status_code}

Conferir mensagem GET
  [Arguments]                       ${MENSAGEM}
  Should Be Equal As Strings        ${RESPOSTA_HTTP.json()["nome"]}     ${MENSAGEM}
  Log                               ${RESPOSTA_HTTP.json()["id"]}
  Log                               ${RESPOSTA_HTTP.json()["nome"]}

Conferir mensagem POST
  [Arguments]                       ${MENSAGEM}
  Should Be Equal As Strings        ${RESPOSTA_HTTP.json()["data"]["nome"]}     ${MENSAGEM}
  Log                               ${RESPOSTA_HTTP.json()["data"]["nome"]}

Conferir mensagem PUT
  [Arguments]                       ${MENSAGEM}
  Should Be Equal As Strings        ${RESPOSTA_HTTP.json()["apelido"]}     ${MENSAGEM}
  Log                               ${RESPOSTA_HTTP.json()["apelido"]}

Conferir mensagem DELETE
  [Arguments]                       ${MENSAGEM}
  Should Be Equal As Strings        ${RESPOSTA_HTTP.json()}     ${MENSAGEM}
  Log                               ${RESPOSTA_HTTP.json()}

Conferir objeto completo
      ${RESPOSTA_HTTP.json()}   To Json   ${BANCA_ESPERADA}
############################################################################################################################