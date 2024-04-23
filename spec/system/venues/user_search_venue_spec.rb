require 'rails_helper'

describe "Usuário busca um buffet" do
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

  it "pelo nome fantasia" do
    # Arrange - criar buffets
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
    # Act - buscar
    visit root_path
    fill_in "Buscar buffet", with: "buffet"
    click_on 'Buscar'

    # Arrange - lista de resultados
    expect(page).to have_content 'Resultado da busca por: buffet'
    expect(page).to have_content '2 buffets encontrados'
    expect(page).to have_text(:all, "Minas Buffet & Eventos Buffet do Vale")
  end
  

end
