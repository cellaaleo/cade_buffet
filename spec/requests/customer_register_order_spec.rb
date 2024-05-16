require 'rails_helper'

describe "Cliente cria novo pedido" do
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
    post(event_orders_path(event.id), params: {order: {customer_id: customer.id, venue_id: venue.id, event_id: event.id,
                                                       event_date: 4.months.from_now, number_of_guests: 50}})

    # Assert
    expect(response).to redirect_to(root_path)
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
    post(event_orders_path(event.id), params: {order: {customer_id: customer.id, venue_id: venue.id, event_id: event.id,
                                                       event_date: 4.months.from_now, number_of_guests: 50}})

    # Assert
    expect(response).to redirect_to(root_path)
  end
end