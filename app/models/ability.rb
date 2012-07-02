# encoding: utf-8

class Ability
  include CanCan::Ability

  def initialize(usuario)

    usuario ||= Usuario.new    # usuário não cadastrado (convidado)

    if usuario.gestor? || usuario.contribuidor?
      can [:ter_escrivaninha, :ter_estante], Usuario
      can [:read, :edit, :update], Conteudo
    end

    if usuario.contribuidor?
      instituicao = usuario.campus.instituicao.nome
      unless instituicao == 'Não pertenço a uma Instituição da Rede Federal de EPCT'
        can [:adicionar_conteudo], Usuario
      end
      can [:create, :submeter], Conteudo
    end

    if usuario.gestor?
      can :aprovar, Conteudo do |conteudo|
        usuario.pode_aprovar? conteudo
      end
      can [:lista_de_revisao, :ter_lista_de_revisao], Usuario
    end

    if usuario.admin?
      can [:atualizar_papeis, :index, :buscar_por_nome, :usuarios_instituicao, :papeis], Usuario
    end

    if usuario.instituicao_admin?
      can [:atualizar_papeis, :index, :buscar_por_nome, :papeis], Usuario
    end

    can [:area_privada, :escrivaninha, :estante, :minhas_buscas], Usuario, { :id => usuario.id }
    can [:favoritar, :remover_favorito], Conteudo
    can [:favoritar], Grao
  end
end
