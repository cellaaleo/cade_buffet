class Quotation < ApplicationRecord
  belongs_to :order

  #validates :expiry_date, presence: true
end
