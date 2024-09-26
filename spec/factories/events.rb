FactoryBot.define do
  factory :event do
    venue
    name                  { 'Aniversário' }
    description           { 'Salão de festas com vários ambientes, jardim arborizado e salão com pista de dança.' }
    minimum_guests_number { 200 }
    maximum_guests_number { 300 }
    has_alcoholic_drinks  { true }
    has_decorations       { true }
    has_parking_service   { true }
    has_valet_service     { true }
    can_be_catering       { true }
    duration              { 300 }
    menu                  {
      'Entradas: Canapés | Salada Caprese;
       Pratos Principais: Medalhão ao molho madeira e batatas | Risoto de parmesão com cogumelos;
       Sobremesas: Entremet de Chocolate Belga | Crème Brûlée'
    }
  end
end
