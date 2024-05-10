require 'rails_helper'

describe "Venue API" do
  context "GET /api/v1/venues/1/events" do
    it "list all venue's events" do
      # Arrange
      ana = User.create!(email: 'ana@email.com', password: 'password')
      first_venue = Venue.create!(brand_name: "Buffet da Ana", corporate_name: "Buffet da Ana Ltda", 
                            registration_number:"11.111.111/0001-00", address: "...", 
                            district: "Pinheiros", city: "São Paulo", state: "SP", zip_code: "01010-010", 
                            phone_number: "...", email: "anabuffet@email.com", 
                            description: "...", payment_methods: "...", user: ana)

      bruna = User.create!(email: 'bruna@email.com', password: 'password')
      second_venue = Venue.create!(brand_name: "Buffet da Bruna", corporate_name: "Buffet da Bruna Ltda", 
                            registration_number:"22.222.222/0002-00", address: "...", 
                            district: "Ondina", city: "Salvador", state: "BA", zip_code: "40000-001", 
                            phone_number: "...", email: "brunabuffet@email.com", 
                            description: "...", payment_methods: "...", user: bruna)

      Event.create!(name: 'Eventos corporativos', minimum_guests_number: 50, 
                    maximum_guests_number: 100, duration: 240, venue: first_venue)
      Event.create!(name: 'Aniversários', minimum_guests_number: 50, 
                    maximum_guests_number: 100, duration: 240, venue: second_venue)
      Event.create!(name: 'Casamentos', minimum_guests_number: 50, 
                    maximum_guests_number: 100, duration: 240, venue: second_venue)
      
      # Act
      get "/api/v1/venues/#{second_venue.id}/events"
      
      # Assert
      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response.class).to eq Array
      expect(json_response.length).to eq 2
      expect(json_response[0]["name"]).to eq 'Aniversários'
      expect(json_response[1]["name"]).to eq 'Casamentos'
    end

    it "return empty if there is no event" do
      # Arrange
      user = User.create!(email: 'ana@email.com', password: 'password')
      venue = Venue.create!(brand_name: "Buffet da Ana", corporate_name: "Buffet da Ana Ltda", 
                            registration_number:"11.111.111/0001-00", address: "...", 
                            district: "Pinheiros", city: "São Paulo", state: "SP", zip_code: "01010-010", 
                            phone_number: "...", email: "anabuffet@email.com", 
                            description: "...", payment_methods: "...", user: user)

      # Act
      get "/api/v1/venues/#{venue.id}/events"
      # Assert
      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response).to eq []
    end

    it "raise an internal error" do
      # Arrange
      user = User.create!(email: 'ana@email.com', password: 'password')
      venue = Venue.create!(brand_name: "Buffet da Ana", corporate_name: "Buffet da Ana Ltda", 
                            registration_number:"11.111.111/0001-00", address: "...", 
                            district: "Pinheiros", city: "São Paulo", state: "SP", zip_code: "01010-010", 
                            phone_number: "...", email: "anabuffet@email.com", 
                            description: "...", payment_methods: "...", user: user)

      allow(Event).to receive(:all).and_raise(ActiveRecord::QueryCanceled)
      # Act
      get "/api/v1/venues/#{venue.id}/events"
      # Assert
      expect(response).to have_http_status(500)
    end
  end
end