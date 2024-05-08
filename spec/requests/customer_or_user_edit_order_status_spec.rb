require 'rails_helper'

RSpec.describe "Usuário edita buffet" do
  it "e não está autenticado" do
    # Arrange
    user = User.create!(email: 'buffet@email.com', password: 'password')
    venue = Venue.create!(brand_name: "Casa Jardim", corporate_name: "Casa Jardim Buffet Ltda", registration_number:"11.111.111/0001-00",
                      address: "Rua Eugênio de Medeiros, 530", district: "Pinheiros", city: "São Paulo", state: "SP", zip_code: "05050-050", 
                      phone_number: "(11)99111-1111", email: "eventosbuffet@email.com", 
                      description: "Salão de festas com decoração rústica e chique, vários ambientes, jardim arborizado e pista de dança.",
                      payment_methods: "", user: user)
    event = Event.create!(name: 'Festa de Aniversário', description: 'Festa de aniversário para todas as idades', 
                          minimum_guests_number: 50, maximum_guests_number: 120, duration: 240, menu: '...', venue: venue,
                          has_decorations: true)
    prices = Price.create!(weekday_base_price: 1000, weekday_plus_per_person: 100, weekday_plus_per_hour: 0,
                            weekend_base_price: 2000, weekend_plus_per_person: 200, weekend_plus_per_hour: 0, event: event)
    customer = Customer.create!(name: 'Ana', cpf: '385.474.290-85', email: "ana@email.com", password: "password")
    order = Order.create!(customer: customer, event: event, venue: venue, number_of_guests: 55, 
                          event_details: 'Incluir serviço de decoração',event_date: 6.months.from_now, status: :pending)
    # Act
    post(canceled_order_path(order.id))
    
    # Assert
    expect(response).to redirect_to(new_customer_session_path)
  end

  it "e não é o cliente responsável" do
    # Arrange
    lala = User.create!(email: 'lala@email.com', password: 'password')
    user = User.create!(email: 'buffet@email.com', password: 'password')
    venue = Venue.create!(brand_name: "Casa Jardim", corporate_name: "Casa Jardim Buffet Ltda", registration_number:"11.111.111/0001-00",
                      address: "Rua Eugênio de Medeiros, 530", district: "Pinheiros", city: "São Paulo", state: "SP", zip_code: "05050-050", 
                      phone_number: "(11)99111-1111", email: "eventosbuffet@email.com", 
                      description: "Salão de festas com decoração rústica e chique, vários ambientes, jardim arborizado e pista de dança.",
                      payment_methods: "", user: user)
    event = Event.create!(name: 'Festa de Aniversário', description: 'Festa de aniversário para todas as idades', 
                          minimum_guests_number: 50, maximum_guests_number: 120, duration: 240, menu: '...', venue: venue,
                          has_decorations: true)
    prices = Price.create!(weekday_base_price: 1000, weekday_plus_per_person: 100, weekday_plus_per_hour: 0,
                            weekend_base_price: 2000, weekend_plus_per_person: 200, weekend_plus_per_hour: 0, event: event)
    ana = Customer.create!(name: 'Ana', cpf: '385.474.290-85', email: "ana@email.com", password: "password")
    bruna = Customer.create!(name: 'Bruna', cpf: '743.095.110-40', email: "bruna@email.com", password: "password")
    order = Order.create!(customer: ana, event: event, venue: venue, number_of_guests: 55, 
                          event_details: 'Incluir serviço de decoração',event_date: 6.months.from_now, status: :approved)
    
    # Act
    login_as(bruna, :scope => :customer)
    post(confirmed_order_path(order.id))
    
    # Assert
    expect(response).to redirect_to(root_path)
  end

  it "e não é o dono do buffet responsável" do
    # Arrange
    other_user = User.create!(email: 'other_user@email.com', password: 'password')
    user = User.create!(email: 'buffet@email.com', password: 'password')
    venue = Venue.create!(brand_name: "Casa Jardim", corporate_name: "Casa Jardim Buffet Ltda", registration_number:"11.111.111/0001-00",
                      address: "Rua Eugênio de Medeiros, 530", district: "Pinheiros", city: "São Paulo", state: "SP", zip_code: "05050-050", 
                      phone_number: "(11)99111-1111", email: "eventosbuffet@email.com", 
                      description: "Salão de festas com decoração rústica e chique, vários ambientes, jardim arborizado e pista de dança.",
                      payment_methods: "", user: user)
    event = Event.create!(name: 'Festa de Aniversário', description: 'Festa de aniversário para todas as idades', 
                          minimum_guests_number: 50, maximum_guests_number: 120, duration: 240, menu: '...', venue: venue,
                          has_decorations: true)
    prices = Price.create!(weekday_base_price: 1000, weekday_plus_per_person: 100, weekday_plus_per_hour: 0,
                            weekend_base_price: 2000, weekend_plus_per_person: 200, weekend_plus_per_hour: 0, event: event)
    ana = Customer.create!(name: 'Ana', cpf: '385.474.290-85', email: "ana@email.com", password: "password")
    order = Order.create!(customer: ana, event: event, venue: venue, number_of_guests: 55, 
                          event_details: 'Incluir serviço de decoração',event_date: 6.months.from_now, status: :pending)
    
    # Act
    login_as(other_user, :scope => :user)
    post(approved_order_path(order.id))
    
    # Assert
    expect(response).to redirect_to(root_path)
  end
  
end