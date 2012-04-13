//TODO: colocar esse script para so carregar na pagina de estatisticas.html.erb e pensar em um nome melhor para "radio_[ano..]" (2012-04-13, 00:10, ciberglo)`

$(document).ready(function(){
    $('#radio_ano').click(function(){
        $('#select_mes').attr('disabled', true)
    })

    $('#radio_mes').click(function(){
        $('#select_mes').removeAttr('disabled')
    })
});
