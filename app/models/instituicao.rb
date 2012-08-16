class Instituicao < ActiveRecord::Base
  has_many :campi

  validates :nome, presence: true, uniqueness: true

  attr_accessible :nome

  def usuarios
    campi.map { |campus| campus.usuarios }.flatten
  end

  def to_s
    self.nome
  end
end
