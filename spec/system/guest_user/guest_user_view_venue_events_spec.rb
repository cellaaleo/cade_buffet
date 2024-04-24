require 'rails_helper'

describe "Usuário não autenticado vê detalhes de um buffet" do
  it "e vê lista de eventos que ele oferece" do
    # Arrange - criar user, buffet, 2 eventos
    first_user = User.create!(email: "first@email.com", password: "password")
    second_user = User.create!(email: "second@email.com", password: "password")
    first_venue = Venue.create!(brand_name: "Pinheiros Hall", corporate_name: "Primeiro Buffet Ltda", 
                                registration_number: "11.111.1111/0001-10", address: "Rua dos Pinheiros, 1001",
                                district: "Pinheiros", city: 'São Paulo', state: "SP", zip_code: "05422-000", 
                                email: "eventos@first.com", phone_number: "(11)99110-9191", user: first_user)
    second_venue = Venue.create!(brand_name: "Buffet do Vale", corporate_name: "Terceiro Buffet",
                                registration_number: "33.333.333/0003-30", address: "Rua Vale Formoso, 33",
                                district: "Jardim das Oliveiras", city: 'Fortaleza', state: "CE", zip_code: "60820-000", 
                                email: "eventos@third.com", phone_number: "(85)99330-9393", user: second_user)
    one_first_venue_event = Event.create!(name: "Eventos corporativos", description: 'Evento para promover a interação entre o público interno e clientes', 
                                          minimum_guests_number: 80, maximun_guests_number: 120, duration: 240, 
                                          menu: 'brunch ou coffee break', has_valet_service: true, can_be_catering: true,
                                          venue: first_venue)
    other_first_venue_event = Event.create!(name: "Casamento", description: 'Recepção e festa de casamento',
                                            minimum_guests_number: 80, maximun_guests_number: 120, duration: 240, 
                                            menu: 'brunch e coffee breaks', has_valet_service: true, venue: first_venue)
    one_second_venue_event = Event.create!(name: "Festa de 15 anos", venue: second_venue)
    # Act - clicar no buffet na ágina inicial
    visit root_path
    click_on 'Pinheiros Hall'

    # Assert - ver a lista de eventos do buffet
    expect(page).to have_content 'Eventos corporativos'
    expect(page).to have_content 'Casamento'
    expect(page).not_to have_content 'Festa de 15 anos'
  end


  it "e vê todos os detalhes de um evento" do
    # Arrange
    user = User.create!(email: "first@email.com", password: "password")
    venue = Venue.create!(brand_name: "Pinheiros Hall", corporate_name: "Primeiro Buffet Ltda", 
                          registration_number: "11.111.1111/0001-10", address: "Rua dos Pinheiros, 1001",
                          district: "Pinheiros", city: 'São Paulo', state: "SP", zip_code: "05422-000", 
                          email: "eventos@first.com", phone_number: "(11)99110-9191", user: user)
    Event.create!(name: "Eventos corporativos", description: 'Evento para promover a interação entre o público interno e clientes', 
                  minimum_guests_number: 80, maximun_guests_number: 120, duration: 240, 
                  menu: 'brunch ou coffee break', has_valet_service: true, can_be_catering: true,
                  venue: venue)
    event = Event.create!(name: "Casamentos", description: 'Recepção e festa de casamento',
                          minimum_guests_number: 80, maximun_guests_number: 120, duration: 240, 
                          menu: 'brunch e coffee breaks', has_valet_service: true, venue: venue)
    Price.create!(weekday_base_price: 10000, weekday_plus_per_person: 100, weekday_plus_per_hour: 1500, 
                  weekend_base_price: 15000, weekend_plus_per_person: 150, weekend_plus_per_hour: 2000, event: event)

    # Act 
    visit root_path
    click_on 'Pinheiros Hall'
    click_on 'Casamento'

    # Assert
    expect(page).to have_content "#{event.description}"
    expect(page).to have_content 'Casamentos'
    expect(page).to have_content 'Evento realizado exclusivamente em nosso espaço'
    expect(page).to have_content 'de 80 até o máximo de 120 convidados'
    expect(page).to have_content '240 minutos de duração'
    expect(page).to have_content 'valet'
    expect(page).to have_content 'Valor inicial: R$ 10000,00'
    expect(page).to have_content 'Taxa extra por pessoa: R$ 100,00'
    expect(page).to have_content 'Taxa por hora adicional: R$ 1500,00'
    expect(page).to have_content 'Valor inicial: R$ 15000,00'
    expect(page).to have_content 'Taxa extra por pessoa: R$ 150,00'
    expect(page).to have_content 'Taxa por hora adicional: R$ 2000,00'
    expect(page).not_to have_content 'Eventos corporativos'
    expect(page).not_to have_content 'catering'
  end
  
end
