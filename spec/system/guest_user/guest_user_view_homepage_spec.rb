require 'rails_helper'

describe "usuário não autenticado visita página inicial" do
  it 'e vê o nome da app' do
    # Arrange
    # Act
    visit root_path
    # Assert
    expect(page).to have_content 'Cadê Buffet?'
    within('nav') do
      expect(page).to have_link 'Criar uma conta'
      expect(page).to have_link 'Entrar'
    end
  end

  it 'e vê lista de buffets cadastrados' do
    # Arrange - criar usuários e seus buffets (com nome, cidade, estado)
    first_user = User.create!(email: "first@email.com", password: "password")
    second_user = User.create!(email: "second@email.com", password: "password")
    third_user = User.create!(email: "third@email.com", password: "password")
    first_venue = Venue.create!(brand_name: "Primeiro Buffet", corporate_name: "Primeiro Buffet Ltda", 
                                registration_number: "11.111.1111/0001-10", address: "Rua dos Pinheiros, 1001",
                                district: "Pinheiros", city: 'São Paulo', state: "SP", zip_code: "05422-000", 
                                email: "eventos@first.com", phone_number: "(11)99110-9191", user: first_user,)
    second_venue = Venue.create!(brand_name: "Segundo Buffet", corporate_name: "Segundo Buffet SA", 
                                registration_number: "22.222.222/0002-20", address: "Rua dos Timbiras, 2500",
                                district: "Barro Preto", city: 'Belo Horizonte', state: "MG", zip_code: "30140-000", 
                                email: "eventos@second.com", phone_number: "(31)99220-9292", user: second_user)
    third_venue = Venue.create!(brand_name: "Terceiro Buffet", corporate_name: "Terceiro Buffet",
                                registration_number: "33.333.333/0003-30", address: "Rua Vale Formoso, 33",
                                district: "Jardim das Oliveiras", city: 'Fortaleza', state: "CE", zip_code: "60820-000", 
                                email: "eventos@third.com", phone_number: "(85)99330-9393", user: third_user)
    # Act
    visit root_path
    # Assert - ver a lista destes buffets
    expect(page).to have_content 'Lista de Buffets'
    expect(page).to have_content 'Primeiro Buffet - São Paulo/SP'
    expect(page).to have_content 'Segundo Buffet - Belo Horizonte/MG'  
    expect(page).to have_content 'Terceiro Buffet - Fortaleza/CE'  
  end

  it "e vê detalhes de um buffet" do
    # Arrange
    first_user = User.create!(email: "first@email.com", password: "password")
    second_user = User.create!(email: "second@email.com", password: "password")
    third_user = User.create!(email: "third@email.com", password: "password")
    first_venue = Venue.create!(brand_name: "Pinheiros Hall", corporate_name: "Primeiro Buffet Ltda", 
                                registration_number: "11.111.1111/0001-10", address: "Rua dos Pinheiros, 1001",
                                district: "Pinheiros", city: 'São Paulo', state: "SP", zip_code: "05422-000", 
                                email: "eventos@first.com", phone_number: "(11)99110-9191", user: first_user,)
    second_venue = Venue.create!(brand_name: "Minas Buffet & Eventos", corporate_name: "Segundo Buffet SA", 
                                registration_number: "22.222.222/0002-20", address: "Rua dos Timbiras, 2500",
                                district: "Barro Preto", city: 'Belo Horizonte', state: "MG", zip_code: "30140-000", 
                                email: "eventos@second.com", phone_number: "(31)99220-9292", user: second_user,
                                description: "Espaço ideal para casamentos, aniversários, eventos corporativos, entre outras ocasiões especiais")
    third_venue = Venue.create!(brand_name: "Buffet do Vale", corporate_name: "Terceiro Buffet",
                                registration_number: "33.333.333/0003-30", address: "Rua Vale Formoso, 33",
                                district: "Jardim das Oliveiras", city: 'Fortaleza', state: "CE", zip_code: "60820-000", 
                                email: "eventos@third.com", phone_number: "(85)99330-9393", user: third_user)
    # Act
    visit root_path
    click_on "Minas Buffet & Eventos"
    # Assert
    expect(page).to have_content 'Minas Buffet & Eventos'
    expect(page).to have_content 'Barro Preto - Belo Horizonte/MG - CEP: 30140-000'
    expect(page).to have_content 'CNPJ: 22.222.222/0002-20'
    expect(page).to have_content second_venue.description
    expect(page).to have_content 'email: eventos@second.com'  
    expect(page).to have_content 'tel.: (31)99220-9292'
    expect(page).not_to have_content 'Segundo Buffet SA'
    expect(page).not_to have_link 'Cadastrar um evento'
  end
end
