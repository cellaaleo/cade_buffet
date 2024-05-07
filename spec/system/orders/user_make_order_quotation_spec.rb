require 'rails_helper'

describe "Dono de buffet faz cotação do pedido" do
  it "e o evento ainda não tem preços" do
    # Arrange
    user = User.create!(email: 'buffet@email.com', password: 'password')
    venue = Venue.create!(brand_name: "Casa Jardim", corporate_name: "Casa Jardim Buffet Ltda", registration_number:"11.111.111/0001-00",
                      address: "Rua Eugênio de Medeiros, 530", district: "Pinheiros", city: "São Paulo", state: "SP", zip_code: "05050-050", 
                      phone_number: "(11)99111-1111", email: "eventosbuffet@email.com", 
                      description: "Salão de festas com decoração rústica e chique, vários ambientes, jardim arborizado e pista de dança.",
                      payment_methods: "", user: user)
    event = Event.create!(name: 'Festa de Aniversário', description: 'Festa de aniversário para todas as idades', 
                          minimum_guests_number: 50, maximum_guests_number: 120, duration: 240, menu: '...', venue: venue)
    customer = Customer.create!(name: 'Ana', cpf: '385.474.290-85', email: "ana@email.com", password: "password")
    order = Order.create!(customer: customer, event: event, venue: venue, number_of_guests: 55, event_date: 6.months.from_now)

    # Act
    login_as(user, :scope => :user)
    visit orders_path
    click_on order.code

    # Assert
    expect(page).not_to have_link 'Fazer orçamento'
    expect(page).to have_content 'Este evento ainda não possui preços cadastrados'
    expect(page).to have_link 'Cadastrar preços deste evento'
  end
  
  it "e o pedido é para um dia entre segunda e sexta-feira" do
    # Arrange
    user = User.create!(email: 'buffet@email.com', password: 'password')
    venue = Venue.create!(brand_name: "Casa Jardim", corporate_name: "Casa Jardim Buffet Ltda", registration_number:"11.111.111/0001-00",
                      address: "Rua Eugênio de Medeiros, 530", district: "Pinheiros", city: "São Paulo", state: "SP", zip_code: "05050-050", 
                      phone_number: "(11)99111-1111", email: "eventosbuffet@email.com", 
                      description: "Salão de festas com decoração rústica e chique, vários ambientes, jardim arborizado e pista de dança.",
                      payment_methods: "", user: user)
    event = Event.create!(name: 'Festa de Aniversário', description: 'Festa de aniversário para todas as idades', 
                          minimum_guests_number: 50, maximum_guests_number: 120, duration: 240, menu: '...', venue: venue)
    prices = Price.create!(weekday_base_price: 1000, weekday_plus_per_person: 100, weekday_plus_per_hour: 0,
                            weekend_base_price: 2000, weekend_plus_per_person: 200, weekend_plus_per_hour: 0, event: event)
    customer = Customer.create!(name: 'Ana', cpf: '385.474.290-85', email: "ana@email.com", password: "password")
    order = Order.create!(customer: customer, event: event, venue: venue, number_of_guests: 55, event_date: "31/07/2026") #sexta-feira

    # Act
    login_as(user, :scope => :user)
    visit orders_path
    click_on order.code
    click_on 'Fazer orçamento'

    # Assert
    expect(page).to have_content 'Orçamento do pedido'
    expect(page).to have_content 'Preço-base: 1000'
    expect(page).to have_content 'Número extra de pessoas: 5'
    expect(page).to have_content 'Adicional/pessoa: 100'
    expect(page).to have_content 'Total do adicional/pessoa: 500'
    expect(page).to have_content 'Subtotal: 1500'
  end

  it "e o pedido é para um fim de semana" do
    # Arrange
    user = User.create!(email: 'buffet@email.com', password: 'password')
    venue = Venue.create!(brand_name: "Casa Jardim", corporate_name: "Casa Jardim Buffet Ltda", registration_number:"11.111.111/0001-00",
                      address: "Rua Eugênio de Medeiros, 530", district: "Pinheiros", city: "São Paulo", state: "SP", zip_code: "05050-050", 
                      phone_number: "(11)99111-1111", email: "eventosbuffet@email.com", 
                      description: "Salão de festas com decoração rústica e chique, vários ambientes, jardim arborizado e pista de dança.",
                      payment_methods: "", user: user)
    event = Event.create!(name: 'Festa de Aniversário', description: 'Festa de aniversário para todas as idades', 
                          minimum_guests_number: 50, maximum_guests_number: 120, duration: 240, menu: '...', venue: venue)
    prices = Price.create!(weekday_base_price: 1000, weekday_plus_per_person: 100, weekday_plus_per_hour: 0,
                            weekend_base_price: 2000, weekend_plus_per_person: 200, weekend_plus_per_hour: 0, event: event)
    customer = Customer.create!(name: 'Ana', cpf: '385.474.290-85', email: "ana@email.com", password: "password")
    order = Order.create!(customer: customer, event: event, venue: venue, number_of_guests: 55, event_date: "01/08/2026") #sábado

    # Act
    login_as(user, :scope => :user)
    visit orders_path
    click_on order.code
    click_on 'Fazer orçamento'

    # Assert
    expect(page).to have_content 'Orçamento do pedido'
    expect(page).to have_content 'Preço-base: 2000'
    expect(page).to have_content 'Número extra de pessoas: 5'
    expect(page).to have_content 'Adicional/pessoa: 200'
    expect(page).to have_content 'Total do adicional/pessoa: 1000'
    expect(page).to have_content 'Subtotal: 3000'
  end

  it "e o número de convidados é menor que o mínimo que o evento atende" do
    # Arrange
    user = User.create!(email: 'buffet@email.com', password: 'password')
    venue = Venue.create!(brand_name: "Casa Jardim", corporate_name: "Casa Jardim Buffet Ltda", registration_number:"11.111.111/0001-00",
                      address: "Rua Eugênio de Medeiros, 530", district: "Pinheiros", city: "São Paulo", state: "SP", zip_code: "05050-050", 
                      phone_number: "(11)99111-1111", email: "eventosbuffet@email.com", 
                      description: "Salão de festas com decoração rústica e chique, vários ambientes, jardim arborizado e pista de dança.",
                      payment_methods: "", user: user)
    event = Event.create!(name: 'Festa de Aniversário', description: 'Festa de aniversário para todas as idades', 
                          minimum_guests_number: 50, maximum_guests_number: 120, duration: 240, menu: '...', venue: venue)
    prices = Price.create!(weekday_base_price: 1000, weekday_plus_per_person: 100, weekday_plus_per_hour: 0,
                            weekend_base_price: 2000, weekend_plus_per_person: 200, weekend_plus_per_hour: 0, event: event)
    customer = Customer.create!(name: 'Ana', cpf: '385.474.290-85', email: "ana@email.com", password: "password")
    order = Order.create!(customer: customer, event: event, venue: venue, number_of_guests: 50, event_date: "01/08/2026") #sábado

    # Act
    login_as(user, :scope => :user)
    visit orders_path
    click_on order.code
    click_on 'Fazer orçamento'

    # Assert
    expect(page).to have_content 'Orçamento do pedido'
    expect(page).to have_content 'Preço-base: 2000'
    expect(page).to have_content 'Número extra de pessoas: 0'
    expect(page).to have_content 'Adicional/pessoa: 200'
    expect(page).to have_content 'Total do adicional/pessoa: 0'
    expect(page).to have_content 'Subtotal: 2000'
  end
  
  it "com sucesso" do
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
                          event_details: 'Incluir serviço de decoração',event_date: 6.months.from_now)

    # Act
    login_as(user, :scope => :user)
    visit orders_path
    click_on order.code
    click_on 'Fazer orçamento'
    fill_in "Desconto ou taxa adicional",	with: "1000" 
    fill_in "Descrição do desconto ou taxa adicional", with: "Serviço de decoração: +R$ 1000"
    fill_in "Data de validade do orçamento", with: 10.days.from_now 
    fill_in "Meio de pagamento",	with: "Transferência bancária" 
    click_on 'Enviar orçamento'

    # Assert
    expect(current_path).to eq order_path(order.id)
    expect(page).to have_content 'Orçamento registrado com sucesso!'
    formatted_date = I18n.localize(10.days.from_now.to_date)
    expect(page).to have_content "Orçamento - Válido até #{formatted_date}"
    expect(page).to have_content 'Meio de pagamento: Transferência bancária'
  end

end
