class Ability
  include CanCan::Ability

  def initialize(usuario)
    if usuario.gestor? || usuario.contribuidor?
      [ArtigoDePeriodico, ArtigoDeEvento, Livro, ObjetoDeAprendizagem,
       TrabalhoDeObtencaoDeGrau, PeriodicoTecnicoCientifico,
       Relatorio].each {|tipo| can [:create, :read], tipo }

      can :adicionar_conteudo, Usuario
      can :ter_escrivaninha, Usuario
      can :ter_estante, Usuario
    end

    if usuario.admin?
      can [:atualizar_papeis, :index, :buscar], Usuario
    end

    can [:area_privada, :escrivaninha, :estante], Usuario, { :id => usuario.id }
  end
end
