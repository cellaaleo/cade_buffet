require 'rails_helper'

describe "Availability API" do
  context "GET /api/v1/venues/1/events/1/availability?" do
    it "the venue is available" do
      # Arrange
      user = User.create!(email: 'ana@email.com', password: 'password')
      venue = Venue.create!(brand_name: "Buffet da Ana", corporate_name: "Buffet da Ana Ltda", 
                            registration_number:"11.111.111/0001-00", address: "...", 
                            district: "Pinheiros", city: "São Paulo", state: "SP", zip_code: "01010-010", 
                            phone_number: "...", email: "anabuffet@email.com", 
                            description: "...", payment_methods: "...", user: user)
      event = Event.create!(name: 'Casamentos', minimum_guests_number: 50, 
                            maximum_guests_number: 100, duration: 240, venue: venue)
      prices = Price.create!(weekday_base_price: 1000, weekday_plus_per_person: 100, weekday_plus_per_hour: 0,
                            weekend_base_price: 2000, weekend_plus_per_person: 200, weekend_plus_per_hour: 0, event: event)
      customer = Customer.create!(name: 'Luis', cpf: '298.105.010-99', email: 'luis@email.com', password: 'password')
      Order.create!(customer: customer, event: event, venue: venue, number_of_guests: 55, 
                    event_date: 4.months.from_now.to_date, status: :pending)

      # Act
      query = "guests=50&date=#{8.months.from_now.to_date}"
      get "/api/v1/venues/#{venue.id}/events/#{event.id}/availability?#{query}"

      # Assert
      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response.keys).to include "preço_base"
      expect(json_response.keys).to include "taxa_adicional"
      expect(json_response.keys).to include "valor_final_estimado"
    end

    it "the venue is unavailable" do
      # Arrange
      user = User.create!(email: 'ana@email.com', password: 'password')
      venue = Venue.create!(brand_name: "Buffet da Ana", corporate_name: "Buffet da Ana Ltda", 
                            registration_number:"11.111.111/0001-00", address: "...", 
                            district: "Pinheiros", city: "São Paulo", state: "SP", zip_code: "01010-010", 
                            phone_number: "...", email: "anabuffet@email.com", 
                            description: "...", payment_methods: "...", user: user)
      event = Event.create!(name: 'Casamentos', minimum_guests_number: 50, 
                            maximum_guests_number: 100, duration: 240, venue: venue)
      prices = Price.create!(weekday_base_price: 1000, weekday_plus_per_person: 100, weekday_plus_per_hour: 0,
                            weekend_base_price: 2000, weekend_plus_per_person: 200, weekend_plus_per_hour: 0, event: event)
      customer = Customer.create!(name: 'Luis', cpf: '298.105.010-99', email: 'luis@email.com', password: 'password')
      Order.create!(customer: customer, event: event, venue: venue, number_of_guests: 55, 
                    event_date: 6.months.from_now.to_date, status: :confirmed)

      # Act
      query = "guests=50&date=#{6.months.from_now.to_date}"
      get "/api/v1/venues/#{venue.id}/events/#{event.id}/availability?#{query}"

      # Assert
      expect(response.status).to eq 500
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response["error"]).to eq "O buffet já está reservado para a data escolhida."
    end
    
    it "the guests number is higher than the guests number the venue can serve" do
      # Arrange
      user = User.create!(email: 'ana@email.com', password: 'password')
      venue = Venue.create!(brand_name: "Buffet da Ana", corporate_name: "Buffet da Ana Ltda", 
                            registration_number:"11.111.111/0001-00", address: "...", 
                            district: "Pinheiros", city: "São Paulo", state: "SP", zip_code: "01010-010", 
                            phone_number: "...", email: "anabuffet@email.com", 
                            description: "...", payment_methods: "...", user: user)
      event = Event.create!(name: 'Casamentos', minimum_guests_number: 50, 
                            maximum_guests_number: 100, duration: 240, venue: venue)

      # Act
      query = "guests=200&date=#{6.months.from_now.to_date}"
      get "/api/v1/venues/#{venue.id}/events/#{event.id}/availability?#{query}"

      # Assert
      expect(response.status).to eq 422
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response["error"]).to eq "O número de convidados excede a capacidade máxima do buffet para este evento."
    end
  end
end