$(document).ready(function() {

    cursoSelecionados = $("#curso");
    to1      = $('#to1');
    allTo1   = $('#allTo1');
    to2      = $('#to2');
    allTo2   = $('#allTo2');



    to1.click(function() {
        RemoveSelected();
    });

    allTo1.click(function() {
        RemoveAll();
    });


     to2.click(function() {
        MoveSelected();
    });

    allTo2.click(function() {
        MoveAll();
    });


    function MoveSelected() {
        var eixo     = $('#eixos_tematicos option:selected');
        var curso = $('#objeto_de_aprendizagem_curso_ids option:selected');
        var cursoEmSelecao = eixo.text() + ": "+ curso.text();
        if (curso.length == 1){
            if ($('#curso option[value="' + cursoEmSelecao + '"]').length == 0){
                $(new Option(cursoEmSelecao,cursoEmSelecao,true, true)).
                    appendTo(cursoSelecionados);
            }
        }
   }

    function MoveAll() {
        var eixo     = $('#eixos_tematicos option:selected');
        var curso = $('#objeto_de_aprendizagem_curso_ids option');
        for (var i=0; i<= curso.length;i++){
            var cursoEmSelecao = eixo.text() + ": "+ curso[i].text;
            if ($('#curso option[value="' + cursoEmSelecao + '"]').length == 0){
                $(new Option(cursoEmSelecao,cursoEmSelecao,true, true)).
                    appendTo(cursoSelecionados);
            }
        }
   }
    function RemoveSelected() {
        $('#curso option:selected').remove();
    }
    function RemoveAll(removeGroup, otherGroup) {
        $('#curso  option').remove();
    }

});
