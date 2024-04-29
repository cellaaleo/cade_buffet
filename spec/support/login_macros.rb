def login(user)
  within('nav') do
    click_on 'Entrar'
  end
  click_on 'Dono de Buffet'
  within('main form') do
    fill_in 'E-mail', with: user.email
    fill_in 'Senha', with: user.password
    click_on 'Entrar'
  end
end