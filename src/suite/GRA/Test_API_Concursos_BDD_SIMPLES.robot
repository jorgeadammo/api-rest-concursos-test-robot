*** Settings ***  
Resource         ../PageObjects/BDD.robot
Resource         ../PageObjects/RecursoApiConcursos.robot
#Suite Setup      Conectar a minha API
#Suite Teardown   Close Browser

*** Test Cases ***
Cenário01: Cadastrar uma Banca (POST)
    [Documentation]       API Concursos Workshop - Robot
    [Tags]                Banca
    Dado que o endereço da API para manter o cadastro de Banca
    Quando realizar uma requisição para cadastrar uma banca
    Então a API irá retornar os dados do cadastro da Banca "Instituto Brasileiro"
    E conferir se retorna todos os dados cadastrados para a nova banca
    E respondendo o código "201"

Cenário02: Consultar uma Banca (GET)
    [Documentation]       API Concursos Workshop - Robot
    [Tags]                Banca
    Dado que o endereço da API para manter o cadastro de Banca
    #Quando realizar uma requisição passando o ID da banca "2"
    Quando realizar uma requisição passando o ID da banca
    Então a API irá retornar os dados da Banca correspondente "Instituto Brasileiro"
    E respondendo o código "200"

Cenário03: Alterar uma Banca (PUT)
    Dado que o endereço da API para manter o cadastro de Banca
    Quando realizar uma requisição para alterar uma banca
    Então a API irá retornar os dados da Banca alterada "IBRAE"
    E respondendo o código "200"

Cenário04: Deletar uma Banca (DELETE)
    Dado que o endereço da API para manter o cadastro de Banca
    Quando realizar uma requisição para excluir uma banca
    Então a API deverá retornar os dados da exclusão "{'deleted': True}"
    E respondendo o código "200"