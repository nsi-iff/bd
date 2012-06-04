class Referencia < ActiveRecord::Base
  belongs_to :referenciavel, :polymorphic => true
  validates :referenciavel, presence: true
end