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

  def resultados(filtros = nil)
    Tire.search('conteudos') { |t|
      t.query { |q| q.string busca } if busca
      t.query { |q| q.string string_queries } if string_queries
      t.filter(:term, filtros) if filtros
    }.results.to_a
  end

  def parametros
    @parametros || {}
  end

  def parametros=(param)
    @parametros = param.delete_if { |key| param.fetch(key).blank? }
  end

  def string_queries
    parametros.map { |tupla| tupla.join(':') }.join(' ')
  end
end
