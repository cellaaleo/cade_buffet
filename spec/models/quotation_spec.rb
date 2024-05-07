require 'rails_helper'

RSpec.describe Quotation, type: :model do
  describe '#valid?' do
    context 'presence' do
      it 'false when expiry date is empty' do
        # Arrange
        quotation = Quotation.new(expiry_date: '')
        # Act
        quotation.valid?
        result = quotation.errors.include?(:expiry_date)
        # Assert
        expect(result).to be true
      end

      it 'false when payment method is empty' do
        # Arrange
        quotation = Quotation.new(payment_method: '')
        # Act
        quotation.valid?
        result = quotation.errors.include?(:payment_method)
        # Assert
        expect(result).to be true
      end
    end
  end
end
