class Ability
  include CanCan::Ability

  def initialize(usuario)
    if usuario.gestor? || usuario.contribuidor?
      can [:ter_escrivaninha, :ter_estante], Usuario
    end

    if usuario.contribuidor?
      can [:create, :read, :edit, :update, :submeter], Conteudo
      can :adicionar_conteudo, Usuario
    end

    if usuario.gestor?
      can [:aprovar, :read, :edit, :update], Conteudo
      can [:lista_de_revisao, :ter_lista_de_revisao], Usuario
    end

    if usuario.admin?
      can [:atualizar_papeis, :index, :buscar], Usuario
    end

    can [:area_privada, :escrivaninha, :estante, :minhas_buscas], Usuario, { :id => usuario.id }
    can [:favoritar, :remover_favorito], Conteudo
  end
end
