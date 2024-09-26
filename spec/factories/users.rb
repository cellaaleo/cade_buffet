FactoryBot.define do
  factory :user do
    name              { 'Ana Maria Pereira' }
    sequence(:email)  { |n| "user#{n}@email.com" }
    password          { 'password' }
  end
end
