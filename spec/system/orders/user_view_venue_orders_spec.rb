require 'rails_helper'

describe "Dono de buffet os pedidos que recebeu" do
  it "e deve estar autenticado" do
    # Arrange
    # Act
    visit root_path
    # Assert
    expect(page).not_to have_link 'Pedidos'
  end

  it "e não vê outros pedidos" do
    # Arrange
    first_user = User.create!(email: 'buffet@email.com', password: 'password')
    second_user = User.create!(email: 'other_buffet@email.com', password: 'password')
    first_venue = Venue.create!(brand_name: "Casa Jardim", corporate_name: "Casa Jardim Buffet Ltda", 
                                registration_number:"11.111.111/0001-00", address: "Rua Eugênio de Medeiros, 530", 
                                district: "Pinheiros", city: "São Paulo", state: "SP", zip_code: "05050-050", 
                                phone_number: "(11)99111-1111", email: "eventosbuffet@email.com", 
                                description: "Salão de festas...", payment_methods: "Cartão de crédito", user: first_user)
    second_venue = Venue.create!(brand_name: "Casa Jardim", corporate_name: "Casa Jardim Buffet Ltda", 
                                registration_number:"22.222.222/0001-00", address: "Rua Eugênio de Medeiros, 530", 
                                district: "Pinheiros", city: "São Paulo", state: "SP", zip_code: "05050-050", 
                                phone_number: "(11)99111-1111", email: "email@email.com", 
                                description: "Salão de festas...", payment_methods: "Cartão de crédito", user: second_user)
    first_event = Event.create!(name: 'Festa de Aniversário', description: 'Festa de aniversário para todas as idades', 
                                minimum_guests_number: 50, maximun_guests_number: 120, duration: 240, 
                                menu: 'Cardápio completo e variado', venue: first_venue)
    second_event = Event.create!(name: 'Festa de Aniversário', description: 'Festa de aniversário para todas as idades', 
                                minimum_guests_number: 50, maximun_guests_number: 120, duration: 240, 
                                menu: 'Cardápio completo e variado', venue: second_venue)
    ana = Customer.create!(name: 'Ana', cpf: '385.474.290-85', email: "ana@email.com", password: "password")
    first_order = Order.create!(customer: ana, event: first_event, venue: first_venue, number_of_guests: 75, event_date: 2.months.from_now)
    second_order = Order.create!(customer: ana, event: second_event, venue: second_venue, number_of_guests: 75, event_date: 3.months.from_now)

    # Act
    login_as(first_user, :scope => :user)
    visit root_path
    click_on 'Pedidos'

    # Assert
    expect(page).to have_content first_order.code
    expect(page).not_to have_content second_order.code
  end

  it "e vê primeiro os pedidos que estão aguardando avaliação" do
    # Arrange
    user = User.create!(email: 'buffet@email.com', password: 'password')
    venue = Venue.create!(brand_name: "Casa Jardim", corporate_name: "Casa Jardim Buffet Ltda", registration_number:"11.111.111/0001-00",
                      address: "Rua Eugênio de Medeiros, 530", district: "Pinheiros", city: "São Paulo", state: "SP", zip_code: "05050-050", 
                      phone_number: "(11)99111-1111", email: "eventosbuffet@email.com", description: "...", payment_methods: "...", user: user)
    event = Event.create!(name: 'Festa de Aniversário', description: 'Festa de aniversário para todas as idades', minimum_guests_number: 50,
                          maximun_guests_number: 120, duration: 240, menu: '(Jantar com buffet e serviço de mesa)', venue: venue)
    customer = Customer.create!(name: 'Ana', cpf: '385.474.290-85', email: "ana@email.com", password: "password")
    first_order = Order.create!(customer: customer, event: event, venue: venue, number_of_guests: 75, 
                                event_date: 3.months.from_now, status: :pending)
    second_order = Order.create!(customer: customer, event: event, venue: venue, number_of_guests: 75, 
                                 event_date: 2.months.from_now, status: :confirmed)
    third_order = Order.create!(customer: customer, event: event, venue: venue, number_of_guests: 75, 
                                event_date: 1.month.from_now, status: :approved)

    # Act
    login_as(user, :scope => :user)
    visit root_path
    click_on 'Pedidos'

    # Assert
    within('#orders-sections > section:nth-child(1)') do
      expect(page).to have_content first_order.code
    end
    within('#orders-sections > section:nth-child(2)') do
      expect(page).to have_content second_order.code
    end
    within('#orders-sections > section:nth-child(3)') do
      expect(page).to have_content third_order.code
    end
  end

  it "e visita um pedido" do
    # Arrange
    user = User.create!(email: 'buffet@email.com', password: 'password')
    venue = Venue.create!(brand_name: "Casa Jardim", corporate_name: "Casa Jardim Buffet Ltda", registration_number:"11.111.111/0001-00",
                      address: "Rua Eugênio de Medeiros, 530", district: "Pinheiros", city: "São Paulo", state: "SP", zip_code: "05050-050", 
                      phone_number: "(11)99111-1111", email: "eventosbuffet@email.com", 
                      description: "Salão de festas com decoração rústica e chique, vários ambientes, jardim arborizado e pista de dança.",
                      payment_methods: "", user: user)
    event = Event.create!(name: 'Festa de Aniversário', description: 'Festa de aniversário para todas as idades', minimum_guests_number: 50,
                          maximun_guests_number: 120, duration: 240, menu: '(Jantar com buffet e serviço de mesa)', 
                          can_be_catering: true, venue: venue)
    ana = Customer.create!(name: 'Ana', cpf: '385.474.290-85', email: "ana@email.com", password: "password")
    order = Order.create!(customer: ana, event: event, venue: venue, number_of_guests: 75, event_date: 2.months.from_now)

    # Act
    login_as(user, :scope => :user)
    visit root_path
    click_on 'Pedidos'
    click_on order.code

    # Assert
    expect(page).to have_content "Pedido: #{order.code}"
    expect(page).to have_content 'Evento: Festa de Aniversário'
    formatted_date = I18n.localize(2.months.from_now.to_date)
    expect(page).to have_content "Data do evento: #{formatted_date}"
    expect(page).to have_content 'Número de convidados: 75'
    expect(page).to have_content 'Buffet responsável: Casa Jardim'
    expect(page).to have_content "Endereço do evento: #{venue.full_address}"
    expect(page).to have_content 'Situação do pedido: Aguardando avaliação do buffet'
  end

  it "e há outros pedidos para a mesma data" do
    # Arrange
    user = User.create!(email: 'buffet@email.com', password: 'password')
    venue = Venue.create!(brand_name: "Casa Jardim", corporate_name: "Casa Jardim Buffet Ltda", registration_number:"11.111.111/0001-00",
                      address: "Rua Eugênio de Medeiros, 530", district: "Pinheiros", city: "São Paulo", state: "SP", zip_code: "05050-050", 
                      phone_number: "(11)99111-1111", email: "eventosbuffet@email.com", description: "...", payment_methods: "...", user: user)
    event = Event.create!(name: 'Festa de Aniversário', description: 'Festa de aniversário para todas as idades', minimum_guests_number: 50,
                          maximun_guests_number: 120, duration: 240, menu: '(Jantar com buffet e serviço de mesa)', venue: venue)
    ana = Customer.create!(name: 'Ana', cpf: '385.474.290-85', email: "ana@email.com", password: "password")
    luis = Customer.create!(name: 'Luis', cpf: '197.424.430-09', email: "luis@email.com", password: "password")
    maria = Customer.create!(name: 'Maria', cpf: '921.946.990-15', email: "maria@email.com", password: "password")
    ana_order = Order.create!(customer: ana, event: event, venue: venue, number_of_guests: 75, 
                              event_date: 3.months.from_now, status: :pending)
    luis_order = Order.create!(customer: luis, event: event, venue: venue, number_of_guests: 75, 
                                event_date: 3.months.from_now, status: :pending)
    maria_order = Order.create!(customer: maria, event: event, venue: venue, number_of_guests: 75, 
                                event_date: 3.months.from_now, status: :confirmed)

    # Act
    login_as(user, :scope => :user)
    visit root_path
    click_on 'Pedidos'
    click_on ana_order.code

    # Assert
    expect(page).to have_content 'Atenção! Existem outros pedidos para esta data'
    expect(page).to have_link luis_order.code
    expect(page).to have_link maria_order.code 
  end

  it "e não há outro pedido para a mesma data" do
    # Arrange
    user = User.create!(email: 'buffet@email.com', password: 'password')
    venue = Venue.create!(brand_name: "Casa Jardim", corporate_name: "Casa Jardim Buffet Ltda", registration_number:"11.111.111/0001-00",
                      address: "Rua Eugênio de Medeiros, 530", district: "Pinheiros", city: "São Paulo", state: "SP", zip_code: "05050-050", 
                      phone_number: "(11)99111-1111", email: "eventosbuffet@email.com", description: "...", payment_methods: "...", user: user)
    event = Event.create!(name: 'Festa de Aniversário', description: 'Festa de aniversário para todas as idades', minimum_guests_number: 50,
                          maximun_guests_number: 120, duration: 240, menu: '(Jantar com buffet e serviço de mesa)', venue: venue)
    ana = Customer.create!(name: 'Ana', cpf: '385.474.290-85', email: "ana@email.com", password: "password")
    luis = Customer.create!(name: 'Luis', cpf: '197.424.430-09', email: "luis@email.com", password: "password")
    maria = Customer.create!(name: 'Maria', cpf: '921.946.990-15', email: "maria@email.com", password: "password")
    ana_order = Order.create!(customer: ana, event: event, venue: venue, number_of_guests: 75, 
                              event_date: 5.months.from_now, status: :pending)
    luis_order = Order.create!(customer: luis, event: event, venue: venue, number_of_guests: 75, 
                                event_date: 4.months.from_now, status: :pending)
    maria_order = Order.create!(customer: maria, event: event, venue: venue, number_of_guests: 75, 
                                event_date: 3.months.from_now, status: :confirmed)

    # Act
    login_as(user, :scope => :user)
    visit root_path
    click_on 'Pedidos'
    click_on ana_order.code

    # Assert
    expect(page).not_to have_content 'Atenção! Existem outros pedidos para esta data'
    expect(page).not_to have_link luis_order.code
    expect(page).not_to have_link maria_order.code 
  end
end