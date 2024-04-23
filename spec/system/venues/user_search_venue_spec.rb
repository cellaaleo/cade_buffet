require 'rails_helper'

describe "Usuário busca um buffet" do
  it "a partir do menu" do
    # Arrange
    # Act
    visit root_path
    # Assert
    within('header #busca') do
      expect(page).to have_field 'Buscar buffet'
      expect(page).to have_button 'Buscar' 
    end
  end

end
