require 'rails_helper'

describe "Cliente altera status do pedido" do
  it "e o pedido foi confirmado" do
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
    click_on order.code
    click_on 'Confirmar pedido'

    # Assert
    expect(current_path).to eq order_path(order.id)
    expect(page).to have_content 'Situação do pedido: Confirmado pelo cliente'
    expect(page).not_to have_button 'Confirmar pedido'
  end
  
  it "e o prazo do orçamento expirou" do
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
    Quotation.create!(order: order, expiry_date: 1.day.ago)
    
    # Act
    login_as(customer, :scope => :customer)
    visit orders_path
    click_on order.code

    # Assert
    expect(page).not_to have_button 'Confirmar pedido'
    expect(page).to have_content 'O prazo de validade do orçamento expirou!'
  end
  
end
