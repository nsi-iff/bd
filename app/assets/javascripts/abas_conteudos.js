$(document).ready(function() {
    // selecionar aba padrao
    selecionarAbaDe($('.sel_aba[data-padrao]'))

    $('.sel_aba').click(function() {
        event.preventDefault()
        selecionarAbaDe($(this))
    });

    function selecionarAbaDe(sel_aba) {
        sel_aba.addClass('selecionado').siblings('.sel_aba').removeClass('selecionado')
        var aba_id = sel_aba.children().attr('href')
        $(aba_id).show().siblings('.aba').hide()
    };
});
