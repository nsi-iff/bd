$(document).ready(function() {
    // selecionar aba padrao
    selecionar_aba_de($('.sel_aba[data-padrao]'))

    $('.sel_aba').click(function() {
        event.preventDefault()
        selecionar_aba_de($(this))
    });

    function selecionar_aba_de(sel_aba) {
        sel_aba.addClass('selecionado').siblings('.sel_aba').removeClass('selecionado')
        var aba_id = sel_aba.children().attr('href')
        $(aba_id).show().siblings('.aba').hide()
    };
});
