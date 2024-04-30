require 'rails_helper'

describe "Usuário dono de buffet faz login" do
  it "e não tem buffet cadastrado" do
    # Arrange - criar usuário
    u = User.create!(email: "buffet@buffet.com.br", password: "senha123")

    # Act - fazer log in
    visit root_path
    login(u)

    # Assert - cair na página para registrar o buffet
    expect(current_path).to eq new_venue_path
    expect(page).not_to have_link "Editar dados do Buffet"
  end

  it "e tem buffet cadastrado" do
    # Arrange - criar usuário e seu buffet
    u = User.create!(email: "buffet@buffet.com.br", password: "senha123")
    Venue.create!(brand_name: "Meu Buffet", corporate_name: "Buffet & Eventos Ltda", registration_number:"66.666.666/0001-00",
                  address: "Avenida Tal, 2000", district: "Vila Tal", city: "Recife", state: "PE", zip_code: "56655-560", 
                  phone_number: "99555-6666", email: "sac@buffet.com.br", description: "Um buffet espaçoso para eventos diversos",
                  payment_methods: "", user: u)

    # Act - fazer log in
    visit root_path
    login(u)

    # Assert - cair na página do buffet
    expect(current_path).to eq venue_path(u.venue.id)
    expect(page).to have_link "Editar dados do Buffet"
    expect(page).to have_content "Meu Buffet"
  end
  
  it "e tenta visualizar outro buffet" do
    # Arrange
    first_user = User.create!(email: "first@email.com", password: "password")
    second_user = User.create!(email: "second@email.com", password: "password")
    first_venue = Venue.create!(brand_name: "Pinheiros Hall", corporate_name: "Primeiro Buffet Ltda", 
                                registration_number: "11.111.1111/0001-10", address: "Rua dos Pinheiros, 1001",
                                district: "Pinheiros", city: 'São Paulo', state: "SP", zip_code: "05422-000", 
                                email: "eventos@first.com", phone_number: "(11)99110-9191", user: first_user,)
    second_venue = Venue.create!(brand_name: "Buffet São Paulo", corporate_name: "Segundo Buffet SA", 
                                registration_number: "22.222.222/0002-20", address: "Rua dos Timbiras, 2500",
                                district: "Barro Preto", city: 'Belo Horizonte', state: "MG", zip_code: "30140-000", 
                                email: "eventos@second.com", phone_number: "(31)99220-9292", user: second_user,
                                description: "Espaço ideal para casamentos, aniversários, eventos corporativos, entre outras ocasiões especiais")
    
    # Act - fazer log in
    login_as(first_user, :scope => :user)
    visit venue_path(second_venue.id)

    # Assert - cair na página do buffet
    expect(current_path).to eq venue_path(first_venue.id)
    expect(page).to have_content 'Acesso não permitido'  
    expect(page).to have_content 'Primeiro Buffet Ltda'
    expect(page).not_to have_content 'Segundo Buffet SA'
  end
  
  it "e não tem nenhum evento cadastrado" do
    # Arrange
    u = User.create!(email: "buffet@buffet.com.br", password: "senha123")
    Venue.create!(brand_name: "Meu Buffet", corporate_name: "Buffet & Eventos Ltda", registration_number:"66.666.666/0001-00",
                  address: "Avenida Tal, 2000", district: "Vila Tal", city: "Recife", state: "PE", zip_code: "56655-560", 
                  phone_number: "99555-6666", email: "sac@buffet.com.br", description: "Um buffet espaçoso para eventos diversos",
                  payment_methods: "", user: u)

    # Act
    login_as(u, :scope => :user )
    visit root_path

    # Assert - cair na página do buffet
    expect(page).to have_content "Nenhum evento cadastrado"
    expect(page).to have_link "Cadastrar um evento"
  end
  
end
