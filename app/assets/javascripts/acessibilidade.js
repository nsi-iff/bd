$(document).ready(function() {
	var max = $('#aumentar_fonte');
	var min = $('#diminuir_fonte');
	var size = 15;
	var mudar_css = function(size){
		$("p").css('font-size',((size).toString()+"px"))
		$("p").css('font-size',((size).toString()+"px"))
		$("label").css('font-size',((size).toString()+"px"))
		
	}

	var aumentar = function(){
		navigation_font_size = size;
		mudar_css(navigation_font_size + 2);
		size = size + 2;
	}
	var diminuir = function(){
		navigation_font_size = size;
		mudar_css(navigation_font_size - 2);
		size = size - 2;
	}

	// max.click(aumentar);
	// min.click(diminuir);
});