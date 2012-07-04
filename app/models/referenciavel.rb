module Referenciavel
  def self.included(base)
    base.class_eval do
      has_one :referencia, :as => :referenciavel
      after_destroy :notificar_referencia_sobre_remocao
    end
  end

  def referencia
    attr_referencia = super
    if attr_referencia.present?
      attr_referencia
    else
      ref = Referencia.create!(referenciavel: self)
      self.referencia = ref
      ref
    end
  end

  private

  def notificar_referencia_sobre_remocao
    referencia.referenciavel_removido!
  end
end
