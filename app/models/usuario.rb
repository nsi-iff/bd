class Usuario < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me,
                  :usuario, :nome_completo, :instituicao, :campus

  validates :email, presence: true, uniqueness: true
  validates :nome_completo, presence: true, format: { with: /^[a-z ]+$/i,
            message: 'Erro, Somente letras' }, allow_blank: true
  validates_presence_of :instituicao, :campus
end
