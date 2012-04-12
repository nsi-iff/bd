 $(document).ready(function() {
    $('.sel_aba').click(function() {
        show_aba('#' + $(this).data('aba_id'));
        $(this).addClass('selecionado');
        $(this).siblings('.sel_aba').removeClass('selecionado');
    });

    var sel_aba_padrao = $('.sel_aba[data-padrao]');
    show_aba('#' + sel_aba_padrao.data('aba_id'));
    sel_aba_padrao.addClass('selecionado');

    function show_aba(aba_selector) {
        $(aba_selector).show().siblings('.aba').hide();
    };
});