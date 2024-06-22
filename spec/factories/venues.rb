FactoryBot.define do
  factory :venue do
    user
    brand_name { 'Casa Jardim' }
    corporate_name { 'Casa Jardim Buffet Ltda' }
    registration_number { '11.111.111/0001-00' }
    address { 'Rua Eugênio de Medeiros, 530' }
    district { 'Pinheiros' }
    city { 'São Paulo' }
    state { 'SP' }
    zip_code { '05050-050' }
    phone_number { '(11)99111-1111' }
    email { 'casajardim@email.com' }
    description { 'Salão de festas com decoração rústica e chique, vários ambientes, jardim arborizado e pista de dança.' }
    payment_methods { 'pix, boleto bancário, transferência bancária, cartão de crédito' }
  end
end
