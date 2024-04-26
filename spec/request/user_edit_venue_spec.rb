require 'rails_helper'

RSpec.describe "Usuário edita buffet", type: :request do
#describe "Usuário edita buffet" do
  it "e não está autenticado" do
    # Arrange
    user = User.create!(email: "user@email.com", password: "password")
    venue = Venue.create!(brand_name: "Pinheiros Hall", corporate_name: "Primeiro Buffet Ltda", 
                          registration_number: "11.111.1111/0001-10", address: "Rua dos Pinheiros, 1001",
                          district: "Pinheiros", city: 'São Paulo', state: "SP", zip_code: "05422-000", 
                          email: "eventos@first.com", phone_number: "(11)99110-9191", user: user)
    # Act
    patch(venue_path(venue.id), params: {venue: {phone_number: '(31)99220-9292'}})

    # Assert
    expect(response).to redirect_to(new_user_session_path) 
  end
  
  it "que não está vinculado à sua conta" do
    first_user = User.create!(email: "first@email.com", password: "password")
    second_user = User.create!(email: "second@email.com", password: "password")
    first_venue = Venue.create!(brand_name: "Pinheiros Hall", corporate_name: "Primeiro Buffet Ltda", 
                                registration_number: "11.111.1111/0001-10", address: "Rua dos Pinheiros, 1001",
                                district: "Pinheiros", city: 'São Paulo', state: "SP", zip_code: "05422-000", 
                                email: "eventos@first.com", phone_number: "(11)99110-9191", user: first_user)
    second_venue = Venue.create!(brand_name: "Buffet São Paulo", corporate_name: "Segundo Buffet SA", 
                                registration_number: "22.222.222/0002-20", address: "Rua dos Timbiras, 2500",
                                district: "Barro Preto", city: 'Belo Horizonte', state: "MG", zip_code: "30140-000", 
                                email: "eventos@second.com", phone_number: "(31)99220-9292", user: second_user,
                                description: "Espaço ideal para casamentos, aniversários, eventos corporativos, entre outras ocasiões especiais")
    
    # Act - fazer log in
    login_as(second_user, scope: :user)
    patch(venue_path(first_venue.id), params: {venue: {phone_number: '(31)99220-9292'}})

    # Assert - cair na página do buffet
    expect(response).to redirect_to(venue_path(second_venue.id))
  end 
end
