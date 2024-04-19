class Venue < ApplicationRecord
  belongs_to :user

  validates :brand_name, :corporate_name, :registration_number, :address, :district, :city, :state, :zip_code, :email, :phone_number, presence: true
  validates :registration_number, :user_id, uniqueness: true
end
