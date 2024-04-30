class Customer < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  has_many :orders
  
  validates :name, :cpf, presence: true
  validates :cpf, cpf: { message: 'CPF inválido' }
  validates :cpf, uniqueness: true

  def description
  "#{name} - #{email}"
  end
end
