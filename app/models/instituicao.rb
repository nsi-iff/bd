class Instituicao < ActiveRecord::Base
  has_many :campus

  validates :nome, presence: true, uniqueness: true
  
  attr_accessible :nome

  def usuarios
    campus.map { |campus| campus.usuarios }.flatten
  end

  def to_s
    self.nome
  end
end
