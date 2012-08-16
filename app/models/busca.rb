class Busca < ActiveRecord::Base
  belongs_to :usuario
  validates :titulo, presence: true
  attr_accessor :parametros, :objeto_veio_do_pronatec
  attr_accessible :parametros, :busca, :titulo, :descricao

  def self.enviar_email_mala_direta
    puts "chegou na mala direta"
    ontem = Date.yesterday.strftime("%d/%m/%y")
    puts "Ontem: " + ontem.inspect
    conteudos_por_usuarios = Hash.new { |hash, email| hash[email] = [] }
    p conteudos_por_usuarios

    self.where(mala_direta: true).each do |busca|
      p busca
      conteudos = busca.resultados(:data_publicado => ontem)
      p conteudos
      conteudos_por_usuarios[busca.usuario.email].concat conteudos if conteudos.present?
    end

    p conteudos_por_usuarios
    conteudos_por_usuarios.each_pair do |usuario_email, conteudos|
      puts "enviou email"
      Mailer.notificar_usuario_sobre_conteudos(usuario_email, conteudos).deliver
    end
  end

  def resultados(filtros = nil)
    if busca.blank?
      buscar_em_conteudos(filtros)
    else
      buscar_em_conteudos(filtros) + buscar_em_arquivos
    end
  end

  def buscar_em_conteudos(filtros = nil)
    Tire.search('conteudos', load: true) { |t|
      t.query { |q| q.string busca } unless busca.blank?
      t.query { |q| q.string query_parametros } unless query_parametros.blank?
      t.filter(:term, filtros) if filtros
      t.filter(:terms, _type: parametros[:tipos]) if parametros[:tipos]
    }.results.to_a
  rescue Tire::Search::SearchRequestFailed
    []
  end

  def buscar_em_arquivos
    Tire.search('arquivos', load: true) { |t|
      t.query { |q| q.string busca } unless busca.blank?
    }.results.to_a.map(&:conteudo)
  rescue Tire::Search::SearchRequestFailed
    []
  end

  def parametros
    @parametros || {}
  end

  def parametros=(param)
    @parametros = param.delete_if { |key| param.fetch(key).blank? || param.fetch(key) == 'Todas' }

    tipos = @parametros['tipos']
    @@objeto_veio_do_pronatec = false
    if tipos && tipos.include?('pronatec') && !tipos.include?('objeto_de_aprendizagem')
      @parametros['tipos'] << "objeto_de_aprendizagem"
      @@objeto_veio_do_pronatec = true
    end
  end

  def query_parametros
    parametros.except(:tipos).map { |tupla| tupla.join(':') }.join(' ')
  end

  def self.filtrar_busca_avancada(busca)
    tipos = busca.parametros['tipos'].clone if busca.parametros['tipos']
    tipos.delete('objeto_de_aprendizagem') if @@objeto_veio_do_pronatec
    @resultados = []

    # TODO: tentar juntar o loop no "elsif" com o do "if" (21/07/12, 03:40, bernardofire)
    if tipos && tipos.include?("pronatec")
      busca.resultados.map do |conteudo|
        if conteudo.pronatec? || tipos.include?(conteudo.class.name.underscore)
          @resultados << conteudo
        end
      end
    elsif tipos && tipos.include?('objeto_de_aprendizagem')
      busca.resultados.map do |conteudo|
        if !conteudo.pronatec?
          @resultados << conteudo
        end
      end
    else
      @resultados = busca.resultados if @resultados.blank?
    end

    @resultados
  end
end
