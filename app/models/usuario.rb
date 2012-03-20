class Usuario < ActiveRecord::Base
  has_and_belongs_to_many :papeis
  has_many :buscas
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me,
                  :usuario, :nome_completo, :instituicao, :campus,
                  :papel_ids

  validates :email, presence: true, uniqueness: true
  validates :nome_completo, presence: true, allow_blank: true
  validates_presence_of :instituicao, :campus

  def escrivaninha
    Conteudo.editaveis(self)
  end

  def estante
    Conteudo.publicados(self)
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
end
