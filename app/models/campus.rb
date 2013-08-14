class Campus < ActiveRecord::Base
  belongs_to :instituicao
  has_many :usuarios
  has_many :conteudos

  validates :nome, presence: true, uniqueness: true
  validates :instituicao_id, presence: true
  validates_associated :instituicao

  def to_s
    nome
  end

  def nome_instituicao
    instituicao.nome
  end
end
