require 'rails_helper'

describe "Usuário registra valores de um evento" do
  it "a partir da página de seu buffet" do
    # Arrange - criar user, venue, event
    u = User.create!(email: 'tiella@email.com.br', password: 'tiella123')
    v = Venue.create!(brand_name: "Tiella", corporate_name: "Tiella Eventos Ltda", registration_number:"11.111.111/0001-00",
                      address: "Rua Eugênio de Medeiros, 530", district: "Pinheiros", city: "São Paulo", state: "SP", zip_code: "05050-050", 
                      phone_number: "(11)99111-1111", email: "eventostiella@email.com.br", 
                      description: "Salão de festas com decoração rústica e chique, vários ambientes, jardim arborizado e pista de dança.",
                      payment_methods: "", user: u)

    # Act - clicar em link para registrar os valores deste evento
    visit root_path
    login(u)
    click_on 'Cadastrar preços de eventos'
    
    # Assert - chegar na página de registro
    expect(page).to have_content 'Cadastro de preços:'
    expect(page).to have_field 'evento'
    expect(page).to have_field 'preço-base'
    expect(page).to have_field 'taxa adicional por pessoa'
    expect(page).to have_field 'hora extra'
    expect(page).to have_button 'Enviar'
  end

  it "com sucesso" do
    # Arrange
    u = User.create!(email: 'tiella@email.com.br', password: 'tiella123')
    v = Venue.create!(brand_name: "Tiella", corporate_name: "Tiella Eventos Ltda", registration_number:"11.111.111/0001-00",
                      address: "Rua Eugênio de Medeiros, 530", district: "Pinheiros", city: "São Paulo", state: "SP", zip_code: "05050-050", 
                      phone_number: "(11)99111-1111", email: "eventostiella@email.com.br", 
                      description: "Salão de festas com decoração rústica e chique, vários ambientes, jardim arborizado e pista de dança.",
                      payment_methods: "", user: u)
    first_e = Event.create!(name: 'Casamento', description: 'Festas e recepções de casamento', minimum_guests_number: 50,
                      maximun_guests_number: 150, duration: 240, menu: '(opções de brunch, almoço e jantar)', 
                      has_alcoholic_drinks: true, has_decorations: true, has_parking_service: true,
                      has_valet_service: true, can_be_catering: true, venue: v)
    second_e = Event.create!(name: 'Festa de 15 anos', description: 'Festa e baile de 15 anos', minimum_guests_number: 50,
                      maximun_guests_number: 120, duration: 240, menu: '(Jantar com buffet e serviço de mesa)', 
                      has_alcoholic_drinks: false, has_decorations: true, has_parking_service: true,
                      has_valet_service: true, can_be_catering: false, venue: v)

    # Act
    visit root_path
    login(u)
    click_on 'Cadastrar preços de eventos'
    select second_e.name, from: 'tipo de evento'
    within('#weekdays_prices') do
      fill_in 'preço-base', with: 10000
      fill_in 'taxa adicional por pessoa', with: 250
      fill_in 'hora extra', with: 1000
    end
    within('#weekends_prices') do
      fill_in 'preço-base', with: 14000
      fill_in 'taxa adicional por pessoa', with: 300
      fill_in 'hora extra', with: 1500
    end
    click_on 'Enviar'
    
    # Assert
    expect(current_path).to eq event_path(second_e.id)
    expect(page).to have_content 'Preços cadastrados com sucesso'
    expect(page).to have_content 'Festa de 15 anos'
    expect(page).to have_content 'Valor inicial: R$ 10000,00 (50 convidados)'
  end
end
