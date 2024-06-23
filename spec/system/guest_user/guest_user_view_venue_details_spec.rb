require 'rails_helper'

describe "usuário não autenticado vê detalhes de um buffet" do
  it "e o buffet não tem foto cadastrada" do
    u = FactoryBot.create(:user)
    v = FactoryBot.create(:venue, user: u, brand_name: 'Buffet Nova Era')

    visit root_path
    click_on 'Buffet Nova Era'

    expect(page).not_to have_css('img')
  end

  it "e o buffet tem foto cadastrada" do
    u = FactoryBot.create(:user)
    v = FactoryBot.create(:venue, user: u, brand_name: 'Buffet Nova Era')
    v.photo.attach(io: File.open(Rails.root.join('spec', 'support', 'foto_de_um_buffet.jpg')), filename: 'foto_de_um_buffet.jpg')

    visit root_path
    click_on 'Buffet Nova Era'

    expect(page).to have_css('img')
  end
end