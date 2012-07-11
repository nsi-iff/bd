$(document).ready(function(){
    $('.imagem').each(function(){
        var imagem = $(this);
        var fullscreenOn = false;
        var closefullscreen = function(){
            imagem.removeClass('fullscreenOn');
            $('body').css('overflow-y', '')
            fullscreenOn = false;
        }
        var fullscreen = function() {
            if(fullscreenOn){
                closefullscreen();       
            }
            else
            {
                var imagem_top = (($("body")[0].clientHeight/2) - imagem[0].clientHeight/2);
                var imagem_left = (($("body")[0].clientWidth/2) - imagem[0].clientWidth/2);
                imagem.addClass('fullscreenOn');
                $('body').css('overflow-y', 'hidden')
                fullscreenOn = true;
                $(".fullscreenOn").children().css({'top':imagem_top+'px', 'left':imagem_left+'px'});
            }
        };

        imagem.click(fullscreen)
    })
});
