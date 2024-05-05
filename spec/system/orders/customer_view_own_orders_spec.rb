require 'rails_helper'

describe "Cliente vê os próprios pedidos" do
  it "e deve estar autenticado" do
    # Arrange
    # Act
    visit root_path
    # Assert
    expect(page).not_to have_link 'Meus pedidos'
  end

  it "e não vê outros pedidos" do
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
    luis = Customer.create!(name: 'Luis', cpf: '197.424.430-09', email: "luis@email.com", password: "password")
    first_order = Order.create!(customer: ana, event: event, venue: venue, number_of_guests: 75, event_date: 2.months.from_now)
    second_order = Order.create!(customer: luis, event: event, venue: venue, number_of_guests: 75, event_date: 2.months.from_now)
    third_order = Order.create!(customer: ana, event: event, venue: venue, number_of_guests: 75, event_date: 2.months.from_now)

    # Act
    login_as(ana, :scope => :customer)
    visit root_path
    click_on 'Meus pedidos'

    # Assert
    expect(page).to have_content first_order.code
    expect(page).not_to have_content second_order.code
    expect(page).to have_content third_order.code
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
    login_as(ana, :scope => :customer)
    visit root_path
    click_on 'Meus pedidos'
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

  it "e o pedido foi aprovado pelo buffet" do
    # Arrange
    user = User.create!(email: 'buffet@email.com', password: 'password')
    venue = Venue.create!(brand_name: "Casa Jardim", corporate_name: "Casa Jardim Buffet Ltda", registration_number:"11.111.111/0001-00",
                      address: "Rua Eugênio de Medeiros, 530", district: "Pinheiros", city: "São Paulo", state: "SP", zip_code: "05050-050", 
                      phone_number: "(11)99111-1111", email: "eventosbuffet@email.com", 
                      description: "Salão de festas com decoração rústica e chique, vários ambientes, jardim arborizado e pista de dança.",
                      payment_methods: "", user: user)
    event = Event.create!(name: 'Festa de Aniversário', description: 'Festa de aniversário para todas as idades', 
                          minimum_guests_number: 50, maximun_guests_number: 120, duration: 240, menu: '...', venue: venue,
                          has_decorations: true)
    prices = Price.create!(weekday_base_price: 1000, weekday_plus_per_person: 100, weekday_plus_per_hour: 0,
                            weekend_base_price: 2000, weekend_plus_per_person: 200, weekend_plus_per_hour: 0, event: event)
    customer = Customer.create!(name: 'Ana', cpf: '385.474.290-85', email: "ana@email.com", password: "password")
    order = Order.create!(customer: customer, event: event, venue: venue, number_of_guests: 55, 
                          event_details: 'Incluir serviço de decoração',event_date: 6.months.from_now, status: :approved)
    Quotation.create!(order: order, expiry_date: 10.days.from_now)
    
    # Act
    login_as(customer, :scope => :customer)
    visit orders_path
    within('#orders-sections .approved-orders') do
      click_on order.code
    end

    # Assert
    expect(page).to have_content 'Situação do pedido: Aprovado pelo buffet'
    formatted_date = I18n.localize(10.days.from_now.to_date)
    expect(page).to have_content "Orçamento - Válido até #{formatted_date}"
  end
end