# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
  if window.location.pathname == '/estatisticas'
    title = []
    acessos = []
    documentos = gon.estatistica.documentos_mais_acessados
    for i in [0..(documentos.length - 1)]
      title.push documentos[i].titulo
      acessos.push documentos[i].numero_de_acessos
    console.log title
    console.log acessos
