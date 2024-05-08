require 'rails_helper'

describe "Venue API" do
  context "GET /api/v1/venues/1" do
    it "success" do
      # Arrange
      user = User.create!(email: 'buffet@email.com', password: 'password')
      venue = Venue.create!(brand_name: "Casa Jardim", corporate_name: "Casa Jardim Buffet Ltda", 
                            registration_number:"11.111.111/0001-00", address: "Rua Eugênio de Medeiros, 530", 
                            district: "Pinheiros", city: "São Paulo", state: "SP", zip_code: "05050-050", 
                            phone_number: "(11)99111-1111", email: "eventosbuffet@email.com", 
                            description: "Espaços amplos e menus variados.",
                            payment_methods: "Transferência bancária e pix", user: user)
      # Act
      get "/api/v1/venues/#{venue.id}"

      # Assert
      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response["brand_name"]).to eq 'Casa Jardim'
      expect(json_response["address"]).to eq 'Rua Eugênio de Medeiros, 530'
      expect(json_response["district"]).to eq 'Pinheiros'
      expect(json_response["city"]).to eq 'São Paulo'
      expect(json_response["state"]).to eq 'SP'
      expect(json_response["zip_code"]).to eq '05050-050'
      expect(json_response["phone_number"]).to eq '(11)99111-1111'
      expect(json_response["email"]).to eq 'eventosbuffet@email.com'
      expect(json_response["description"]).to eq 'Espaços amplos e menus variados.'
      expect(json_response["payment_methods"]).to eq 'Transferência bancária e pix'
      expect(json_response.keys).not_to include("corporate_name")
      expect(json_response.keys).not_to include("registration_number")
      expect(json_response.keys).not_to include("user_id")
      expect(json_response.keys).not_to include("created_at")
      expect(json_response.keys).not_to include("updated_at")
    end
  end
  
end