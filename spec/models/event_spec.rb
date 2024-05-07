require 'rails_helper'

RSpec.describe Event, type: :model do
  describe '#valid?' do
    context 'presence' do
      it 'false when event name is empty' do
        # Arrange
        u = User.create!(email: 'email@buffet.com.br', password: 'senhasegura')
        v = Venue.create!(brand_name: "Meu Buffet", corporate_name: "Buffet & Eventos Ltda", registration_number:"66.666.666/0001-00",
                          address: "Avenida Tal, 2000", district: "Vila Tal", city: "Recife", state: "PE", zip_code: "56655-560", 
                          phone_number: "99555-6666", email: "sac@buffet.com.br", description: "Um buffet espaçoso para eventos diversos",
                          payment_methods: "", user_id: u.id)
        e = Event.new(name:"", minimum_guests_number: 50, maximum_guests_number: 100, duration: 240, venue_id: v.id)
        # Act
        
        # Assert
        expect(e).not_to be_valid
      end

      it 'false when minimum guests number is empty' do
        # Arrange
        u = User.create!(email: 'email@buffet.com.br', password: 'senhasegura')
        v = Venue.create!(brand_name: "Meu Buffet", corporate_name: "Buffet & Eventos Ltda", registration_number:"66.666.666/0001-00",
                          address: "Avenida Tal, 2000", district: "Vila Tal", city: "Recife", state: "PE", zip_code: "56655-560", 
                          phone_number: "99555-6666", email: "sac@buffet.com.br", description: "Um buffet espaçoso para eventos diversos",
                          payment_methods: "", user_id: u.id)
        e = Event.new(name: "Evento Corporativo", minimum_guests_number: "", maximum_guests_number: 100, duration: 240, venue_id: v.id)
        # Act
        
        # Assert
        expect(e).not_to be_valid
      end

      it 'false when maximum guests number is empty' do
        # Arrange
        u = User.create!(email: 'email@buffet.com.br', password: 'senhasegura')
        v = Venue.create!(brand_name: "Meu Buffet", corporate_name: "Buffet & Eventos Ltda", registration_number:"66.666.666/0001-00",
                          address: "Avenida Tal, 2000", district: "Vila Tal", city: "Recife", state: "PE", zip_code: "56655-560", 
                          phone_number: "99555-6666", email: "sac@buffet.com.br", description: "Um buffet espaçoso para eventos diversos",
                          payment_methods: "", user_id: u.id)
        e = Event.new(name: "Evento Corporativo", minimum_guests_number: 50, maximum_guests_number: "", duration: 240, venue_id: v.id)
        # Act
        
        # Assert
        expect(e).not_to be_valid
      end

      it 'false when duration is empty' do
        # Arrange
        u = User.create!(email: 'email@buffet.com.br', password: 'senhasegura')
        v = Venue.create!(brand_name: "Meu Buffet", corporate_name: "Buffet & Eventos Ltda", registration_number:"66.666.666/0001-00",
                          address: "Avenida Tal, 2000", district: "Vila Tal", city: "Recife", state: "PE", zip_code: "56655-560", 
                          phone_number: "99555-6666", email: "sac@buffet.com.br", description: "Um buffet espaçoso para eventos diversos",
                          payment_methods: "", user_id: u.id)
        e = Event.new(name:"Evento Corporativo", minimum_guests_number: 50, maximum_guests_number: 100, duration: "", venue_id: v.id)
        # Act
        
        # Assert
        expect(e).not_to be_valid
      end
    end
  end
end
