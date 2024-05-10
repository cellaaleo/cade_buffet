# Cadê Buffet?

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
Ao rodar o rails server desta aplicação, é possível ver no navegador a lista de buffets cadastrados fazendo uma requisição

    http://localhost:3000/api/v1/venues/

Ou, no terminal, usando curl

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
    }

### Buscando um buffet pelo nome fantasia
É possível filtrar o resultado da lista de buffets fazendo uma busca pelo nome fantasia (brand_name) como no exemplo abaixo:

    http://localhost:3000/api/v1/venues/search?q=buffet

Isso retornará todos os buffets que contenham em seu nome fantasia o texto especificado na consulta 'q' (no caso acima: "buffet" traria resultados como "Buffet Bom Garfo", "Ana Buffet & Eventos" etc).