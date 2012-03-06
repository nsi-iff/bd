
$(document).ready(function() {

    $("#eixos_tematicos").change(function() {
        var id = this.value;
        $.post("/eixos_tematicos/" + id + "/cursos");
    });

});

/* Funcao para o evento 'onclick' do botao 'submit' da pagina view/objetos_de_aprendizagem/new.html.haml.
   Adiciona uma hidden tag a fim de enviar os cursos selecionados para o controller. */
function enviar_cursos_selecionados()
{
  input = $("<input type='hidden' id='cursos_selecionados_oculto' name='cursos_selecionados_oculto' value=''>");
  input.insertAfter($('#objeto_de_aprendizagem_idioma_id'));
  input.val($('#cursos_selecionados').val());
}
