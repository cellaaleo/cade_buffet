require 'rails_helper'

describe 'Dono de buffet faz edita dados de sua empresa' do
  it 'a partir da página do buffet' do
    # Arrange - criar usuário e seu buffet
    u = User.create!(email: "buffet@buffet.com.br", password: "senha123")
    Venue.create!(brand_name: "Meu Buffet", corporate_name: "Buffet & Eventos Ltda", registration_number:"66.666.666/0001-00",
                  address: "Avenida Tal, 2000", district: "Vila Tal", city: "Recife", state: "PE", zip_code: "56655-560", 
                  phone_number: "99555-6666", email: "sac@buffet.com.br", description: "Um buffet espaçoso para eventos diversos",
                  payment_methods: "", user: u)

    # Act
    visit root_path
    login(u)
    click_on 'Editar dados do Buffet'

    # Assert
    expect(current_path).to eq edit_venue_path(u.venue.id)
    expect(page).to have_content 'Editar informações do seu Buffet'
    expect(page).to have_field 'Nome fantasia', with: 'Meu Buffet'
    expect(page).to have_field 'CNPJ', with: '66.666.666/0001-00'
    expect(page).to have_field 'Telefone', with: '99555-6666'
    expect(page).to have_field 'Descrição', with: 'Um buffet espaçoso para eventos diversos'
  end

  it "com sucesso" do
    # Arrange - criar usuário e seu buffet
    u = User.create!(email: "buffet@buffet.com.br", password: "senha123")
    Venue.create!(brand_name: "Meu Buffet", corporate_name: "Buffet & Eventos Ltda", registration_number:"66.666.666/0001-00",
                  address: "Avenida Tal, 2000", district: "Vila Tal", city: "Recife", state: "PE", zip_code: "56655-560", 
                  phone_number: "99555-6666", email: "sac@buffet.com.br", description: "Um buffet espaçoso para eventos diversos",
                  payment_methods: "", user: u)
    
    # Act
    visit root_path
    login(u)
    click_on 'Editar dados do Buffet'
    fill_in 'Nome fantasia', with: 'Vila Tal Eventos'
    fill_in 'E-mail', with: 'atendimento@buffeteventos.com.br'
    click_on 'Enviar'
    
    # Assert
    expect(current_path).to eq venue_path(u.venue.id)
    expect(page).to have_content 'Buffet editado com sucesso'
    expect(page).to have_link 'Editar dados do Buffet'
    expect(page).to have_content 'Vila Tal Eventos'
    expect(page).to have_content 'email: atendimento@buffeteventos.com.br'
  end
  
  it 'com dados incompletos' do
    # Arrange - criar usuário e seu buffet
    u = User.create!(email: "buffet@buffet.com.br", password: "senha123")
    Venue.create!(brand_name: "Meu Buffet", corporate_name: "Buffet & Eventos Ltda", registration_number:"66.666.666/0001-00",
                  address: "Avenida Tal, 2000", district: "Vila Tal", city: "Recife", state: "PE", zip_code: "56655-560", 
                  phone_number: "99555-6666", email: "sac@buffet.com.br", description: "Um buffet espaçoso para eventos diversos",
                  payment_methods: "", user: u)
    
    # Act
    visit root_path
    login(u)
    click_on 'Editar dados do Buffet'
    fill_in 'Nome fantasia', with: ''
    fill_in 'E-mail', with: ''
    click_on 'Enviar'
    
    # Assert
    #expect(current_path).to eq edit_venue_path(u.venue.id)
    expect(page).to have_content 'Não foi possível editar o seu buffet'
    expect(page).to have_content 'Nome fantasia não pode ficar em branco'
    expect(page).to have_content 'E-mail não pode ficar em branco'
    expect(page).to have_field 'Razão Social', with: "Buffet & Eventos Ltda"
  end
end