class Usuario < ActiveRecord::Base
  has_and_belongs_to_many :papeis
  has_and_belongs_to_many :cesta, class_name: 'Referencia', join_table: 'referencias_nas_cestas'
  has_many :buscas
  has_and_belongs_to_many :favoritos, class_name: 'Referencia', join_table: 'favoritos'
  belongs_to :campus
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me,
                  :usuario, :nome_completo, :papel_ids, :campus_id, :confirmed_at

  validates :email, presence: true, uniqueness: true
  validates :nome_completo, presence: true, allow_blank: true

  def conteudos_editaveis
    Conteudo.where(contribuidor_id: self.id, state: 'editavel')
  end

  def conteudos_pendentes
    Conteudo.where(contribuidor_id: self.id, state: 'pendente')
  end

  def conteudos_publicados
    Conteudo.where(contribuidor_id: self.id, state: 'publicado')
  end

  def escrivaninha
    self.conteudos_editaveis + self.conteudos_pendentes
  end

  def instituicao
    self.campus.instituicao
  end

  def usuarios_gerenciaveis
    if self.admin?
      Usuario.includes(:papeis).all
    else
      self.campus.instituicao.campus.map {|campus| campus.usuarios}.flatten
    end
  end

  def estante
    self.conteudos_publicados + self.favoritos
  end

  def self.buscar_por_nome(nome, current_usuario)
    # can't use "self" instead of "current_usuario", because this is a class method =/
    usuarios = Usuario.where('nome_completo like ?', "%#{nome}%")
    if current_usuario.admin?
      usuarios
    else
      usuarios.where('campus.instituicao' => current_usuario.instituicao)
    end
  end

  def favoritar(referencia)
    favoritos << referencia
  end

  def favorito?(referencia)
    favoritos.include?(referencia)
  end

  def remover_favorito(referencia)
    favoritos.delete(referencia)
  end

  def pode_recolher?(conteudo)
    mesma_instituicao? conteudo
  end

  def method_missing(method_name, *params)
    nome_papel = method_name.to_s.chop
    todos = Papel.all.map(&:nome)
    if todos.include?(nome_papel)
      papeis.any? {|p| p.nome == nome_papel }
    else
      super
    end
  end

  def lista_de_revisao
    Conteudo.pendentes_da_instituicao(campus.instituicao)
  end

  def pode_aprovar?(conteudo)
    mesma_instituicao? conteudo
  end

  def pode_recolher?(conteudo)
    mesma_instituicao? conteudo
  end

  def pode_devolver?(conteudo)
    mesma_instituicao? conteudo
  end

  def pode_retornar_para_revisao?(conteudo)
    mesma_instituicao? conteudo
  end

  def mesma_instituicao?(conteudo)
    camp1 = Campus.find(self.campus_id)
    camp2 = Campus.find(conteudo.campus_id)
    camp1.instituicao_id == camp2.instituicao_id
  end
end
