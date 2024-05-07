class Quotation < ApplicationRecord
  belongs_to :order

  validates :expiry_date, :payment_method, presence: true
end
