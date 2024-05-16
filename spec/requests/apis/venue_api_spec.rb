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
      Event.create!(name: 'Eventos corporativos', minimum_guests_number: 50, 
                    maximum_guests_number: 100, duration: 240, venue: venue)
      Event.create!(name: 'Casamentos', minimum_guests_number: 50, 
                    maximum_guests_number: 100, duration: 240, venue: venue)

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
      expect(json_response["events"].class).to eq Array
      expect(json_response["events"].length).to eq 2
      expect(json_response["events"][0]["name"]).to eq "Eventos corporativos"
      expect(json_response["events"][1]["name"]).to eq "Casamentos"
    end

    it "fail if venue not found" do
      # Arrange
       # Act
       get "/api/v1/venues/99999"
       # Assert
       expect(response.status).to eq 404
    end

    it "fail if venue is inactive" do
      # Arrange
      user = User.create!(email: 'buffet@email.com', password: 'password')
      venue = Venue.create!(brand_name: "Casa Jardim", corporate_name: "Casa Jardim Buffet Ltda", 
                            registration_number:"11.111.111/0001-00", address: "Rua Eugênio de Medeiros, 530", 
                            district: "Pinheiros", city: "São Paulo", state: "SP", zip_code: "05050-050", 
                            phone_number: "(11)99111-1111", email: "eventosbuffet@email.com", 
                            description: "Espaços amplos e menus variados.",
                            payment_methods: "Transferência bancária e pix", user: user, status: :inactive)

      # Act
      get "/api/v1/venues/#{venue.id}"

      # Assert
      expect(response.status).to eq 403
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response["error"]).to eq 'Não foi possível acessar este conteúdo'
    end
    
  end

  context "GET /api/v1/venues" do
    it "list all venues" do
      # Arrange
      user = User.create!(email: 'buffet@email.com', password: 'password')
      venue = Venue.create!(brand_name: "Casa Jardim", corporate_name: "Casa Jardim Buffet Ltda", 
                            registration_number:"11.111.111/0001-00", address: "Rua Eugênio de Medeiros, 530", 
                            district: "Pinheiros", city: "São Paulo", state: "SP", zip_code: "05050-050", 
                            phone_number: "(11)99111-1111", email: "eventosbuffet@email.com", 
                            description: "Espaços amplos e menus variados.",
                            payment_methods: "Transferência bancária e pix", user: user)

      other_user = User.create!(email: 'venue@email.com', password: 'password')
      other_venue = Venue.create!(brand_name: "Buffet Festa", corporate_name: "Buffet Festa Ltda", 
                                  registration_number: "22.222.222/0002-20", address: "Rua dos Timbiras, 2500",
                                  district: "Barro Preto", city: 'Belo Horizonte', state: "MG", zip_code: "30140-000", 
                                  phone_number: "(31)99220-9292", email: "eventos@buffetfesta.com",
                                  description: "Espaços amplos e menus variados.",
                                  payment_methods: "Transferência bancária e pix", user: other_user)
      # Act
      get '/api/v1/venues'

      # Assert
      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response.class).to eq Array
      expect(json_response.length).to eq 2
      expect(json_response[0]["brand_name"]).to eq 'Casa Jardim'
      expect(json_response[1]["brand_name"]).to eq 'Buffet Festa'
    end

    it "list all active venues" do
      # Arrange
      user = User.create!(email: 'buffet@email.com', password: 'password')
      venue = Venue.create!(brand_name: "Casa Jardim", corporate_name: "Casa Jardim Buffet Ltda", 
                            registration_number:"11.111.111/0001-00", address: "Rua Eugênio de Medeiros, 530", 
                            district: "Pinheiros", city: "São Paulo", state: "SP", zip_code: "05050-050", 
                            phone_number: "(11)99111-1111", email: "eventosbuffet@email.com", 
                            description: "Espaços amplos e menus variados.", payment_methods: "Transferência bancária e pix", 
                            user: user, status: :inactive)

      other_user = User.create!(email: 'venue@email.com', password: 'password')
      other_venue = Venue.create!(brand_name: "Buffet Festa", corporate_name: "Buffet Festa Ltda", 
                                  registration_number: "22.222.222/0002-20", address: "Rua dos Timbiras, 2500",
                                  district: "Barro Preto", city: 'Belo Horizonte', state: "MG", zip_code: "30140-000", 
                                  phone_number: "(31)99220-9292", email: "eventos@buffetfesta.com",
                                  description: "Espaços amplos e menus variados.", payment_methods: "Transferência bancária e pix", 
                                  user: other_user, status: :active)
      # Act
      get '/api/v1/venues'

      # Assert
      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response.class).to eq Array
      expect(json_response.length).to eq 1
      expect(json_response[0]["brand_name"]).to eq 'Buffet Festa'
    end

    it "return empty if there is no venue" do
      # Arrange
      # Act
      get '/api/v1/venues'
      
      # Assert
      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response).to eq []
    end

    it "raise an internal error" do
      # Arrange
      allow(Venue).to receive(:all).and_raise(ActiveRecord::QueryCanceled)
      # Act
      get '/api/v1/venues'
      # Assert
      expect(response).to have_http_status(500)
    end
  end


  context "GET /api/v1/venues/search?venue=" do
    it "retorna um buffet que contenha as palavras especificadas na consulta" do
      # Arrange
      ana = User.create!(email: 'ana@email.com', password: 'password')
      ana_buffet = Venue.create!(brand_name: "Buffet da Ana", corporate_name: "Buffet da Ana Ltda", 
                            registration_number:"11.111.111/0001-00", address: "...", 
                            district: "Pinheiros", city: "São Paulo", state: "SP", zip_code: "01010-010", 
                            phone_number: "...", email: "anabuffet@email.com", 
                            description: "...", payment_methods: "...", user: ana)

      bruna = User.create!(email: 'bruna@email.com', password: 'password')
      bruna_buffet = Venue.create!(brand_name: "Buffet da Bruna", corporate_name: "Buffet da Bruna Ltda", 
                            registration_number:"22.222.222/0002-00", address: "...", 
                            district: "Ondina", city: "Salvador", state: "BA", zip_code: "40000-001", 
                            phone_number: "...", email: "brunabuffet@email.com", 
                            description: "...", payment_methods: "...", user: bruna)

      # Act
      get "/api/v1/venues/search?venue=buffet da bruna"

      # Assert
      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response.class).to eq Array
      expect(json_response.length).to eq 1
      expect(json_response[0]["brand_name"]).to eq 'Buffet da Bruna'
      expect(json_response[0].keys).not_to include("corporate_name")
    end

    it "retorna lista de buffets que contenham as palavras especificadas na consulta" do
      # Arrange
      ana = User.create!(email: 'ana@email.com', password: 'password')
      ana_buffet = Venue.create!(brand_name: "Buffet da Ana", corporate_name: "Buffet da Ana Ltda", 
                            registration_number:"11.111.111/0001-00", address: "...", 
                            district: "Pinheiros", city: "São Paulo", state: "SP", zip_code: "01010-010", 
                            phone_number: "...", email: "anabuffet@email.com", 
                            description: "...", payment_methods: "...", user: ana)

      bruna = User.create!(email: 'bruna@email.com', password: 'password')
      bruna_buffet = Venue.create!(brand_name: "Buffet da Bruna", corporate_name: "Buffet da Bruna Ltda", 
                            registration_number:"22.222.222/0002-00", address: "...", 
                            district: "Ondina", city: "Salvador", state: "BA", zip_code: "40000-001", 
                            phone_number: "...", email: "brunabuffet@email.com", 
                            description: "...", payment_methods: "...", user: bruna)

      poliana = User.create!(email: 'poliana@email.com', password: 'password')
      poliana_buffet = Venue.create!(brand_name: "Buffet da Poliana", corporate_name: "Buffet da Poliana Ltda", 
                            registration_number:"33.333.333/0003-00", address: "...", 
                            district: "Tijuca ", city: "Rio de Janeiro", state: "RJ", zip_code: "20000-001", 
                            phone_number: "...", email: "polianasbuffet@email.com", 
                            description: "...", payment_methods: "...", user: poliana)

      # Act
      get "/api/v1/venues/search?venue=ana"

      # Assert
      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response.class).to eq Array
      expect(json_response.length).to eq 2
      expect(json_response[0]["brand_name"]).to eq 'Buffet da Ana'
      expect(json_response[1]["brand_name"]).to eq 'Buffet da Poliana'
    end

    it "retorna lista de buffets ativos que contenham as palavras especificadas na consulta" do
      # Arrange
      ana = User.create!(email: 'ana@email.com', password: 'password')
      ana_buffet = Venue.create!(brand_name: "Buffet da Ana", corporate_name: "Buffet da Ana Ltda", 
                            registration_number:"11.111.111/0001-00", address: "...", 
                            district: "Pinheiros", city: "São Paulo", state: "SP", zip_code: "01010-010", 
                            phone_number: "...", email: "anabuffet@email.com", description: "...", 
                            payment_methods: "...", user: ana, status: :inactive)

      bruna = User.create!(email: 'bruna@email.com', password: 'password')
      bruna_buffet = Venue.create!(brand_name: "Buffet da Bruna", corporate_name: "Buffet da Bruna Ltda", 
                            registration_number:"22.222.222/0002-00", address: "...", 
                            district: "Ondina", city: "Salvador", state: "BA", zip_code: "40000-001", 
                            phone_number: "...", email: "brunabuffet@email.com", description: "...", 
                            payment_methods: "...", user: bruna, status: :active)

      poliana = User.create!(email: 'poliana@email.com', password: 'password')
      poliana_buffet = Venue.create!(brand_name: "Buffet da Poliana", corporate_name: "Buffet da Poliana Ltda", 
                            registration_number:"33.333.333/0003-00", address: "...", 
                            district: "Tijuca ", city: "Rio de Janeiro", state: "RJ", zip_code: "20000-001", 
                            phone_number: "...", email: "polianasbuffet@email.com", description: "...", 
                            payment_methods: "...", user: poliana, status: :active)

      # Act
      get "/api/v1/venues/search?venue=buffet"

      # Assert
      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response.class).to eq Array
      expect(json_response.length).to eq 2
      expect(json_response[0]["brand_name"]).to eq 'Buffet da Bruna'
      expect(json_response[1]["brand_name"]).to eq 'Buffet da Poliana'
    end

    it "retorna vazio se não houver buffets com as palavras especificadas na consulta" do
      # Arrange
      # Act
      get "/api/v1/venues/search?venue=buffet"

      # Assert
      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response).to eq []
    end
  end

end