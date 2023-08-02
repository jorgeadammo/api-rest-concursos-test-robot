*** Settings ***
Documentation   Documentação da API: n/a
Resource        API_Concursos.robot
Suite Setup     Conectar a minha API

*** Variable ***
#${URL_API}      http://165.227.93.41/lojinha
${URL_API}      http://localhost:8095/api-cnc


*** Test Case ***
Conferir uma banca (GET)
  Buscar uma banca  2
  Conferir status code  200
  Conferir mensagem GET  Instituto Brasileiro
