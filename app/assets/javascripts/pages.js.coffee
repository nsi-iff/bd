# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
Estatisticas = 
  #lista de todos os documentos e/ou os mais acessados
  #grafico tipo barra
  lista_de_documentos : (numero, dados) ->
    title = []
    acessos = []
    for i in [0..(numero - 1)]
      title.push dados[i].titulo
      acessos.push dados[i].numero_de_acessos
    console.log title
    console.log acessos

  #grafico tipo pie
  lista_percentuais_conteudo : (numero, dados) ->
    valores = []
    for i in [0..(numero - 1)]
      valores.push Array(dados[i][0] , dados[i][1])
    console.log valores

  #grafico tipo pie
  lista_percentuais_subarea : (numero, dados) ->
    valores = []
    for i in [0..(numero - 1)]
      valores.push Array(dados[i][1] , dados[i][0])
    console.log valores

jQuery ->
  if window.location.pathname == '/estatisticas'
    documentos = gon.estatistica.cinco_documentos_mais_acessados
    Estatisticas.lista_de_documentos(documentos.length, documentos)

    percentuais_conteudo = gon.estatistica.percentual_de_acessos_por_tipo_de_conteudo
    Estatisticas.lista_percentuais_conteudo(percentuais_conteudo.length, percentuais_conteudo)

    percentuais_subarea = gon.estatistica.percentual_de_acessos_por_subarea_de_conhecimento
    Estatisticas.lista_percentuais_subarea(percentuais_subarea.length, percentuais_subarea)

  if window.location.pathname == '/documentos_mais_acessados'
    documentos = gon.estatistica.documentos_mais_acessados
    Estatisticas.lista_de_documentos(documentos.length, documentos)
