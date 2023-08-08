*** Settings ***
Documentation   Documentação da API: n/a
Resource        API_Concursos.robot
Suite Setup     Conectar a minha API

*** Variable ***
#${URL_API}      http://localhost:8095/api-cnc


*** Test Case ***
#Cenário: Consultar todas as Bancas (GET)
  #Buscar todas as bancas
  #Conferir mensagem GET
  #Conferir status code GET  200

Cenário: Cadastrar uma Banca (POST)
  [Tags]    post
  Cadastrar uma banca
  Conferir mensagem POST "Instituto Brasileiro"
  Conferir se retorna todos os dados cadastrados para a nova banca
  Conferir status code POST  201

Cenário: Consultar uma Banca (GET)
  [Tags]    get
  Buscar uma banca
  Conferir mensagem GET  Instituto Brasileiro
  Conferir status code GET  200

Cenário: Alterar uma Banca (PUT)
  [Tags]    put
  Alterar uma banca
  Conferir mensagem PUT "IBRAE"
  Conferir status code PUT  200

Cenário: Deletar uma Banca (DELETE)
  [Tags]    delete
  Deletar uma banca
  Conferir mensagem DELETE "{'deleted': True}"
  Conferir status code DELETE  200

##########################################################################

#Cenário: Cadastrar uma Banca
    #Dado o endereço da API para manter o cadastro de Banca
    #Quando realizar uma requisição para cadastrar uma banca
    #Então a API irá retornar os dados do cadastro da Banca respondendo o código 201

#Cenário: Consultar uma Banca
    #Dado o endereço da API para manter o cadastro de Banca
    #Quando realizar uma requisição passando o ID da banca
    #Então a API irá retornar os dados da Banca correspondente respondendo o código 200

#Cenário: Alterar uma Banca
    #Dado o endereço da API para manter o cadastro de Banca
    #Quando realizar uma requisição para alterar uma banca
    #Então a API irá retornar os dados da Banca alterados respondendo o código 200

#Cenário: Deletar uma Banca
    #Dado o endereço da API para manter o cadastro de Banca
    #Quando realizar uma requisição para excluir uma banca
    #Então a API deverá retornar os dados da exclusão respondendo o código 200
