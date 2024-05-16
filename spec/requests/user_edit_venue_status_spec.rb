require 'rails_helper'

describe 'Usuário altera status do buffet' do
  context "para inativo" do
    it "e não está autenticado" do
      # Arrange 
      u = User.create!(email: "buffet@buffet.com", password: "password")
      v = Venue.create!(brand_name: "Meu Buffet", corporate_name: "Buffet & Eventos Ltda", registration_number:"66.666.666/0001-00",
                        address: "Avenida Tal, 2000", district: "Vila Tal", city: "Recife", state: "PE", zip_code: "56655-560", 
                        phone_number: "99555-6666", email: "sac@buffet.com.br", description: "Um buffet espaçoso para eventos diversos",
                        payment_methods: "", user: u, status: :active)
  
      # Act
      post(inactive_venue_path(v.id))
  
      # Assert
      expect(response).to redirect_to(new_user_session_path)  
    end
  
    it "e não é o responsável" do
      # Arrange 
      first_user = User.create!(email: "first@email.com", password: "password")
      second_user = User.create!(email: "second@email.com", password: "password")
      first_venue = Venue.create!(brand_name: "Pinheiros Hall", corporate_name: "Primeiro Buffet Ltda", description: "...",
                                  registration_number: "11.111.1111/0001-10", address: "Rua dos Pinheiros, 1001",
                                  district: "Pinheiros", city: 'São Paulo', state: "SP", zip_code: "05422-000", 
                                  email: "eventos@first.com", phone_number: "(11)99110-9191", user: first_user, status: :active)
      second_venue = Venue.create!(brand_name: "Buffet São Paulo", corporate_name: "Segundo Buffet SA",  description: "...",
                                  registration_number: "22.222.222/0002-20", address: "Rua dos Timbiras, 2500",
                                  district: "Barro Preto", city: 'Belo Horizonte', state: "MG", zip_code: "30140-000", 
                                  email: "eventos@second.com", phone_number: "(31)99220-9292", user: second_user, status: :active)
      
      # Act
      login_as(second_user, scope: :user)
      post(inactive_venue_path(first_venue.id))
  
      # Assert
      expect(response).to redirect_to(venue_path(second_venue.id)) 
    end
  end
  
  context "para ativo" do
    it "e não está autenticado" do
      # Arrange 
      u = User.create!(email: "buffet@buffet.com", password: "password")
      v = Venue.create!(brand_name: "Meu Buffet", corporate_name: "Buffet & Eventos Ltda", registration_number:"66.666.666/0001-00",
                        address: "Avenida Tal, 2000", district: "Vila Tal", city: "Recife", state: "PE", zip_code: "56655-560", 
                        phone_number: "99555-6666", email: "sac@buffet.com.br", description: "Um buffet espaçoso para eventos diversos",
                        payment_methods: "", user: u, status: :inactive)
  
      # Act
      post(active_venue_path(v.id))
  
      # Assert
      expect(response).to redirect_to(new_user_session_path)  
    end
  
    it "e não é o responsável" do
      # Arrange 
      first_user = User.create!(email: "first@email.com", password: "password")
      second_user = User.create!(email: "second@email.com", password: "password")
      first_venue = Venue.create!(brand_name: "Pinheiros Hall", corporate_name: "Primeiro Buffet Ltda", description: "...",
                                  registration_number: "11.111.1111/0001-10", address: "Rua dos Pinheiros, 1001",
                                  district: "Pinheiros", city: 'São Paulo', state: "SP", zip_code: "05422-000", 
                                  email: "eventos@first.com", phone_number: "(11)99110-9191", user: first_user, status: :inactive)
      second_venue = Venue.create!(brand_name: "Buffet São Paulo", corporate_name: "Segundo Buffet SA",  description: "...",
                                  registration_number: "22.222.222/0002-20", address: "Rua dos Timbiras, 2500",
                                  district: "Barro Preto", city: 'Belo Horizonte', state: "MG", zip_code: "30140-000", 
                                  email: "eventos@second.com", phone_number: "(31)99220-9292", user: second_user, status: :inactive)
      
      # Act
      login_as(second_user, scope: :user)
      post(active_venue_path(first_venue.id))
  
      # Assert
      expect(response).to redirect_to(venue_path(second_venue.id)) 
    end
  end
end