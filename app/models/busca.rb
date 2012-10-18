class Busca < ActiveRecord::Base
  belongs_to :usuario
  validates :titulo, presence: true
  attr_accessor :parametros, :objeto_veio_do_pronatec, :usuario_logado
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

  def resultados(filtros = {})
    if busca.blank?
      buscar_em_conteudos(filtros)
    else
      buscar_em_conteudos(filtros) + buscar_em_arquivos
    end
  end

  #TODO: Refatorar busca em conteudos, melhorar a busca pelos estados (21/08/12, 14:40, pedrolmota)
  def buscar_em_conteudos(filtros = {})
    publicados = []
    estados = {}
    estados[:state] = filtros.delete(:state) || []
    if estados[:state].empty? || estados[:state].include?('publicado')
      publicados = Tire.search('conteudos', load: true) { |t|
        t.query { |q| q.string busca } unless busca.blank?
        t.query { |q| q.string query_parametros } unless query_parametros.blank?
        t.filter(:term, filtros) if filtros.present?
        t.filter(:term, state: 'publicado')
        t.filter(:terms, _type: parametros[:tipos]) if parametros[:tipos]
      }.results.to_a
    end

    demais_estados = []
    if estados && @usuario_logado && @usuario_logado.pode_buscar_por_estados?
      estados[:state].delete('publicado') if estados[:state].include?('publicado')
      unless @usuario_logado.instituicao_admin? || @usuario_logado.admin?
        estados[:state].delete('editavel')
      end
      demais_estados = Tire.search('conteudos', load: true) { |t|
        t.query { |q| q.string busca } unless busca.blank?
        t.query { |q| q.string query_parametros } unless query_parametros.blank?
        t.filter(:term, filtros) if filtros.present?
        t.filter(:terms, estados) unless estados.any? &:empty?
        unless @usuario_logado.admin?
          t.filter(:term, nome_instituicao: @usuario_logado.instituicao.nome.downcase)
        end
        t.filter(:terms, _type: parametros[:tipos]) if parametros[:tipos]
      }.results.to_a
    end
    publicados + demais_estados
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

  def self.filtrar_busca_avancada(busca, usuario)
    tipos = busca.parametros['tipos'].clone if busca.parametros['tipos']
    tipos.delete('objeto_de_aprendizagem') if @@objeto_veio_do_pronatec
    filtro_por_estado = {}
    busca.usuario_logado = usuario

    if busca.parametros['estados']
      estados = busca.parametros['estados'].clone
      filtro_por_estado = {state: estados}
      busca.parametros.delete('estados')
    end

    @resultados = []
    # TODO: tentar juntar o loop no "elsif" com o do "if" (21/07/12, 03:40, bernardofire)
    if tipos && tipos.include?("pronatec")
      busca.resultados(filtro_por_estado).map do |conteudo|
        if conteudo.pronatec? || tipos.include?(conteudo.class.name.underscore)
          @resultados << conteudo
        end
      end
    elsif tipos && tipos.include?('objeto_de_aprendizagem')
      busca.resultados(filtro_por_estado).map do |conteudo|
        if !conteudo.pronatec?
          @resultados << conteudo
        end
      end
    else
      @resultados = busca.resultados(filtro_por_estado) if @resultados.blank?
    end
    @resultados
  end
end