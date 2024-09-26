FactoryBot.define do
  factory :user do
    name      { 'Ana Maria Pereira' }
    email     { generate :seq_email }
    password  { 'password' }
  end
end
