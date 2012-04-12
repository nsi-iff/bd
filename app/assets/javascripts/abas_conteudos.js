$(document).ready(function() {
    // selecionar aba padrao
    selecionar_aba_de($('.sel_aba[data-padrao]'))

    $('.sel_aba').click(function() {
        event.preventDefault()
        selecionar_aba_de($(this))
    });

    function selecionar_aba_de(sel_aba) {
        sel_aba.addClass('selecionado').siblings('.sel_aba').removeClass('selecionado')
        var aba = document.getElementById(sel_aba.data('aba_id'))
        $(aba).show().siblings('.aba').hide()
    };
});
