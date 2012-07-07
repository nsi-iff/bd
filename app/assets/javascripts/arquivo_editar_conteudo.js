$(document).ready(function() {
    var opcoes_arquivo = $('#opcoes_arquivo input')
    var arquivo = $('#livro_arquivo_input');

    if (opcoes_arquivo) {
        apenas_um_checkbox();
        hide_arquivo();
        toggle_arquivo();
    }

    function apenas_um_checkbox() {
        opcoes_arquivo.click(function() {
            opcoes_arquivo.removeAttr('checked');
            $(this).attr('checked', 'true');
            if (this.id != '#substituir_arquivo_atual') {
                hide_arquivo();
            }
        });
    }

    function toggle_arquivo() {
        $('#substituir_arquivo_atual').click(function() {
            this.checked ? arquivo.css('display', '') : hide_arquivo();
        });
    }

    function hide_arquivo() {
        arquivo.css('display', 'none');
    }
});
