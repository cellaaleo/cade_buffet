# Cadê Buffet?
[Cadê Buffet? - API Rest](https://github.com/cellaaleo/cade_buffet?tab=readme-ov-file#cad%C3%AA-buffet---api-rest)

Projeto Ruby on Rails com TDD desenvolvido para TreinaDev12.

### Pré-requisitos:

* Rails 7.1.3.2

* ruby 3.0.0

### Gems utilizadas:

Para criação de perfis de usuários:

* devise

Para testes de desenvolvimento:

* rspec-rails

* capybara




# Cadê Buffet? - API Rest

## Documentação

### Listando buffets
Ao rodar o rails server desta aplicação, é possível a lista de buffets cadastrados fazendo no navegador a requisição:
    http://localhost:3000/api/v1/venues/

Ou, no terminal, usando curl:
    curl http://localhost:3000/api/v1/venues/

### Acessando detalhes de um buffet
A partir de um id, é possível ver detalhes de um buffet fazendo uma requisição como no exemplo abaixo:

    http://localhost:3000/api/v1/venues/1

O tipo de resultado que recebemos:

    {
      "id": 1,
      "brand_name": "Buffet",
      "phone_number": "(11)99999-9999",
      "email": "buffet@email.com.br",
      "address": "Rua Desembargador do Vale, 500",
      "district": "Perdizes",
      "city": "São Paulo",
      "state": "SP",
      "zip_code": "05010-000",
      "description": "Espaço amplo e versátil para a realização dos mais diversos tipos de eventos",
      "payment_methods": "Pix, Cartão de Crédito, Transferência Bancária"
      "events": []
    }

### Buscando um buffet pelo nome fantasia
É possível filtrar o resultado da lista de buffets fazendo uma busca pelo nome fantasia (brand_name) como no exemplo abaixo:

    http://localhost:3000/api/v1/venues/search?q=buffet

Isso retornará todos os buffets que contenham em seu nome fantasia o texto especificado na consulta 'q' (no caso acima: "buffet" traria resultados como "Buffet Bom Garfo", "Ana Buffet & Eventos" etc).

### Listando eventos um buffet
A partir do id de um buffet, é possível ver uma lista dos eventos que ele realiza:

    http://localhost:3000/api/v1/venues/1/events

O tipo de resultado que recebemos:

    [
      {
        "id": 1,
        "venue_id": 1,
        "name": "Casamentos",
        "minimum_guests_number": 120,
        "maximum_guests_number": 200
      },
      {
        "id": 2,
        "venue_id": 1,
        "name": "Eventos corporativos",
        "minimum_guests_number": 150,
        "maximum_guests_number": 250
      }
    ]

A listagem de eventos também aparece ao (acessar detalhes de um buffet)[https://github.com/cellaaleo/cade_buffet?tab=readme-ov-file#acessando-detalhes-de-um-buffet].