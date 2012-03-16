class Estatistica
  attr_reader :numero_de_usuarios_cadastrados

  def initialize(ano, mes = nil)
    @numero_de_usuarios_cadastrados = mes ? usuarios_por_mes(mes, ano) : usuarios_por_ano(ano)
  end

  def acessos_por_conteudo_individual
    
  end

  def acessos_por_tipo_de_conteudo
    
  end

  def acessos_por_sub_area_de_conhecimento
    
  end

  private
  
  def usuarios_por_mes(mes, ano)
    data_inicial = Time.new(ano, mes).beginning_of_month
    data_final = Time.new(ano, mes).end_of_month
    Usuario.where('created_at between ? and ?', data_inicial, data_final).count
  end

  def usuarios_por_ano(ano)
    data_inicial = Time.new(ano).beginning_of_year
    data_final = Time.new(ano).end_of_year
    Usuario.where('created_at between ? and ?', data_inicial, data_final).count
  end
end
