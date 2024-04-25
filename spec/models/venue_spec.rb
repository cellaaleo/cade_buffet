require 'rails_helper'

RSpec.describe Venue, type: :model do
  describe '#valid?' do
    context 'presence' do
      it 'false when brand name is empty' do
        # Arrange
        u = User.create!(email: 'email@buffet.com.br', password: 'senhasegura')
        v = Venue.new(brand_name: "", corporate_name: "Buffet & Eventos Ltda", registration_number:"66.666.666/0001-00",
                      address: "Avenida Tal, 2000", district: "Vila Tal", city: "Recife", state: "PE", zip_code: "56655-560", 
                      phone_number: "99555-6666", email: "sac@buffet.com.br", description: "Um buffet espaçoso para eventos diversos",
                      payment_methods: "", user_id: u.id)
        # Act
        result = v.valid?
        # Assert
        expect(result).to eq(false)
      end

      it 'false when corporate name is empty' do
        # Arrange
        u = User.create!(email: 'email@buffet.com.br', password: 'senhasegura')
        v = Venue.new(brand_name: "Meu Buffet", corporate_name: "", registration_number:"66.666.666/0001-00",
                      address: "Avenida Tal, 2000", district: "Vila Tal", city: "Recife", state: "PE", zip_code: "56655-560", 
                      phone_number: "99555-6666", email: "sac@buffet.com.br", description: "Um buffet espaçoso para eventos diversos",
                      payment_methods: "", user_id: u.id)
        # Act
        result = v.valid?
        # Assert
        expect(result).to eq(false)
      end

      it 'false when registration number is empty' do
        # Arrange
        u = User.create!(email: 'email@buffet.com.br', password: 'senhasegura')
        v = Venue.new(brand_name: "Meu Buffet", corporate_name: "Buffet & Eventos Ltda", registration_number:"",
                      address: "Avenida Tal, 2000", district: "Vila Tal", city: "Recife", state: "PE", zip_code: "56655-560", 
                      phone_number: "99555-6666", email: "sac@buffet.com.br", description: "Um buffet espaçoso para eventos diversos",
                      payment_methods: "", user_id: u.id)
        # Act
        result = v.valid?
        # Assert
        expect(result).to eq(false)
      end

      it 'false when address is empty' do
        # Arrange
        u = User.create!(email: 'email@buffet.com.br', password: 'senhasegura')
        v = Venue.new(brand_name: "Meu Buffet", corporate_name: "Buffet & Eventos Ltda", registration_number:"66.666.666/0001-00",
                      address: "", district: "Vila Tal", city: "Recife", state: "PE", zip_code: "56655-560", 
                      phone_number: "99555-6666", email: "sac@buffet.com.br", description: "Um buffet espaçoso para eventos diversos",
                      payment_methods: "", user_id: u.id)
        # Act
        result = v.valid?
        # Assert
        expect(result).to eq(false)
      end

      it 'false when district is empty' do
        # Arrange
        u = User.create!(email: 'email@buffet.com.br', password: 'senhasegura')
        v = Venue.new(brand_name: "Meu Buffet", corporate_name: "Buffet & Eventos Ltda", registration_number:"66.666.666/0001-00",
                      address: "Avenida Tal, 2000", district: "", city: "Recife", state: "PE", zip_code: "56655-560", 
                      phone_number: "99555-6666", email: "sac@buffet.com.br", description: "Um buffet espaçoso para eventos diversos",
                      payment_methods: "", user_id: u.id)
        # Act
        result = v.valid?
        # Assert
        expect(result).to eq(false)
      end

      it 'false when city is empty' do
        # Arrange
        u = User.create!(email: 'email@buffet.com.br', password: 'senhasegura')
        v = Venue.new(brand_name: "Meu Buffet", corporate_name: "Buffet & Eventos Ltda", registration_number:"66.666.666/0001-00",
                      address: "Avenida Tal, 2000", district: "Vila Tal", city: "", state: "PE", zip_code: "56655-560", 
                      phone_number: "99555-6666", email: "sac@buffet.com.br", description: "Um buffet espaçoso para eventos diversos",
                      payment_methods: "", user_id: u.id)
        # Act
        result = v.valid?
        # Assert
        expect(result).to eq(false)
      end

      it 'false when state is empty' do
        # Arrange
        u = User.create!(email: 'email@buffet.com.br', password: 'senhasegura')
        v = Venue.new(brand_name: "Meu Buffet", corporate_name: "Buffet & Eventos Ltda", registration_number:"66.666.666/0001-00",
                      address: "Avenida Tal, 2000", district: "Vila Tal", city: "Recife", state: "", zip_code: "56655-560", 
                      phone_number: "99555-6666", email: "sac@buffet.com.br", description: "Um buffet espaçoso para eventos diversos",
                      payment_methods: "", user_id: u.id)
        # Act
        result = v.valid?
        # Assert
        expect(result).to eq(false)
      end

      it 'false when zip code is empty' do
        # Arrange
        u = User.create!(email: 'email@buffet.com.br', password: 'senhasegura')
        v = Venue.new(brand_name: "Meu Buffet", corporate_name: "Buffet & Eventos Ltda", registration_number:"66.666.666/0001-00",
                      address: "Avenida Tal, 2000", district: "Vila Tal", city: "Recife", state: "PE", zip_code: "", 
                      phone_number: "99555-6666", email: "sac@buffet.com.br", description: "Um buffet espaçoso para eventos diversos",
                      payment_methods: "", user_id: u.id)
        # Act
        result = v.valid?
        # Assert
        expect(result).to eq(false)
      end

      it 'false when email is empty' do
        # Arrange
        u = User.create!(email: 'email@buffet.com.br', password: 'senhasegura')
        v = Venue.new(brand_name: "Meu Buffet", corporate_name: "Buffet & Eventos Ltda", registration_number:"66.666.666/0001-00",
                      address: "Avenida Tal, 2000", district: "Vila Tal", city: "Recife", state: "PE", zip_code: "56655-560", 
                      phone_number: "99555-6666", email: "", description: "Um buffet espaçoso para eventos diversos",
                      payment_methods: "", user_id: u.id)
        # Act
        result = v.valid?
        # Assert
        expect(result).to eq(false)
      end

      it 'false when phone number is empty' do
        # Arrange
        u = User.create!(email: 'email@buffet.com.br', password: 'senhasegura')
        v = Venue.new(brand_name: "Meu Buffet", corporate_name: "Buffet & Eventos Ltda", registration_number:"66.666.666/0001-00",
                      address: "Avenida Tal, 2000", district: "Vila Tal", city: "Recife", state: "PE", zip_code: "56655-560", 
                      phone_number: "", email: "sac@buffet.com.br", description: "Um buffet espaçoso para eventos diversos",
                      payment_methods: "", user_id: u.id)
        # Act
        result = v.valid?
        # Assert
        expect(result).to eq(false)
      end
    end

    context 'uniqueness' do
      it 'false when registrantion number is already in use' do
        # Arrange
        first_user = User.create!(email: "buffet@buffet.com.br", password: "senha123")
        first_venue = Venue.create!(brand_name: "Meu Buffet", corporate_name: "Buffet & Eventos Ltda", registration_number:"66.666.666/0001-00",
                                    address: "Avenida Tal, 2000", district: "Vila Tal", city: "Recife", state: "PE", zip_code: "56655-560", 
                                    phone_number: "99555-6666", email: "sac@buffet.com.br", description: "Um buffet espaçoso para eventos diversos",
                                    payment_methods: "", user_id: first_user.id)

        second_user = User.create!(email: "eventos@vilanova.com.br", password: "senhasegura")
        second_venue = Venue.new(brand_name: "Vila Nova Buffet", corporate_name: "Buffet & Eventos Vila Nova Ltda", registration_number:"66.666.666/0001-00",
                                  address: "Avenida da Vila, 2000", district: "Vila Nova", city: "São Paulo", state: "SP", zip_code: "02655-000", 
                                  phone_number: "99222-0100", email: "sac@vilanovabuffet.com.br", description: "",
                                  payment_methods: "", user_id: second_user.id)

        # Act
        # Assert
        expect(second_venue).not_to be_valid
      end

      it 'false when user already has a buffet' do
        # Arrange
        first_user = User.create!(email: "buffet@buffet.com.br", password: "senha123")
        first_venue = Venue.create!(brand_name: "Meu Buffet", corporate_name: "Buffet & Eventos Ltda", registration_number:"66.666.666/0001-00",
                                    address: "Avenida Tal, 2000", district: "Vila Tal", city: "Recife", state: "PE", zip_code: "56655-560", 
                                    phone_number: "99555-6666", email: "sac@buffet.com.br", description: "Um buffet espaçoso para eventos diversos",
                                    payment_methods: "", user_id: first_user.id)

        
        second_venue = Venue.new(brand_name: "Vila Nova Buffet", corporate_name: "Buffet & Eventos Vila Nova Ltda", registration_number:"33.333.333/0001-00",
                                  address: "Avenida da Vila, 2000", district: "Vila Nova", city: "São Paulo", state: "SP", zip_code: "02655-000", 
                                  phone_number: "99222-0100", email: "sac@vilanovabuffet.com.br", description: "",
                                  payment_methods: "", user_id: first_user.id)

        # Act
        # Assert
        expect(second_venue).not_to be_valid
      end
    end
  end
end
