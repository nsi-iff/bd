class Ability
  include CanCan::Ability

  def initialize(usuario)
    if usuario.gestor? || usuario.contribuidor?
      can [:create, :read], ArtigoDeEvento
    end
  end
end

