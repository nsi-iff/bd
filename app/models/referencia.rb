class Referencia < ActiveRecord::Base
  belongs_to :referenciavel, :polymorphic => true
  validates :abnt, presence: true
  validates :referenciavel, presence: true, :if => :new_record?
  before_validation :criar_referencia_abnt, :if => :referenciavel
  before_save :criar_tipo_do_grao, :if => lambda { |r| r.referenciavel_type == 'Grao' }
  has_and_belongs_to_many :favoritadores, class_name: 'Usuario', join_table: 'favoritos'

  def referenciavel_removido!
    favoritadores.each do |favoritador|
      Mailer.notificar_usuarios_referenciavel_removido(favoritador, self.referenciavel).deliver
    end
  end
  
  def self.referenciavel_por_id_referencia(referencia_id)
    find_by_id(referencia_id).try(:referenciavel)
  end

  private

  def criar_referencia_abnt
    self.abnt = self.referenciavel.referencia_abnt
  end

  def criar_tipo_do_grao
    self.tipo_do_grao = self.referenciavel.tipo
  end
end
