$(document).ready(function() {
    $("#eixos_tematicos").change(function() {
        var id = this.value;
        $.post("/eixos_tematicos/" + id + "/cursos");
    });

});

/* Funcao para o evento 'onclick' do botao 'submit' do form de objetos_de_aprendizagem
   Adiciona uma hidden tag a fim de enviar os cursos selecionados para o controller. */
function enviar_cursos_selecionados()
{
    hidden_input = $("<input type='hidden' name='cursos_selecionados_oculto'>");
    hidden_input.val($('#cursos_selecionados').val());
    hidden_input.insertAfter($('#objeto_de_aprendizagem_cursos_input'));
}
