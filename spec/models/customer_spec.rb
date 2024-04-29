require 'rails_helper'

RSpec.describe Customer, type: :model do
  describe '#valid?' do
    context 'presence' do
      it 'false when name is empty' do
        # Arrange
        customer = Customer.new(name:'', cpf: '673.337.860-48', email: 'bruna@email.com', password: 'password')
        # Act
        result = customer.valid?
        # Assert
        expect(result).to eq(false)
      end

      it 'false when CPF is empty' do
        # Arrange
        customer = Customer.new(name:'Bruna', cpf:'', email: 'bruna@email.com', password: 'password')
        # Act
        result = customer.valid?
        # Assert
        expect(result).to eq(false)
      end
    end

    context 'uniqueness' do
      it 'false when CPF is already in use' do
        # Arrange
        Customer.create!(name: 'Jose', cpf: '673.337.860-48', email: 'jose@email.com', password: 'password')
        customer = Customer.new(name:'Bruna', cpf: '673.337.860-48', email: 'bruna@email.com', password: 'password')
        # Act
        result = customer.valid?
        # Assert
        expect(result).to eq(false)
      end
    end

    context 'validator' do
      it 'false when CPF is not valid' do
        # Arrange
        customer = Customer.new(name:'Bruna', cpf: '111.111.111-11', email: 'bruna@email.com', password: 'password')
        # Act
        result = customer.valid?
        # Assert
        expect(result).to eq(false)
      end
    end
  end
end
