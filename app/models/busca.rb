class Busca < ActiveRecord::Base
  belongs_to :usuario
  validates :titulo, presence: true

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
    busca = self.busca
    Tire.search('conteudos') {
      query { string busca }
      filter(:term, filtros) if filtros
    }.results.to_a
  end
end
