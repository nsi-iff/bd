class Estatistica
  attr_reader :numero_de_usuarios_cadastrados, :numero_de_documentos_por_tipo_de_conteudo

  def initialize(ano, mes = nil)
    data_inicial = mes ? Time.new(ano, mes).beginning_of_month : Time.new(ano).beginning_of_year
    data_final = mes ? data_inicial.end_of_month : data_inicial.end_of_year
    @numero_de_usuarios_cadastrados = usuarios(data_inicial, data_final)
    @numero_de_documentos_por_tipo_de_conteudo = tipos_de_conteudo(data_inicial, data_final)
  end

  private

  def usuarios(data_inicial, data_final)
    Usuario.where('created_at between ? and ?', data_inicial, data_final).count
  end

  def tipos_de_conteudo(data_inicial, data_final)
    tipos_de_conteudo = [ArtigoDeEvento, ArtigoDePeriodico, Livro, ObjetoDeAprendizagem, PeriodicoTecnicoCientifico, Relatorio, TrabalhoDeObtencaoDeGrau]
    numeros_por_tipo_de_conteudo = []
    tipos_de_conteudo.each do |c|
      numeros_por_tipo_de_conteudo << c.where('created_at between ? and ?', data_inicial, data_final).count
    end
    numeros_por_tipo_de_conteudo
  end
end
