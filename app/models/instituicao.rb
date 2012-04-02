class Instituicao < ActiveRecord::Base
  has_many :campus

  validates :nome, presence: true, uniqueness: true

  def to_s
    self.nome
  end
end
