# -*- coding: utf-8 -*-
*** Settings ***
#Resource                  ../PageObjects/RecursoApiConcursos.robot
Variables                 ../Libraries/screenshots-test.py
Library                   SeleniumLibrary

*** Variables ***
#${opcoes}                                   add_argument("--headless")
${browser}                                  Chrome
#${browser}                                  Headless Chrome
${tempoSleep0}                              2
${tempoSleep}                               4
${tempoSleep2}                              8
${tempoSleep3}                              12
${tempoSleep4}                              120
${tempoTimeout}                             60
${seleniumSpeed}                            0.5
# Menu

# Nome Suite Test
${ST0800}  ST0800 TestApiConcursosBuscaBDD${/}

# Caminho screenshots
${caminhoScreenshots.ST0800}  ST0800_TestApiConcursosBuscaBDD/


# Caminho scripts
${caminhoScripts}  ${EXECDIR}${/}src${/}suite${/}Scripts${/}
${caminhoScripts.ST0800}  ${caminhoScripts}${ST0800}${/}


*** Keywords ***
Abrir navegador
    [Arguments]                    ${URL}
	#Open Browser                   ${URL}  ${browser}  headlesschrome
    #Open Browser                   ${URL}  ${browser}  --no-sandbox
    #Open Browser                   ${URL}  ${browser}  ${boasopcoes}
    Open Browser                   ${URL}  ${browser}  
    #Set Window Size                1920  1080
    Maximize Browser Window

Fechar Navegador
    Close Browser

Validar Title
    [Arguments]                    ${title} 
    Title Should Be                ${title}

Validar URL
    [Arguments]                    ${url} 
    Location Should Contain        ${url}

Acessar Home
    Go To                          ${properties.url}

Descer Barra de Rolagem
    Execute Javascript	  window.scrollTo(0,document.body.scrollHeight);

Subir Barra de Rolagem
    Execute Javascript	  window.scrollTo(0,document.body.scrollTop);
    #Execute Javascript	  window.scrollTop(0,document.body);

Capturar Screenshot
    [Arguments]                    ${nomeScreenshot}
    Capture Page Screenshot        //screenshots//${nomeScreenshot}
