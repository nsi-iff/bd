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
    if @parametros['tipos']
      if "pronatec".in? @parametros['tipos']
        @parametros['tipos'] << "objeto_de_aprendizagem"
      end
    end
  end

  def query_parametros
    parametros.except(:tipos).map { |tupla| tupla.join(':') }.join(' ')
  end
end
