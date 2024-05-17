require 'rails_helper'

describe "Cliente faz um pedido" do
  it "através da página do evento" do
    # Arrange
    user = User.create!(email: 'buffet@email.com', password: 'password')
    venue = Venue.create!(brand_name: "Casa Jardim", corporate_name: "Casa Jardim Buffet Ltda", registration_number:"11.111.111/0001-00",
                      address: "Rua Eugênio de Medeiros, 530", district: "Pinheiros", city: "São Paulo", state: "SP", zip_code: "05050-050", 
                      phone_number: "(11)99111-1111", email: "eventosbuffet@email.com", 
                      description: "Salão de festas com decoração rústica e chique, vários ambientes, jardim arborizado e pista de dança.",
                      payment_methods: "", user: user)
    event = Event.create!(name: 'Festa de Aniversário', description: 'Festa de aniversário para todas as idades', minimum_guests_number: 50,
                          maximum_guests_number: 120, duration: 240, menu: '(Jantar com buffet e serviço de mesa)', venue: venue)
    customer = Customer.create!(name: 'Luis', cpf: '197.424.430-09', email: "luis@email.com", password: "password")
    
    # Act
    login_as customer, :scope => :customer
    visit event_path(event.id)

    # Assert
    expect(page).to have_link 'Fazer um pedido'
  end

  it "e deve estar autenticado" do
    # Arrange
    user = User.create!(email: 'buffet@email.com', password: 'password')
    venue = Venue.create!(brand_name: "Casa Jardim", corporate_name: "Casa Jardim Buffet Ltda", registration_number:"11.111.111/0001-00",
                      address: "Rua Eugênio de Medeiros, 530", district: "Pinheiros", city: "São Paulo", state: "SP", zip_code: "05050-050", 
                      phone_number: "(11)99111-1111", email: "eventosbuffet@email.com", 
                      description: "Salão de festas com decoração rústica e chique, vários ambientes, jardim arborizado e pista de dança.",
                      payment_methods: "", user: user)
    event = Event.create!(name: 'Festa de Aniversário', description: 'Festa de aniversário para todas as idades', minimum_guests_number: 50,
                          maximum_guests_number: 120, duration: 240, menu: '(Jantar com buffet e serviço de mesa)', venue: venue)
    
    # Act
    visit event_path(event.id)
    click_on 'Fazer um pedido'

    # Assert
    expect(current_path).to eq new_customer_session_path 
  end

  it "e o buffet está inativo" do
    # Arrange
    user = User.create!(email: 'buffet@email.com', password: 'password')
    venue = Venue.create!(brand_name: "Casa Jardim", corporate_name: "Casa Jardim Buffet Ltda", registration_number:"11.111.111/0001-00",
                      address: "Rua Eugênio de Medeiros, 530", district: "Pinheiros", city: "São Paulo", state: "SP", zip_code: "05050-050", 
                      phone_number: "(11)99111-1111", email: "eventosbuffet@email.com", 
                      description: "....", payment_methods: "...", user: user, status: :inactive)
    event = Event.create!(name: 'Festa de Aniversário', description: 'Festa de aniversário para todas as idades', minimum_guests_number: 50,
                          maximum_guests_number: 120, duration: 240, menu: '(Jantar com buffet e serviço de mesa)', 
                          can_be_catering: true, venue: venue)
    customer = Customer.create!(name: 'Luis', cpf: '197.424.430-09', email: "luis@email.com", password: "password")
    
    # Act
    login_as customer, :scope => :customer
    visit new_event_order_path(event.id)

    # Assert
    expect(current_path).to eq root_path
    expect(page).to have_content 'Não foi possível acessar cadastro de pedido. Buffet inativo!'
  end

  it "e o evento está inativo" do
    # Arrange
    user = User.create!(email: 'buffet@email.com', password: 'password')
    venue = Venue.create!(brand_name: "Casa Jardim", corporate_name: "Casa Jardim Buffet Ltda", registration_number:"11.111.111/0001-00",
                      address: "Rua Eugênio de Medeiros, 530", district: "Pinheiros", city: "São Paulo", state: "SP", zip_code: "05050-050", 
                      phone_number: "(11)99111-1111", email: "eventosbuffet@email.com", 
                      description: "....", payment_methods: "...", user: user, status: :active)
    event = Event.create!(name: 'Festa de Aniversário', description: 'Festa de aniversário para todas as idades', minimum_guests_number: 50,
                          maximum_guests_number: 120, duration: 240, menu: '(Jantar com buffet e serviço de mesa)', 
                          can_be_catering: true, venue: venue, status: :inactive)
    customer = Customer.create!(name: 'Luis', cpf: '197.424.430-09', email: "luis@email.com", password: "password")
    
    # Act
    login_as customer, :scope => :customer
    visit new_event_order_path(event.id)

    # Assert
    expect(current_path).to eq root_path
    expect(page).to have_content 'Não foi possível acessar cadastro de pedido. Evento inativado pelo buffet'
  end


  it "e é possível registrar um outro endereço para a realização do evento" do
    # Arrange
    user = User.create!(email: 'buffet@email.com', password: 'password')
    venue = Venue.create!(brand_name: "Casa Jardim", corporate_name: "Casa Jardim Buffet Ltda", registration_number:"11.111.111/0001-00",
                      address: "Rua Eugênio de Medeiros, 530", district: "Pinheiros", city: "São Paulo", state: "SP", zip_code: "05050-050", 
                      phone_number: "(11)99111-1111", email: "eventosbuffet@email.com", 
                      description: "Salão de festas com decoração rústica e chique, vários ambientes, jardim arborizado e pista de dança.",
                      payment_methods: "", user: user)
    event = Event.create!(name: 'Festa de Aniversário', description: 'Festa de aniversário para todas as idades', minimum_guests_number: 50,
                          maximum_guests_number: 120, duration: 240, menu: '(Jantar com buffet e serviço de mesa)', 
                          can_be_catering: true, venue: venue)
    customer = Customer.create!(name: 'Luis', cpf: '197.424.430-09', email: "luis@email.com", password: "password")

    # Act
    login_as customer, :scope => :customer
    visit event_path(event.id)
    click_on 'Fazer um pedido'

    # Assert
    expect(page).to have_content 'Se quiser realizar o evento fora do nosso espaço, preencha o endereço abaixo:'
    expect(page).to have_field 'Endereço do evento'
  end

  it "e não é possível reaizar o evento em outro endereço" do
    # Arrange
    user = User.create!(email: 'buffet@email.com', password: 'password')
    venue = Venue.create!(brand_name: "Casa Jardim", corporate_name: "Casa Jardim Buffet Ltda", registration_number:"11.111.111/0001-00",
                      address: "Rua Eugênio de Medeiros, 530", district: "Pinheiros", city: "São Paulo", state: "SP", zip_code: "05050-050", 
                      phone_number: "(11)99111-1111", email: "eventosbuffet@email.com", 
                      description: "Salão de festas com decoração rústica e chique, vários ambientes, jardim arborizado e pista de dança.",
                      payment_methods: "", user: user)
    event = Event.create!(name: 'Festa de Aniversário', description: 'Festa de aniversário para todas as idades', minimum_guests_number: 50,
                          maximum_guests_number: 120, duration: 240, menu: '(Jantar com buffet e serviço de mesa)', 
                          can_be_catering: false, venue: venue)
    customer = Customer.create!(name: 'Luis', cpf: '197.424.430-09', email: "luis@email.com", password: "password")

    # Act
    login_as customer, :scope => :customer
    visit event_path(event.id)
    click_on 'Fazer um pedido'

    # Assert
    expect(page).not_to have_content 'Se quiser realizar o evento fora do nosso espaço, preencha o endereço abaixo:'
    expect(page).not_to have_field 'Endereço do evento'
  end
  
  it "com sucesso" do
    # Arrange
    user = User.create!(email: 'buffet@email.com', password: 'password')
    venue = Venue.create!(brand_name: "Casa Jardim", corporate_name: "Casa Jardim Buffet Ltda", registration_number:"11.111.111/0001-00",
                      address: "Rua Eugênio de Medeiros, 530", district: "Pinheiros", city: "São Paulo", state: "SP", zip_code: "05050-050", 
                      phone_number: "(11)99111-1111", email: "eventosbuffet@email.com", 
                      description: "Salão de festas com decoração rústica e chique, vários ambientes, jardim arborizado e pista de dança.",
                      payment_methods: "", user: user)
    event = Event.create!(name: 'Festa de Aniversário', description: 'Festa de aniversário para todas as idades', minimum_guests_number: 50,
                          maximum_guests_number: 120, duration: 240, menu: '(Jantar com buffet e serviço de mesa)', 
                          can_be_catering: true, venue: venue)
    customer = Customer.create!(name: 'Luis', cpf: '197.424.430-09', email: "luis@email.com", password: "password")
    
    allow(SecureRandom).to receive(:alphanumeric).with(8).and_return('ABC12345')
    # Act
    login_as customer, :scope => :customer
    visit event_path(event.id)
    click_on 'Fazer um pedido'
    fill_in "Data do evento",	with: "30/04/2025"
    fill_in "Número de convidados",	with: "80"
    fill_in "Detalhes do evento",	with: "É uma festa surpresa!"
    fill_in "Endereço do evento",	with: "Rua dos Pinheiros, 100 - Pinheiros, São Paulo/SP"
    click_on 'Enviar'

    # Assert
    expect(page).to have_content 'Pedido registrado com sucesso'
    expect(page).to have_content 'pedido ABC12345'
    expect(page).to have_content 'Evento: Festa de Aniversário'
    expect(page).to have_content 'Data do evento: 30/04/2025'
    expect(page).to have_content 'Número de convidados: 80'
    expect(page).to have_content 'Detalhes do evento: É uma festa surpresa!'
    expect(page).to have_content 'Buffet responsável: Casa Jardim'
    expect(page).to have_content 'Endereço do evento: Rua dos Pinheiros, 100 - Pinheiros, São Paulo/SP'
    expect(page).to have_content 'Situação do pedido: Aguardando avaliação do buffet'
  end

  it "com dados incompletos" do
    # Arrange
    user = User.create!(email: 'buffet@email.com', password: 'password')
    venue = Venue.create!(brand_name: "Casa Jardim", corporate_name: "Casa Jardim Buffet Ltda", registration_number:"11.111.111/0001-00",
                      address: "Rua Eugênio de Medeiros, 530", district: "Pinheiros", city: "São Paulo", state: "SP", zip_code: "05050-050", 
                      phone_number: "(11)99111-1111", email: "eventosbuffet@email.com", 
                      description: "Salão de festas com decoração rústica e chique, vários ambientes, jardim arborizado e pista de dança.",
                      payment_methods: "", user: user)
    event = Event.create!(name: 'Festa de Aniversário', description: 'Festa de aniversário para todas as idades', minimum_guests_number: 50,
                          maximum_guests_number: 120, duration: 240, menu: '(Jantar com buffet e serviço de mesa)', 
                          can_be_catering: true, venue: venue)
    customer = Customer.create!(name: 'Luis', cpf: '197.424.430-09', email: "luis@email.com", password: "password")
    
    allow(SecureRandom).to receive(:alphanumeric).with(8).and_return('ABC12345')
    # Act
    login_as customer, :scope => :customer
    visit event_path(event.id)
    click_on 'Fazer um pedido'
    fill_in "Data do evento",	with: ""
    fill_in "Número de convidados",	with: ""
    click_on 'Enviar'

    # Assert
    expect(page).to have_content 'Não foi possível registrar o pedido'
    expect(page).to have_content 'Data do evento não pode ficar em branco'
    expect(page).to have_content 'Número de convidados não pode ficar em branco'
  end
end
