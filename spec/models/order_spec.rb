require 'rails_helper'

RSpec.describe Order, type: :model do
  describe '#valid?' do
    it 'deve ter um código' do
      # Arrange
      user = User.create!(email: 'buffet@email.com', password: 'password')
      venue = Venue.create!(brand_name: "Casa Jardim", corporate_name: "Casa Jardim Buffet Ltda", registration_number:"11.111.111/0001-00",
                        address: "Rua Eugênio de Medeiros, 530", district: "Pinheiros", city: "São Paulo", state: "SP", zip_code: "05050-050", 
                        phone_number: "(11)99111-1111", email: "eventosbuffet@email.com", 
                        description: "Salão de festas com decoração rústica e chique, vários ambientes, jardim arborizado e pista de dança.",
                        payment_methods: "", user: user)
      event = Event.create!(name: 'Festa de Aniversário', description: 'Festa de aniversário para todas as idades', minimum_guests_number: 50,
                            maximum_guests_number: 120, duration: 240, menu: '(Jantar com buffet e serviço de mesa)', 
                            can_be_catering: true, venue: venue)
      customer = Customer.create!(name: 'Luis', cpf: '197.424.430-09', email: "luis@email.com", password: "password")
      order = Order.new(venue: venue, event: event, customer: customer, event_date: 3.months.from_now, number_of_guests: 50)
      
      # Act - salvar
      result = order.valid?
      # Assert
       expect(result).to be true
    end

    it "data do evento deve ser obrigatória" do
      # Arrange
      order = Order.new(event_date: '')
      # Act
      order.valid?
      # Assert
      expect(order.errors.include?(:event_date)).to be true
    end

    it "data do evento não pode ser inferior a um mês da data do pedido" do
      # Arrange
      order = Order.new(event_date: 1.day.from_now)
      # Act
      order.valid?
      result = order.errors.include?(:event_date)
      # Assert
      expect(result).to be true
      expect(order.errors[:event_date]).to include "deve ser a partir de #{I18n.localize(1.month.from_now.to_date)}"
    end

    it "data do evento deve ser igual ou superior a um mês da data do pedido" do
      # Arrange
      order = Order.new(event_date: 1.month.from_now)
      # Act
      order.valid?
      result = order.errors.include?(:event_date)
      # Assert
      expect(result).to be false
    end

    it "número de convidados deve ser obrigatório" do
       # Arrange
       order = Order.new(number_of_guests: '')
       # Act
       order.valid?
       # Assert
       expect(order.errors.include?(:number_of_guests)).to be true
    end

    it "número de convidados deve menor ou igual ao máximo de convidados que evento atende" do
      # Arrange
      event = Event.new(minimum_guests_number: 50, maximum_guests_number: 100)
      order = Order.new(event: event, number_of_guests: 120)
      # Act
      order.valid?
      result = order.errors.include?(:number_of_guests)
      # Assert
      expect(result).to be true
      expect(order.errors[:number_of_guests]).to include "deve ser no máximo #{event.maximum_guests_number}"
    end

  end


  describe "gera um código aleatório" do
    it "ao criar um novo pedido" do
      # Arrange
      user = User.create!(email: 'buffet@email.com', password: 'password')
      venue = Venue.create!(brand_name: "Casa Jardim", corporate_name: "Casa Jardim Buffet Ltda", registration_number:"11.111.111/0001-00",
                        address: "Rua Eugênio de Medeiros, 530", district: "Pinheiros", city: "São Paulo", state: "SP", zip_code: "05050-050", 
                        phone_number: "(11)99111-1111", email: "eventosbuffet@email.com", 
                        description: "Salão de festas com decoração rústica e chique, vários ambientes, jardim arborizado e pista de dança.",
                        payment_methods: "", user: user)
      event = Event.create!(name: 'Festa de Aniversário', description: 'Festa de aniversário para todas as idades', minimum_guests_number: 50,
                            maximum_guests_number: 120, duration: 240, menu: '(Jantar com buffet e serviço de mesa)', 
                            can_be_catering: true, venue: venue)
      customer = Customer.create!(name: 'Luis', cpf: '197.424.430-09', email: "luis@email.com", password: "password")
      order = Order.new(venue: venue, event: event, customer: customer, event_date: 3.months.from_now, number_of_guests: 50)
      
      # Act
      order.save!

      # Assert
      expect(order.code).not_to be_empty
      expect(order.code.length).to eq 8
    end
    
    it "e o código é único" do
      # Arrange
      user = User.create!(email: 'buffet@email.com', password: 'password')
      venue = Venue.create!(brand_name: "Casa Jardim", corporate_name: "Casa Jardim Buffet Ltda", registration_number:"11.111.111/0001-00",
                        address: "Rua Eugênio de Medeiros, 530", district: "Pinheiros", city: "São Paulo", state: "SP", zip_code: "05050-050", 
                        phone_number: "(11)99111-1111", email: "eventosbuffet@email.com", 
                        description: "Salão de festas com decoração rústica e chique, vários ambientes, jardim arborizado e pista de dança.",
                        payment_methods: "", user: user)
      event = Event.create!(name: 'Festa de Aniversário', description: 'Festa de aniversário para todas as idades', minimum_guests_number: 50,
                            maximum_guests_number: 120, duration: 240, menu: '(Jantar com buffet e serviço de mesa)', 
                            can_be_catering: true, venue: venue)
      customer = Customer.create!(name: 'Luis', cpf: '197.424.430-09', email: "luis@email.com", password: "password")
      first_order = Order.create!(venue: venue, event: event, customer: customer, event_date: '2025-04-30', number_of_guests: 50)
      second_order = Order.new(venue: venue, event: event, customer: customer, event_date: 3.months.from_now, number_of_guests: 50)
      
      # Act
      second_order.save!

      # Assert
      expect(second_order.code).not_to eq first_order.code
    end
  end
end
