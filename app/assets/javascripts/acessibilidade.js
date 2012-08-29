$(document).ready(function() {
	var max = $('#aumentar_fonte');
	var min = $('#diminuir_fonte');
	var padrao = $('#fonte_padrao')
	var mudar_css = function(size){
		selector = $(".container p, .container a, .container input, .container select, .container label, .container h1, .container h2, .container h3, .container span, footer");
		selector.each(function(){
			var element = $(this);
			font_size = element.css('font-size')
			element.css('font-size',((parseInt(font_size)+(size)).toString()+"px"))
			
		});
	}

	var aumentar = function(){
		mudar_css(2);
	}
	var diminuir = function(){
		mudar_css(-2);
	}

	var refresh = function(){
		document.location.reload();
	}

	max.click(aumentar);
	min.click(diminuir);
	padrao.click(refresh);
});