# frozen_string_literal: true

home_country_id = Country.domestic.first.id

State.create!([
                { name: 'Acre', abbreviation: 'AC', country_id: home_country_id },
                { name: 'Alagoas', abbreviation: 'AL', country_id: home_country_id },
                { name: 'Amapá', abbreviation: 'AP', country_id: home_country_id },
                { name: 'Amazonas', abbreviation: 'AM', country_id: home_country_id },
                { name: 'Bahia', abbreviation: 'BA', country_id: home_country_id },
                { name: 'Ceará', abbreviation: 'CE', country_id: home_country_id },
                { name: 'Distrito Federal', abbreviation: 'DF', country_id: home_country_id },
                { name: 'Espírito Santo', abbreviation: 'ES', country_id: home_country_id },
                { name: 'Goiás', abbreviation: 'GO', country_id: home_country_id },
                { name: 'Maranhão', abbreviation: 'MA', country_id: home_country_id },
                { name: 'Mato Grosso', abbreviation: 'MT', country_id: home_country_id },
                { name: 'Mato Grosso do Sul', abbreviation: 'MS', country_id: home_country_id },
                { name: 'Minas Gerais', abbreviation: 'MG', country_id: home_country_id },
                { name: 'Paraná', abbreviation: 'PR', country_id: home_country_id },
                { name: 'Paraíba', abbreviation: 'PB', country_id: home_country_id },
                { name: 'Pará', abbreviation: 'PA', country_id: home_country_id },
                { name: 'Pernambuco', abbreviation: 'PE', country_id: home_country_id },
                { name: 'Piauí', abbreviation: 'PI', country_id: home_country_id },
                { name: 'Rio Grande do Norte', abbreviation: 'RN', country_id: home_country_id },
                { name: 'Rio Grande do Sul', abbreviation: 'RS', country_id: home_country_id },
                { name: 'Rio de Janeiro', abbreviation: 'RJ', country_id: home_country_id },
                { name: 'Rondônia', abbreviation: 'RO', country_id: home_country_id },
                { name: 'Roraima', abbreviation: 'RR', country_id: home_country_id },
                { name: 'Santa Catarina', abbreviation: 'SC', country_id: home_country_id },
                { name: 'Sergipe', abbreviation: 'SE', country_id: home_country_id },
                { name: 'São Paulo', abbreviation: 'SP', country_id: home_country_id },
                { name: 'Tocantins', abbreviation: 'TO', country_id: home_country_id }
              ])
