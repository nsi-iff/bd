class Busca < ActiveRecord::Base
  belongs_to :usuario

  validates :titulo, presence: true

  def self.enviar_email_mala_direta
    ontem = (Time.now - 1.day).strftime("%d/%m/%y")
    conteudos_por_usuarios = {}

    self.where(mala_direta: true).each do |busca|
      conteudos = []
      s = Tire.search 'conteudos' do
        query { string busca.busca }
        filter :term, :data_publicado => ontem
      end
      s.results.each {|conteudo| conteudos << conteudo }

      if conteudos.present?
        if conteudos_por_usuarios.has_key?(busca.usuario.email)
          conteudos.each do |conteudo|
            conteudos_por_usuarios[busca.usuario.email] << conteudo
          end
        else
          conteudos_por_usuarios[busca.usuario.email] = conteudos
        end
      end
    end

    conteudos_por_usuarios.each_pair do |usuario_email, conteudos|
      Mailer.notificar_usuario_sobre_conteudos(usuario_email, conteudos).deliver
    end
  end
end
