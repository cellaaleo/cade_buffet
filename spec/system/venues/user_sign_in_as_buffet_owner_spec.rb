require 'rails_helper'

describe "Usuário dono de buffet faz login" do
  it "e não tem buffet cadastrado" do
    # Arrange - criar usuário
    User.create!(email: "buffet@buffet.com.br", password: "senha123")

    # Act - fazer log in
    visit root_path
    click_on "Entrar"
    fill_in "E-mail", with: "buffet@buffet.com.br"
    fill_in "Senha", with: "senha123"
    within('form') do
      click_on "Entrar"
    end

    # Assert - cair na página para registrar o buffet
    expect(current_path).to eq new_venue_path
    expect(page).not_to have_link "Editar dados do Buffet"
  end

  it "e tem buffet cadastrado" do
    # Arrange - criar usuário e seu buffet
    u = User.create!(email: "buffet@buffet.com.br", password: "senha123")
    Venue.create!(brand_name: "Meu Buffet", corporate_name: "Buffet & Eventos Ltda", registration_number:"66.666.666/0001-00",
                  address: "Avenida Tal, 2000", district: "Vila Tal", city: "Recife", state: "PE", zip_code: "56655-560", 
                  phone_number: "99555-6666", email: "sac@buffet.com.br", description: "Um buffet espaçoso para eventos diversos",
                  payment_methods: "", user_id: u.id)

    # Act - fazer log in
    visit root_path
    click_on "Entrar"
    fill_in "E-mail", with: "buffet@buffet.com.br"
    fill_in "Senha", with: "senha123"
    within('form') do
      click_on "Entrar"
    end

    # Assert - cair na página do buffet
    expect(current_path).to eq venue_path(u.venue.id)
    expect(page).to have_link "Editar dados do Buffet"
    expect(page).to have_content "Meu Buffet"
  end
  
end
