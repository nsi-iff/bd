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
      title[i] = [i + 1, dados[i].titulo]
      acessos[i] = [ i + 1, dados[i].numero_de_acessos]
    [title, acessos]

  #grafico tipo pie
  lista_percentuais_conteudo : (numero, dados) ->
    data = []
    i = 0
    while i < numero
      data[i] =
        label: dados[i][0]
        data: dados[i][1]
      i++
    data

  #grafico tipo pie
  lista_percentuais_subarea : (numero, dados) ->
    data = []
    i = 0
    while i < numero
      data[i] =
        label: dados[i][1]
        data: dados[i][0]
      i++
    data



jQuery ->
  if window.location.pathname == '/estatisticas'
    documentos = gon.estatistica.cinco_documentos_mais_acessados
    acessos = Estatisticas.lista_de_documentos(documentos.length, documentos)

    $.plot $('#cinco_acessos'), [data : acessos[1]],
      series:
        stack: 0
        lines:
          show: false
          steps: false

        bars:
          show: true
          barWidth: 0.9
          align: "center"
      xaxis:
        ticks: acessos[0]


    percentuais_conteudo = gon.estatistica.percentual_de_acessos_por_tipo_de_conteudo
    conteudo = Estatisticas.lista_percentuais_conteudo(percentuais_conteudo.length, percentuais_conteudo)
    $.plot $("#conteudo"), conteudo,
      series:
        pie:
          show: true
          radius: 1
          label:
            show: true
            radius: 4/5
            formatter: (label, series) ->
              "<div style=\"font-size:8pt;text-align:center;padding:2px;color:white;\">" + label + "<br/>" + Math.round(series.percent) + "%</div>"
            background:
              opacity: 0.8
      legend:
        show: false

    percentuais_subarea = gon.estatistica.percentual_de_acessos_por_subarea_de_conhecimento
    subarea = Estatisticas.lista_percentuais_subarea(percentuais_subarea.length, percentuais_subarea)
    $.plot $("#subarea"),subarea,
      series:
        pie:
          show: true
          radius: 1
          label:
            show: true
            radius: 4/5
            formatter: (label, series) ->
              "<div style=\"font-size:8pt;text-align:center;padding:2px;color:white;\">" + label + "<br/>" + Math.round(series.percent) + "%</div>"
            background:
              opacity: 0.8
      legend:
        show: false


  if window.location.pathname == '/documentos_mais_acessados'
    documentos = gon.estatistica.documentos_mais_acessados
    todos_acessos = Estatisticas.lista_de_documentos(documentos.length, documentos)

    $.plot $('#todos_acessos'), [data : todos_acessos[1]],
      series:
        stack: 0
        lines:
          show: false
          steps: false

        bars:
          show: true
          barWidth: 0.9
          align: "center"
      xaxis:
        ticks: todos_acessos[0]

