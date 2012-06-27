$(document).ready(function() {
    $('ul.areas span').live('click', function() {
        var id = $(this).attr('id')
        $('.' + id + '_sub_area').toggle('slow');
    });
});

