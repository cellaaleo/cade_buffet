class Venue < ApplicationRecord
  belongs_to :user
  has_one_attached :photo
  has_many :events, dependent: :destroy
  has_many :orders, dependent: :restrict_with_exception
  enum status: { active: 0, inactive: 1 }

  validates :brand_name, :corporate_name, :registration_number,
            :address, :district, :city, :state, :zip_code, :email, :phone_number, presence: true
  validates :registration_number, :user_id, uniqueness: true

  def full_address
    "#{address} - #{district} - #{city}/#{state} - CEP: #{zip_code}"
  end
end
