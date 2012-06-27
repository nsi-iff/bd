$(document).ready(function() {
    $('ul.areas span').live('click', function() {
        $('.portlet').css('width', '185px');
        var id = $(this).attr('id')
        $('.' + id + '_sub_area').toggle('slow');
    });
});

