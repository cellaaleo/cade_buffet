<h1 align="center"> Cadê Buffet? </h1> 
Projeto Ruby on Rails com TDD desenvolvido durante o TreinaDev12.

## Tópicos
- (Sobre a aplicação)[https://github.com/cellaaleo/cade_buffet?tab=readme-ov-file#sobre-a-aplica%C3%A7%C3%A3o]
  - (Gems utilizadas)[https://github.com/cellaaleo/cade_buffet?tab=readme-ov-file#gems-utilizadas]
  - (Models)[https://github.com/cellaaleo/cade_buffet?tab=readme-ov-file#models]
- (Pré-requisitos)[https://github.com/cellaaleo/cade_buffet?tab=readme-ov-file#pr%C3%A9-requisitos]
- (Como rodar a aplicação)[https://github.com/cellaaleo/cade_buffet?tab=readme-ov-file#como-rodar-a-aplica%C3%A7%C3%A3o]
- [Cadê Buffet? - API Rest](https://github.com/cellaaleo/cade_buffet?tab=readme-ov-file#cad%C3%AA-buffet---api-rest)
  - (Documentação)[https://github.com/cellaaleo/cade_buffet?tab=readme-ov-file#documenta%C3%A7%C3%A3o]
    - (Listando buffets)[https://github.com/cellaaleo/cade_buffet?tab=readme-ov-file#listando-buffets]
    - (Acessando detalhes de um buffet)[https://github.com/cellaaleo/cade_buffet?tab=readme-ov-file#acessando-detalhes-de-um-buffet]
    - (Buscando um buffet pelo nome fantasia)[https://github.com/cellaaleo/cade_buffet?tab=readme-ov-file#buscando-um-buffet-pelo-nome-fantasia]
    - (Listando eventos de um buffet)[https://github.com/cellaaleo/cade_buffet?tab=readme-ov-file#listando-eventos-um-buffet]
    - (Consultando disponibilidade de um buffet)[https://github.com/cellaaleo/cade_buffet?tab=readme-ov-file#consultando-disponibilidade-de-um-buffet]

## Sobre a aplicação
"Cadê Buffet?" é uma aplicação em que buffets cadastrados podem receber pedidos de clientes para a realização de determinado tipo de evento.

A app possui dois tipos de usuário: dono de buffet e cliente.
* **Dono de buffet** faz um cadastro inicial e, em seguida, deve cadastrar dados de sua empresa que posteriormente podem ser editados. A partir da página do buffet, é possível cadastrar eventos que oferece e posteriormente, cadastrar os respectivos preços. Ao clicar em 'Pedidos' é possível ver os pedidos que recebeu de clientes, separados de acordo com o status. Para pedidos que aguardam avaliação, deve-se fazer um orçamento para, em seguida poder ser aprovado. Dono de buffet pode desativar e reativar o perfil da empresa ou um evento. Buffets ou eventos desativados não aparecerão em listagens e não recebem pedidos.
* **Cliente** devidamente autenticado pode fazer pedidos a partir da página de um evento sendo que a data escolhida deve ser pelo menos a partir de um mês da data de cadastro. Ao acessar 'Meus pedidos', é possível visualizá-los separados de acordo com o status. Um pedido aprovado apresenta o orçamento e é possível ser confirmado pelo cliente, desde que dentro do prazo de validade deste orçamento. 

Visitante (usuário não autenticado) e clientes podem ver a relação de buffets cadastrados a partir da página inicial da app e podem pesquisar por um buffet através do nome, cidade ou tipo de evento.

### Gems utilizadas:
Para criação de perfis de usuários: [devise](https://github.com/heartcombo/devise)

Para testes de desenvolvimento: [capybara](https://github.com/teamcapybara/capybara), [rspec-rails](https://github.com/rspec/rspec-rails)

Para rodar os testes, execute:

    rspec

### Models
* **dono de buffet:** user
* **cliente:** customer
* **buffet:** venue
* **evento:** event
* **preço:** price
* **pedido:** order
* **orçamento:** quotation

## Pré-requisitos:
* Rails 7.1.3.2
* ruby 3.0.0

## Como rodar a aplicação:
No terminal, clone o projeto:

    git clone https://github.com/cellaaleo/cade_buffet

Entre na pasta do projeto:

    cd cade_buffet

Instale as dependecias:

    bundle install

Faça as migrações:

    rails db:migrate

Execute a aplicação:

    rails server

Agora é possível acessar a aplicação a partir da rota http://localhost:3000/



# Cadê Buffet? - API Rest

## Documentação
Para executar a API, rode o rails server.

### Listando buffets
É possível ver a lista de buffets cadastrados que estejam ativos fazendo no navegador a requisição:

    http://localhost:3000/api/v1/venues/

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
      "events": [...]
    }

### Buscando um buffet pelo nome fantasia
É possível filtrar o resultado da lista de buffets fazendo uma busca pelo nome fantasia (brand_name) como no exemplo abaixo:

    http://localhost:3000/api/v1/venues/search?venue=buffet

Isso retornará todos os buffets que contenham em seu nome fantasia o texto especificado no valor de 'venue' (no caso acima: "buffet" traria resultados como "Buffet Bom Garfo", "Ana Buffet & Eventos" etc).


### Listando eventos de um buffet
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

A listagem de eventos também aparece ao [acessar detalhes de um buffet](https://github.com/cellaaleo/cade_buffet?tab=readme-ov-file#acessando-detalhes-de-um-buffet).


### Consultando disponibilidade de um buffet
Informando os ids de um buffet e de um evento a ele relacionado, é possível fazer a consulta 'availability?' que recebe os parâmetros 'guests' (que corresponde ao número estimado de convidados) e 'date' (que corresponde à data pretendida para o evento). O valor de 'date' deve ser no formato aaaa-mm-dd. Um exemplo de consulta:

    localhost:3000/api/v1/venues/1/events/1/availability?guests=100&date=2024-11-07

Se o valor de 'guests' for maior que a capacidade que o buffet tem de atender, é retornado um erro:

    {"error":"O número de convidados excede a capacidade máxima do buffet para este evento."}

Se o buffet já tiver um pedido com status 'confirmed' na mesma data informada em 'date', é retornado um erro:

    {"error":"O buffet já está reservado para a data escolhida."}

Estando disponível, é retornado o valor estimado para o evento:

    {
      "preço_base": 1000,
      "taxa_adicional": 100,
      "valor_final_estimado": 1100
    }