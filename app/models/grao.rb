class Grao < ActiveRecord::Base
  belongs_to :conteudo
  has_many :referencias, :as => :referenciavel
  delegate :referencia_abnt, :to => :conteudo
  before_destroy :notificar_usuarios_sobre_remocao

  attr_accessible :tipo, :key

  def arquivo?
    tipo == 'files'
  end

  def imagem?
    tipo == 'images'
  end

  def tipo_humanizado
    arquivo? ? "arquivo" : (imagem? ? "imagem" : nil)
  end

  def conteudo_base64
    resposta = sam.get(key)
    resposta['data']['file']
  end

  private

  def notificar_usuarios_sobre_remocao
    Referencia.where(referenciavel_id: self.id, referenciavel_type: 'Grao').find_each do |r|
      Mailer.notificar_usuarios_grao_removido(r.usuario, self).deliver
    end
  end
end
