//TODO: FIX não é possível adicionar vários cursos ao mesmo tempo (2012-04-12, 17:01, ciberglo)`
//TODO: refatorar para melhorar codigo (2012-04-12, 17:02, ciberglo)`

$(document).ready(function() {

    cursosSelecionados = $("#cursos_selecionados");
    to1 = $('#to1');
    to2 = $('#to2');
    allTo1 = $('#allTo1');
    allTo2 = $('#allTo2');

    to1.click(function() {
        RemoveSelected();
    });

    to2.click(function() {
        MoveSelected();
    });

    allTo1.click(function() {
        RemoveAll();
    });

    allTo2.click(function() {
        MoveAll();
    });

    function MoveSelected() {
        var eixo     = $('#eixos_tematicos option:selected');
        var curso = $('#objeto_de_aprendizagem_curso_ids option:selected');
        var cursoEmSelecao = eixo.text() + ": "+ curso.text();
        if ($('#objeto_de_aprendizagem_curso_ids option:selected').length !=0){
            if ($('#cursos_selecionados option[value="' + cursoEmSelecao + '"]').length == false){
                $(new Option(cursoEmSelecao,cursoEmSelecao,true, true)).
                    appendTo(cursosSelecionados);
            }
        }
   }

    function MoveAll() {
        var eixo     = $('#eixos_tematicos option:selected');
        var curso = $('#objeto_de_aprendizagem_curso_ids option');
        for (var i=0; i<= curso.length;i++){
            var cursoEmSelecao = eixo.text() + ": "+ curso[i].text;
            if ($('#cursos_selecionados option[value="' + cursoEmSelecao + '"]').length == false){
                $(new Option(cursoEmSelecao,cursoEmSelecao,true, true)).
                    appendTo(cursosSelecionados);
            }
        }
   }

    function RemoveSelected() {
        $('#cursos_selecionados option:selected').remove();
    }

    function RemoveAll(removeGroup, otherGroup) {
        $('#cursos_selecionados  option').remove();
    }

});
