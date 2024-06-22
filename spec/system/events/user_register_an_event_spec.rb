require 'rails_helper'

describe "dono de buffet registra tipo de evento" do
  it "se estiver autenticado" do
    u = User.create!(email: 'buffet@email.com.br', password: 'password', buffet_owner: true)
    v = Venue.create!(brand_name: "Buffet Pinheiros", corporate_name: "Pinheiros Eventos Ltda", registration_number:"11.111.111/0001-00",
                      address: "Rua Eugênio de Medeiros, 530", district: "Pinheiros", city: "São Paulo", state: "SP", zip_code: "05050-050", 
                      phone_number: "(11)99111-1111", email: "eventospinheiros@email.com.br", 
                      description: "Salão de festas com decoração rústica e chique, vários ambientes, jardim arborizado e pista de dança.",
                      payment_methods: "", user: u)
    # Act
    visit new_venue_event_path(v.id)
    # Assert
    expect(current_path).to eq new_user_session_path
  end
  
  it 'a partir da página do seu buffet' do
    # Arrange criar usuário e buffet
    u = User.create!(email: 'buffet@email.com.br', password: 'password', buffet_owner: true)
    v = Venue.create!(brand_name: "Buffet Pinheiros", corporate_name: "Pinheiros Eventos Ltda", registration_number:"11.111.111/0001-00",
                      address: "Rua Eugênio de Medeiros, 530", district: "Pinheiros", city: "São Paulo", state: "SP", zip_code: "05050-050", 
                      phone_number: "(11)99111-1111", email: "eventospinheiros@email.com.br", 
                      description: "Salão de festas com decoração rústica e chique, vários ambientes, jardim arborizado e pista de dança.",
                      payment_methods: "", user: u)
    # Act
    login_as u, :scope => :user
    visit root_path
    within('main') do
      click_on 'Cadastrar um evento'
    end

    # Assert
    expect(page).to have_content 'Cadastre um tipo de evento'
    expect(page).to have_field 'Nome do evento'
    expect(page).to have_field 'Descrição'
    expect(page).to have_field 'Quantidade mínima de convidados'
    expect(page).to have_field 'Quantidade máxima de convidados'
    expect(page).to have_field 'Tempo de duração padrão'
    expect(page).to have_field 'Cardápio'
    expect(page).to have_unchecked_field 'Bebidas alcoólicas'
    expect(page).to have_unchecked_field 'Decoração'
    expect(page).to have_unchecked_field 'Estacionamento'
    expect(page).to have_unchecked_field 'Valet'
    expect(page).to have_unchecked_field 'Catering'
    expect(page).to have_button 'Enviar'
  end

  it 'com sucesso' do
    # Arrange
    u = User.create!(email: 'buffet@email.com.br', password: 'password')
    v = Venue.create!(brand_name: "Buffet Pinheiros", corporate_name: "Pinheiros Eventos Ltda", registration_number:"11.111.111/0001-00",
                      address: "Rua Eugênio de Medeiros, 530", district: "Pinheiros", city: "São Paulo", state: "SP", zip_code: "05050-050", 
                      phone_number: "(11)99111-1111", email: "eventospinheiros@email.com.br", 
                      description: "Salão de festas com decoração rústica e chique, vários ambientes, jardim arborizado e pista de dança.",
                      payment_methods: "", user: u)
    # Act
    login_as u, :scope => :user
    visit root_path
    within('main') do
      click_on 'Cadastrar um evento'
    end
    fill_in "Nome do evento",	with: "Casamento"
    fill_in "Descrição",	with: "Festas e recepções de casamento"
    fill_in "Quantidade mínima de convidados",	with: "60"
    fill_in "Quantidade máxima de convidados",	with: "200"
    fill_in "Tempo de duração padrão",	with: "240"
    fill_in "Cardápio",	with: "Brunchs, Almoços, Jantares..."
    page.check "event_has_alcoholic_drinks"
    page.check "event_has_parking_service"
    click_on "Enviar"
    
    # Assert
    expect(page).to have_content 'Evento cadastrado com sucesso!'
    expect(page).to have_content 'Casamento'
    expect(page).to have_content 'Festas e recepções de casamento'
    expect(page).to have_content 'mín. 60 | máx. 200 convidados'
    expect(page).to have_content 'bebidas alcoólicas'
    expect(page).to have_content 'estacionamento'
    expect(page).not_to have_content 'decoração'
    expect(page).not_to have_content 'valet'
    expect(page).not_to have_content 'catering'
    expect(page).to have_content 'Evento realizado exclusivamente em nosso espaço'
  end

  it "com dados incompletos" do
    # Arrange
    u = User.create!(email: 'buffet@email.com.br', password: 'password')
    v = Venue.create!(brand_name: "Buffet Pinheiros", corporate_name: "Pinheiros Eventos Ltda", registration_number:"11.111.111/0001-00",
                      address: "Rua Eugênio de Medeiros, 530", district: "Pinheiros", city: "São Paulo", state: "SP", zip_code: "05050-050", 
                      phone_number: "(11)99111-1111", email: "eventospinheiros@email.com.br", 
                      description: "Salão de festas com decoração rústica e chique, vários ambientes, jardim arborizado e pista de dança.",
                      payment_methods: "", user: u)
    # Act
    login_as u, :scope => :user
    visit root_path
    within('main') do
      click_on 'Cadastrar um evento'
    end
    fill_in "Nome do evento",	with: "Casamento"
    fill_in "Descrição",	with: "Festas e recepções de casamento"
    fill_in "Quantidade mínima de convidados",	with: ""
    fill_in "Quantidade máxima de convidados",	with: ""
    fill_in "Tempo de duração padrão",	with: ""
    fill_in "Cardápio",	with: "Brunchs, Almoços, Jantares..."
    click_on "Enviar"
    
    # Assert
    expect(page).to have_content 'Evento não cadastrado'
    expect(page).to have_content 'Quantidade mínima de convidados não pode ficar em branco'
    expect(page).to have_content 'Quantidade máxima de convidados não pode ficar em branco'
    expect(page).to have_content 'Tempo de duração padrão (em minutos) não pode ficar em branco'
  end
  
  it "e aparece na página do seu buffet" do
    # Arrange
    u = User.create!(email: 'buffet@email.com.br', password: 'password')
    v = Venue.create!(brand_name: "Buffet Pinheiros", corporate_name: "Pinheiros Eventos Ltda", registration_number:"11.111.111/0001-00",
                      address: "Rua Eugênio de Medeiros, 530", district: "Pinheiros", city: "São Paulo", state: "SP", zip_code: "05050-050", 
                      phone_number: "(11)99111-1111", email: "eventospinheiros@email.com.br", 
                      description: "Salão de festas com decoração rústica e chique, vários ambientes, jardim arborizado e pista de dança.",
                      payment_methods: "", user: u)
    Event.create!(name: 'Eventos corporativos', minimum_guests_number: 50, maximum_guests_number: 100, duration: 240, venue: v)
    Event.create!(name: 'Aniversários', minimum_guests_number: 50, maximum_guests_number: 100, duration: 240, venue: v)

    # Act
    login_as u, :scope => :user
    visit root_path

    # Assert
    expect(page).to have_link 'Eventos corporativos'
    expect(page).to have_link 'Aniversários' 
  end
  
  it "e não vê eventos de outros buffets" do
    # Arrange
    first_user = User.create!(email: 'buffet@email.com.br', password: 'password')
    first_venue = Venue.create!(brand_name: "Buffet Pinheiros", corporate_name: "Pinheiros Eventos Ltda", registration_number:"11.111.111/0001-00",
                      address: "Rua Eugênio de Medeiros, 530", district: "Pinheiros", city: "São Paulo", state: "SP", zip_code: "05050-050", 
                      phone_number: "(11)99111-1111", email: "eventospinheiros@email.com.br", 
                      description: "Salão de festas com decoração rústica e chique, vários ambientes, jardim arborizado e pista de dança.",
                      payment_methods: "", user: first_user)
    second_user = User.create!(email: 'casajardim@email.com.br', password: 'password')
    second_venue = Venue.create!(brand_name: "Casa Jardim", corporate_name: "Casa Jardim Buffet Ltda", registration_number:"22.222.222/0002-00",
                      address: "Av. Brasil, 2000", district: "Centor", city: "Rio de Janeiro", state: "RJ", zip_code: "12345-050", 
                      phone_number: "(21)99222-2222", email: "eventoscasajardim@email.com.br", 
                      description: "Salão de festas com decoração rústica e chique, vários ambientes, jardim arborizado e pista de dança.",
                      payment_methods: "", user: second_user)
    Event.create!(name: 'Eventos corporativos', minimum_guests_number: 50, maximum_guests_number: 100, duration: 240, venue: first_venue)
    Event.create!(name: 'Casamento', minimum_guests_number: 50, maximum_guests_number: 100, duration: 240, venue: second_venue)

    # Act
    login_as first_user, :scope => :user
    visit root_path

    # Assert
    expect(page).not_to have_link 'Casamento'
  end
  
end
