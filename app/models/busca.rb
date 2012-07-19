class Busca < ActiveRecord::Base
  belongs_to :usuario
  validates :titulo, presence: true
  attr_accessor :parametros
  attr_accessible :parametros, :busca, :titulo, :descricao

  def self.enviar_email_mala_direta
    ontem = Date.yesterday.strftime("%d/%m/%y")
    conteudos_por_usuarios = Hash.new { |hash, email| hash[email] = [] }

    self.where(mala_direta: true).each do |busca|
      conteudos = busca.resultados(:data_publicado => ontem)
      conteudos_por_usuarios[busca.usuario.email].concat conteudos if conteudos.present?
    end

    conteudos_por_usuarios.each_pair do |usuario_email, conteudos|
      Mailer.notificar_usuario_sobre_conteudos(usuario_email, conteudos).deliver
    end
  end

  #TODO: refatorar
  def resultados(filtros = nil)
    if parametros.blank?
      buscar_em_conteudos(filtros) + buscar_em_arquivos
    elsif busca.blank?
      buscar_em_conteudos(filtros)
    else
      buscar_em_conteudos(filtros) & buscar_em_arquivos
    end
  end

  def buscar_em_conteudos(filtros = nil)
    Tire.search('conteudos', load: true) { |t|
      t.query { |q| q.string busca } unless busca.blank?
      t.query { |q| q.string query_parametros } unless query_parametros.blank?
      t.filter(:term, filtros) if filtros
      t.filter(:terms, _type: parametros[:tipos]) if parametros[:tipos]
    }.results.to_a
  end

  def buscar_em_arquivos
    Tire.search('arquivos', load: true) { |t|
      t.query { |q| q.string busca } unless busca.blank?
    }.results.to_a.map(&:conteudo)
  end

  def parametros
    @parametros || {}
  end

  def parametros=(param)
    @parametros = param.delete_if { |key| param.fetch(key).blank? || param.fetch(key) == 'Todas' }
    tipos = @parametros['tipos']
    if tipos && tipos.include?('pronatec') && !tipos.include?('objeto_de_aprendizagem')
      @parametros['tipos'] << "objeto_de_aprendizagem"
      @objeto_veio_do_pronatec = true
    end
  end

  def query_parametros
    parametros.except(:tipos).map { |tupla| tupla.join(':') }.join(' ')
  end

  def self.filtrar_busca_avancada(busca)
    tipos = busca.parametros['tipos']
    @resultados = []
    if tipos && tipos.include?("pronatec")
      busca.resultados.map do |conteudo|
        objeto = @objeto_veio_do_pronatec
        if conteudo.pronatec?
          @resultados << conteudo
        elsif conteudo.is_a?(ObjetoDeAprendizagem) && !@objeto_veio_do_pronatec
          @resultados << conteudo
        else
          @resultados << conteudo
        end
      end
      @resultados
    end
    @resultados = busca.resultados if @resultados.blank?
  end
end
