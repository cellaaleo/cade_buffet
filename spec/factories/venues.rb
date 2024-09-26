FactoryBot.define do
  factory :venue do
    user
    sequence(:registration_number) { |n| "0#{n}.010.010/0001-00" }
    brand_name          { 'Casa Jardim' }
    corporate_name      { 'Casa Jardim Buffet Ltda' }
    address             { 'Rua Eugênio de Medeiros, 585' }
    district            { 'Pinheiros' }
    city                { 'São Paulo' }
    state               { 'SP' }
    zip_code            { '05050-050' }
    phone_number        { '(11) 99111-1111' }
    email               { 'contato@casajardim.com.br' }
    description         { 'Salão de festas com vários ambientes, jardim arborizado e salão com pista de dança.' }
    payment_methods     { 'pix, boleto bancário, transferência bancária, cartão de crédito' }
  end
end
