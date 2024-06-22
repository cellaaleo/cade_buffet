FactoryBot.define do
  sequence :seq_email do |n|
    "person#{n}@email.com"
  end
end