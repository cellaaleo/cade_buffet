require 'rails_helper'

describe "Usuário não autenticado busca um buffet" do
  it "a partir do menu" do
    # Arrange
    # Act
    visit root_path
    # Assert
    within('header #busca') do
      expect(page).to have_field 'Buscar buffet'
      expect(page).to have_button 'Buscar' 
    end
  end

  it "pelo nome fantasia ou cidade" do
    # Arrange - criar buffets
    first_user = User.create!(email: "first@email.com", password: "password")
    second_user = User.create!(email: "second@email.com", password: "password")
    third_user = User.create!(email: "third@email.com", password: "password")
    first_venue = Venue.create!(brand_name: "Pinheiros Hall", corporate_name: "Primeiro Buffet Ltda", 
                                registration_number: "11.111.1111/0001-10", address: "Rua dos Pinheiros, 1001",
                                district: "Pinheiros", city: 'São Paulo', state: "SP", zip_code: "05422-000", 
                                email: "eventos@first.com", phone_number: "(11)99110-9191", user: first_user,)
    second_venue = Venue.create!(brand_name: "Buffet São Paulo", corporate_name: "Segundo Buffet SA", 
                                registration_number: "22.222.222/0002-20", address: "Rua dos Timbiras, 2500",
                                district: "Barro Preto", city: 'Belo Horizonte', state: "MG", zip_code: "30140-000", 
                                email: "eventos@second.com", phone_number: "(31)99220-9292", user: second_user,
                                description: "Espaço ideal para casamentos, aniversários, eventos corporativos, entre outras ocasiões especiais")
    third_venue = Venue.create!(brand_name: "Buffet do Vale", corporate_name: "Terceiro Buffet",
                                registration_number: "33.333.333/0003-30", address: "Rua Vale Formoso, 33",
                                district: "Jardim das Oliveiras", city: 'Fortaleza', state: "CE", zip_code: "60820-000", 
                                email: "eventos@third.com", phone_number: "(85)99330-9393", user: third_user)
    # Act - buscar
    query = 'são paulo'
    visit root_path
    fill_in "Buscar buffet", with: query
    click_on 'Buscar'

    # Arrange - lista de resultados
    expect(page).to have_content "Resultado da busca por: #{query}"
    expect(page).to have_content '2 Buffets encontrados'
    expect(page).to have_text(:all, "Buffet São Paulo Pinheiros Hall")
    expect(page).not_to have_content 'Buffet do Vale'
  end

  it "pelo tipo de evento que oferece" do
    # Arrange - criar eventos dos buffets
    first_user = User.create!(email: "first@email.com", password: "password")
    second_user = User.create!(email: "second@email.com", password: "password")
    third_user = User.create!(email: "third@email.com", password: "password")
    first_venue = Venue.create!(brand_name: "Pinheiros Hall", corporate_name: "Primeiro Buffet Ltda", 
                                registration_number: "11.111.1111/0001-10", address: "Rua dos Pinheiros, 1001",
                                district: "Pinheiros", city: 'São Paulo', state: "SP", zip_code: "05422-000", 
                                email: "eventos@first.com", phone_number: "(11)99110-9191", user: first_user,)
    second_venue = Venue.create!(brand_name: "Casamento Mineiro Buffet", corporate_name: "Segundo Buffet SA", 
                                registration_number: "22.222.222/0002-20", address: "Rua dos Timbiras, 2500",
                                district: "Barro Preto", city: 'Belo Horizonte', state: "MG", zip_code: "30140-000", 
                                email: "eventos@second.com", phone_number: "(31)99220-9292", user: second_user,
                                description: "Espaço ideal para casamentos, aniversários, eventos corporativos, entre outras ocasiões especiais")
    third_venue = Venue.create!(brand_name: "Buffet do Vale", corporate_name: "Terceiro Buffet SA",
                                registration_number: "33.333.333/0003-30", address: "Rua Vale Formoso, 33",
                                district: "Jardim das Oliveiras", city: 'Fortaleza', state: "CE", zip_code: "60820-000", 
                                email: "eventos@third.com", phone_number: "(85)99330-9393", user: third_user)
    first_venue_event =  Event.create!(name: "Eventos corporativos", venue: first_venue)
    second_venue_event =  Event.create!(name: "Cerimônia e Festa de Casamento", venue: second_venue)
    third_venue_event =  Event.create!(name: "Festa de Casamento", venue: third_venue)
    
    # Act
    query = 'casamento'
    visit root_path
    fill_in "Buscar buffet", with: query
    click_on 'Buscar'

    # Arrange
    expect(page).to have_content "Resultado da busca por: #{query}"
    expect(page).to have_content '2 Buffets encontrados'
    expect(page).to have_text(:all, 'Buffet do Vale Casamento Mineiro Buffet')
    expect(page).not_to have_content 'Pinheiros Hall'  
  end
  
  it "e vê detalhes de um buffet" do
    # Arrange - criar buffets
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
    # Act - clicar em um nome buffet
    query = 'são paulo'
    visit root_path
    fill_in "Buscar buffet", with: query
    click_on 'Buscar'
    click_on 'Buffet São Paulo'

    # Arrange - detalhes deste buffet
    expect(current_path).to eq venue_path(second_venue.id)
  end

  it "e não encontra nenhum buffet" do
    # Arrange
    # Act - buscar
    visit root_path
    fill_in "Buscar buffet", with: 'casamento'
    click_on 'Buscar'

    # Arrange 
    expect(page).to have_content 'Nenhum buffet encontrado'
  end
end
