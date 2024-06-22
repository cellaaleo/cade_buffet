require 'rails_helper'

describe 'Usuário altera status do buffet' do
  it "e o buffet fica inativo" do
    # Arrange 
    u = FactoryBot.create(:user)
    Venue.create!(brand_name: "Meu Buffet", corporate_name: "Buffet & Eventos Ltda", registration_number:"66.666.666/0001-00",
                  address: "Avenida Tal, 2000", district: "Vila Tal", city: "Recife", state: "PE", zip_code: "56655-560", 
                  phone_number: "99555-6666", email: "sac@buffet.com.br", description: "Um buffet espaçoso para eventos diversos",
                  payment_methods: "", user: u, status: :active)

    # Act
    login_as(u, scope: :user)
    visit root_path
    click_on 'Desativar buffet'

    # Assert
    expect(page).to have_button 'Reativar buffet'
    expect(page).not_to have_button 'Desativar buffet'
  end

  it "e não aparece para visitantes na página inicial" do
    # Arrange 
    first_user = User.create!(email: "first@email.com", password: "password")
    second_user = User.create!(email: "second@email.com", password: "password")
    third_user = User.create!(email: "third@email.com", password: "password")
    first_venue = Venue.create!(brand_name: "Primeiro Buffet", corporate_name: "Primeiro Buffet Ltda", description: "...",
                                registration_number: "11.111.1111/0001-10", address: "Rua dos Pinheiros, 1001",
                                district: "Pinheiros", city: 'São Paulo', state: "SP", zip_code: "05422-000", 
                                email: "eventos@first.com", phone_number: "(11)99110-9191", user: first_user, status: :active)
    second_venue = Venue.create!(brand_name: "Segundo Buffet", corporate_name: "Segundo Buffet SA",  description: "...",
                                registration_number: "22.222.222/0002-20", address: "Rua dos Timbiras, 2500",
                                district: "Barro Preto", city: 'Belo Horizonte', state: "MG", zip_code: "30140-000", 
                                email: "eventos@second.com", phone_number: "(31)99220-9292", user: second_user, status: :inactive)
    third_venue = Venue.create!(brand_name: "Terceiro Buffet", corporate_name: "Terceiro Buffet SA",  description: "...",
                                registration_number: "33.333.333/0000-00", address: "Rua do Terceiro, 300",
                                district: "Centro", city: 'Igarapava', state: "SP", zip_code: "10130-000", 
                                email: "eventos@thrird.com", phone_number: "(16)99220-9292", user: third_user, status: :active)
    
    # Act
    visit root_path

    # Assert
    expect(page).to have_content first_venue.brand_name
    expect(page).not_to have_content second_venue.brand_name
    expect(page).to have_content third_venue.brand_name
  end

  it "e não aparece no resultado de uma busca" do
    # Arrange 
    first_user = User.create!(email: "first@email.com", password: "password")
    first_venue = Venue.create!(brand_name: "Primeiro Buffet", corporate_name: "Primeiro Buffet Ltda", description: "...",
                                registration_number: "11.111.1111/0001-10", address: "Rua dos Pinheiros, 1001",
                                district: "Pinheiros", city: 'São Paulo', state: "SP", zip_code: "05422-000", 
                                email: "eventos@first.com", phone_number: "(11)99110-9191", user: first_user, status: :inactive)
    
    # Act
    visit root_path
    fill_in "Buscar buffet", with: 'Primeiro Buffet'
    click_on 'Buscar'

    # Arrange 
    expect(page).to have_content 'Nenhum buffet encontrado'
  end
  
end