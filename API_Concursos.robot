*** Settings ***
Documentation   Documentação da API: n/a
Library         RequestsLibrary
Library         Collections

*** Variable ***
${URL_API}          http://localhost:8095/api-cnc
${PRODUTO_ESPERADO}   {"id":2,"nome":"Instituto Brasileiro","apelido":"IBRAE@@@@@@","telefoneFixo":"61988888888","endereco":"Brasília","ativo":true,"data":"2020-02-21"}


** Keywords ***
#SETUP AND
Conectar a minha API
  Create Session    APIConcursos   ${URL_API}

#Ações
Fazer Login na API
  ${HEADERS}    Create Dictionary     content-type=application/json
  ${RESPOSTA}   Post Request      APILojinha     uri=/login
  ...                             data={"usuariologin": "vanessa.redes","usuariosenha": "123456"}
  ...                             headers=${HEADERS}
  Log                  ${RESPOSTA.text}
  Set Test Variable    ${RESPOSTA}
  ${TOKEN}     Get From Dictionary    ${RESPOSTA.json()["data"]}    token
  Set Global Variable    ${TOKEN}

Buscar lista de Produtos
    ${HEADERS}   Create Dictionary    token=${TOKEN}
    ${RESPOSTA_GET}   Get Request      APILojinha     uri=/produto
    ...                            headers=${HEADERS}
    Log                 ${RESPOSTA_GET.json()}
    Set Test Variable    ${RESPOSTA_GET}

Buscar uma banca
    [Arguments]                       ${ID_BANCA}
    ${HEADERS}    Create Dictionary     content-type=application/json
    ${RESPOSTA_GET}   Get Request      APIConcursos     uri=banca/${ID_BANCA}
    ...                            headers=${HEADERS}
    Log                 ${RESPOSTA_GET.json()}
    Set Test Variable    ${RESPOSTA_GET}


Cadastrar novo Produto
  ${HEADERS}    Create Dictionary     content-type=application/json     token=${TOKEN}
  ${RESPOSTA_POST}   Post Request      APILojinha     uri=/produto
  ...                             data= {"produtonome": "robot1", "produtovalor": 10.00, "produtocores": [ "laranja" ], "componentes": [{"componentenome": "Framework", "componentequantidade": 10}]}
  ...                             headers=${HEADERS}
  Log                  ${RESPOSTA_POST.json()}
  Set Test Variable    ${RESPOSTA_POST}

####################CONFERÊNCIAS
Conferir status code
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
    Should Be Equal As Strings        ${RESPOSTA_POST.json()["message"]}     ${MENSAGEM}
    Log                               ${RESPOSTA_POST.json()["message"]}

Conferir se retorna todos os dados cadastrados para o novo produto
      ${RESPOSTA_POST.json()}   To Json   ${PRODUTO_ESPERADO}

Conferir status code POST
      [Arguments]                       ${STATUSCODE_DESEJADO}
      Should Be Equal As Strings        ${RESPOSTA_POST.status_code}   ${STATUSCODE_DESEJADO}
      Log                               ${RESPOSTA_POST.status_code}