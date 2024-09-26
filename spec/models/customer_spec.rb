require 'rails_helper'

RSpec.describe Customer, type: :model do
  describe '#valid?' do
    context 'presence' do
      it 'false when name is empty' do
        customer = build :customer, name: ''

        expect(customer).not_to be_valid
        expect(customer.errors).to include :name
      end

      it 'false when CPF is empty' do
        customer = build :customer, cpf: ''

        expect(customer).not_to be_valid
        expect(customer.errors.full_messages).to include 'CPF não pode ficar em branco'
      end
    end

    context 'uniqueness' do
      it 'false when CPF is already in use' do
        create :customer, cpf: '673.337.860-48'
        customer = build :customer, cpf: '673.337.860-48'

        expect(customer).not_to be_valid
        expect(customer.errors.full_messages).to include 'CPF já está em uso'
      end
    end

    context 'validator' do
      it 'false when CPF is not valid' do
        customer = build :customer, cpf: '111.111.111-11'

        expect(customer).not_to be_valid
        expect(customer.errors.full_messages).to include 'CPF inválido'
      end
    end
  end

  describe '#description' do
    it 'shows customer description' do
      customer = create :customer, name: 'Marcella', email: 'marcella@email.com'

      expect(customer.description).to eq 'Marcella - marcella@email.com'
    end
  end
end
