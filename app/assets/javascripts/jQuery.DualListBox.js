$(document).ready(function() {
    $('#to1').click(function() { removeSelected() });
    $('#to2').click(function() { addSelected() });
    $('#allTo1').click(function() { removeAll() });
    $('#allTo2').click(function() { addAll() });

    function removeSelected() {
        $('#cursos_selecionados option:selected').remove();
    }

    function addEixoECursosSelecionados(eixo, cursos) {
      cursos.each(function(index, curso) {
        var cursoEmSelecao = eixo + ": " + curso.text
        // antes de adicionar, verifica para nao duplicar algo ja adicionado
        if ($('#cursos_selecionados option[value="' + cursoEmSelecao + '"]').length == false) {
          $(new Option(cursoEmSelecao,cursoEmSelecao,true, true)).appendTo($('#cursos_selecionados'))
        }
      })
    }

    function addSelected() {
        var eixo = $('#eixos_tematicos option:selected').text()
        var cursos_selecionados = $('#objeto_de_aprendizagem_curso_ids option:selected')
        addEixoECursosSelecionados(eixo, cursos_selecionados)
    }

    function addAll() {
        var eixo = $('#eixos_tematicos option:selected').text()
        var cursos_selecionados = $('#objeto_de_aprendizagem_curso_ids option')
        addEixoECursosSelecionados(eixo, cursos_selecionados)
    }

    function removeAll() {
        $('#cursos_selecionados option').remove();
    }
});
