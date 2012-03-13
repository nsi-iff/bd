class Ability
  include CanCan::Ability

  def initialize(usuario)
    if usuario.gestor? || usuario.contribuidor?
      [ArtigoDePeriodico, ArtigoDeEvento, Livro, ObjetoDeAprendizagem,
       TrabalhoDeObtencaoDeGrau, PeriodicoTecnicoCientifico,
       Relatorio].each {|tipo| can [:create, :read, :edit, :update, :submeter], tipo }

      can [:adicionar_conteudo, :ter_escrivaninha, :ter_estante], Usuario
    end

    if usuario.gestor?
      [ArtigoDePeriodico, ArtigoDeEvento, Livro, ObjetoDeAprendizagem,
       TrabalhoDeObtencaoDeGrau, PeriodicoTecnicoCientifico,
       Relatorio].each {|tipo| can :aprovar, tipo }
      can :aprovacao, Usuario
    end

    if usuario.admin?
      can [:atualizar_papeis, :index, :buscar], Usuario
    end

    can [:area_privada, :escrivaninha, :estante], Usuario, { :id => usuario.id }
  end
end
