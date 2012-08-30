$(document).ready(function() {
	function GerarCookie(strCookie, strValor, lngDias){
    	var dtmData = new Date();
    	if(lngDias){
        	dtmData.setTime(dtmData.getTime() + (lngDias * 24 * 60 * 60 * 1000));
        	var strExpires = "; expires=" + dtmData.toGMTString();
    	}
    	else{
        var strExpires = "";
    	}
    	document.cookie = strCookie + "=" + strValor + strExpires + "; path=/";
	}
	function LerCookie(strCookie){
    	var strNomeIgual = strCookie + "=";
    	var arrCookies = document.cookie.split(';');
    	for(var i = 0; i < arrCookies.length; i++){
        	var strValorCookie = arrCookies[i];
        	while(strValorCookie.charAt(0) == ' '){
            	strValorCookie = strValorCookie.substring(1, strValorCookie.length);
        	}
        	if(strValorCookie.indexOf(strNomeIgual) == 0){
            	return strValorCookie.substring(strNomeIgual.length, strValorCookie.length);
        	}
    	}
    	return null;
	}
	function ExcluirCookie(strCookie){
    	GerarCookie(strCookie, '', -1);
	}
	if (LerCookie("alto_contraste") == null){
		acess = "false"
	}else{
		acess = LerCookie("alto_contraste");
	}
	if (acess =="true") {
		contraste();
		$('#alto_contraste a').text('Restaurar contraste')		
	};
	var max = $('#aumentar_fonte');
	var min = $('#diminuir_fonte');
	var padrao = $('#fonte_padrao');
	var alto_contraste = $("#alto_contraste");
	
	function mudar_css(size){
		selector = $(".container p, .container a, .container input, .container select, .container label, .container h1, .container h2, .container h3, .container span, footer");
		selector.each(function(){
			var element = $(this);
			font_size = element.css('font-size')
			element.css('font-size',((parseInt(font_size)+(size)).toString()+"px"))
			
		});
	}
	function contraste(){
		selector_background = $("body, portlet, header, .container, footer, #menu_abas ul li, #notice, .grao_imagem");
		selector_background.each(function(){
			var element = $(this);
			element.css('background','#000');
		});
		selector_background = $(".grao_imagem, table");
		selector_background.each(function(){
			var element = $(this);
			element.css({'border': '1px solid #FF0'});
		});
		selector_background = $(".itens li, #title, .portlet, .aba, th");
		selector_background.each(function(){
			var element = $(this);
			element.css('background','#036');
		});
		selector = $("header p, .container p, footer p, header h1, .container h1, .container h2, .container h3, .container h4	, footer h1, .portlet h3, .container label, span, div");
		selector.each(function(){
			var element = $(this);
			element.css('color','#FFF');
		});
		selector = $("header a, .container a, footer a, .itens p, #title");
		selector.each(function(){
			var element = $(this);
			element.css('color','#FF0');
		});
		selector = $("input, #escolher_imagem");
		selector.each(function(){
			var element = $(this);
			element.css('color','#000');
		});
	}
	function aumentar(){
		mudar_css(2);
	}
	function diminuir(){
		mudar_css(-2);
	}
	function contraste_on(){
		contraste();
	}
	function contraste_off(){
		document.location.reload();
	}
	function refresh(){
		document.location.reload();
	}
	function verify_contraste(){
		if (acess == 'false'){
			GerarCookie("alto_contraste", "true", 0);
			acess = 'true';
			contraste_on();
			$('#alto_contraste a').text('Restaurar contraste')
		}
		else{
			ExcluirCookie("alto_contraste");
			GerarCookie("alto_contraste", "false", 0);
			acess = 'false';
			contraste_off();
			$('#alto_contraste a').text('Alto contraste')
		}
	}
	max.click(aumentar);
	min.click(diminuir);
	padrao.click(refresh);
	alto_contraste.click(verify_contraste);
});