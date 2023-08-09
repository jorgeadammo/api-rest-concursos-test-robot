*** Settings ***
Documentation   Documentação da API: n/a
Library         RequestsLibrary
Library         Collections

*** Variable ***
${URL_API}          http://localhost:8095/api-cnc
${BANCA_ESPERADA}   {"id":2,"nome":"Instituto Brasileiro","apelido":"IBRAE@@@@@@","telefoneFixo":"61988888888","endereco":"Brasília","ativo":true,"data":"2020-02-21"}


** Keywords ***
#SETUP AND
Conectar a minha API
  Create Session    APIConcursos   ${URL_API}

#Ações
Fazer Login na API
  ${HEADERS}    Create Dictionary     content-type=application/json
  ${RESPOSTA}   Post Request      APIConcursos     uri=/login
  ...                             data={"usuariologin": "jorge.barros","usuariosenha": "123456"}
  ...                             headers=${HEADERS}
  Log                  ${RESPOSTA.text}
  Set Test Variable    ${RESPOSTA}
  ${TOKEN}     Get From Dictionary    ${RESPOSTA.json()["data"]}    token
  Set Global Variable    ${TOKEN}

Buscar uma banca
    #[Arguments]                       ${ID_BANCA}
    ${HEADERS}    Create Dictionary     content-type=application/json
    #${RESPOSTA_GET}   Get Request      APIConcursos     uri=banca/${ID_BNC}   #uri=banca/${ID_BANCA}
    ${RESPOSTA_GET}   GET On Session    APIConcursos     /banca/${ID_BNC}   #uri=banca/${ID_BANCA}
    ...                            headers=${HEADERS}
    Log                 ${RESPOSTA_GET.json()}
    Set Test Variable    ${RESPOSTA_GET}

Cadastrar uma banca
  ${HEADERS}    Create Dictionary     content-type=application/json     #token=${TOKEN}
  #${RESPOSTA_POST}   Post Request      APIConcursos     uri=/banca
  ${RESPOSTA_POST}   POST On Session    APIConcursos     /banca
  ...                             data= {"nome": "Instituto Brasileiro", "endereco": "Brasilia", "apelido": "IBRAE@@@@@@", "telefoneFixo": "61988888888", "data": "2023-08-01", "ativo": true}
  ...                             headers=${HEADERS}
  Log                  ${RESPOSTA_POST.json()}
  Set Test Variable    ${RESPOSTA_POST}
  ${ID_BNC}            Set Variable  ${RESPOSTA_POST.json()["data"]["id"]}  #Aqui eu pego o id da banca gerado para fazer as outras operacoes
  Log                  ${ID_BNC}
  Set Global Variable  ${ID_BNC}

Alterar uma banca
    #[Arguments]                       ${ID_BANCA}
    ${HEADERS}    Create Dictionary     content-type=application/json
    ${RESPOSTA_PUT}   Put Request      APIConcursos     uri=banca/${ID_BNC}   #uri=banca/${ID_BANCA}  
    ...                            data= {"nome": "Instituto Brasileiro", "endereco": "Brasilia", "apelido": "IBRAE", "telefoneFixo": "61988888888", "data": "2023-08-01", "ativo": false}
    ...                            headers=${HEADERS}
    Log                 ${RESPOSTA_PUT.json()}
    Set Test Variable   ${RESPOSTA_PUT}

Deletar uma banca
    #[Arguments]                       ${ID_BANCA}
    ${HEADERS}    Create Dictionary     content-type=application/json
    ${RESPOSTA_DELETE}   Delete Request      APIConcursos     uri=banca/${ID_BNC}   #uri=banca/${ID_BANCA}  
    ...                            headers=${HEADERS}
    Log                 ${RESPOSTA_DELETE.json()}
    Set Test Variable   ${RESPOSTA_DELETE}

####################CONFERÊNCIAS
Conferir status code GET
  [Arguments]                       ${STATUSCODE_DESEJADO}
  Should Be Equal As Strings        ${RESPOSTA_GET.status_code}   ${STATUSCODE_DESEJADO}
  Log                               ${RESPOSTA_GET.status_code}

Conferir mensagem GET
  [Arguments]                       ${MENSAGEM}
  Should Be Equal As Strings        ${RESPOSTA_GET.json()["nome"]}     ${MENSAGEM}
  Log                               ${RESPOSTA_GET.json()["id"]}
  Log                               ${RESPOSTA_GET.json()["nome"]}

Conferir mensagem POST "${MENSAGEM}"
  #  [Arguments]                       ${MENSAGEM}=Listagem de produtos realizada com sucesso
    Should Be Equal As Strings        ${RESPOSTA_POST.json()["data"]["nome"]}     ${MENSAGEM}
    Log                               ${RESPOSTA_POST.json()["data"]["nome"]}

Conferir status code POST
      [Arguments]                       ${STATUSCODE_DESEJADO}
      Should Be Equal As Strings        ${RESPOSTA_POST.status_code}   ${STATUSCODE_DESEJADO}
      Log                               ${RESPOSTA_POST.status_code}

Conferir mensagem PUT "${MENSAGEM}"
  #  [Arguments]                       ${MENSAGEM}=Listagem de produtos realizada com sucesso
    Should Be Equal As Strings         ${RESPOSTA_PUT.json()["apelido"]}     ${MENSAGEM}
    Log                                ${RESPOSTA_PUT.json()["apelido"]}

Conferir status code PUT
      [Arguments]                       ${STATUSCODE_DESEJADO}
      Should Be Equal As Strings        ${RESPOSTA_PUT.status_code}   ${STATUSCODE_DESEJADO}
      Log                               ${RESPOSTA_PUT.status_code}

Conferir mensagem DELETE "${MENSAGEM}"
  #  [Arguments]                       ${MENSAGEM}=Listagem de produtos realizada com sucesso
    Should Be Equal As Strings         ${RESPOSTA_DELETE.json()}     ${MENSAGEM}
    Log                                ${RESPOSTA_DELETE.json()}

Conferir status code DELETE
      [Arguments]                       ${STATUSCODE_DESEJADO}
      Should Be Equal As Strings        ${RESPOSTA_DELETE.status_code}   ${STATUSCODE_DESEJADO}
      Log                               ${RESPOSTA_DELETE.status_code}

Conferir se retorna todos os dados cadastrados para a nova banca
      ${RESPOSTA_POST.json()}   To Json   ${BANCA_ESPERADA}
