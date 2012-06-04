class Referencia < ActiveRecord::Base
  belongs_to :referenciavel, :polymorphic => true
  belongs_to :usuario
  validates :referenciavel, :usuario, :abnt, presence: true
end
