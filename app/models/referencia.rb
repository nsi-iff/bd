class Referencia < ActiveRecord::Base
  belongs_to :referenciavel, :polymorphic => true
  belongs_to :usuario
  validates :usuario, :abnt, presence: true
  validates :referenciavel, presence: true, :if => :new_record?
  before_validation :criar_referencia_abnt, :if => :referenciavel
  before_save :criar_tipo_do_grao, :if => lambda { |r| r.referenciavel_type == 'Grao' }

  private

  def criar_referencia_abnt
    self.abnt = self.referenciavel.referencia_abnt
  end

  def criar_tipo_do_grao
    self.tipo_do_grao = self.referenciavel.tipo
  end
end
