$(document).ready(function() {
	input_file = $('.busca_por_imagem_form input[type=file]');
	input_file.bind('change', function(){ 
		caminho_arquivo = this.value.split('\\');
		nome_arquivo = caminho_arquivo[caminho_arquivo.length - 1]
		span_arquivo = $('#nome_arquivo');
		if(nome_arquivo.length > 19){
			nome_arquivo = nome_arquivo.substr(0, 9) + '...' + nome_arquivo.substr(nome_arquivo.length - 12, nome_arquivo.length-1)
		}
		span_arquivo.text(nome_arquivo);
	});
});