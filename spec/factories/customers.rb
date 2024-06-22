FactoryBot.define do
  factory :customer do
    name     { 'Luis' }
    cpf      { '197.424.430-09' }
    email    { generate :seq_email }
    password { 'password' }
  end
end
