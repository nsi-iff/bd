class Usuario < ActiveRecord::Base
  has_and_belongs_to_many :papeis
  has_and_belongs_to_many :favoritos, class_name: 'Conteudo'
  has_and_belongs_to_many :cesta, class_name: 'Grao', join_table: 'graos_nas_cestas'
  has_many :buscas
  belongs_to :campus
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me,
                  :usuario, :nome_completo, :papel_ids, :campus_id

  validates :email, presence: true, uniqueness: true
  validates :nome_completo, presence: true, allow_blank: true

  def escrivaninha
    Conteudo.editaveis(self) + Conteudo.pendentes(self)
  end

  def estante
    Conteudo.publicados(self) + self.favoritos
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
