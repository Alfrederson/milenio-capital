require "kemal"
require "./invencoes_do_rick/travel_planner"
require "./invencoes_do_rick/location_index"

# um travel planner tem um índice de localizações e uma coleção de planos de viagem
# um plano de viagem tem um ID e uma lista de paradas.

module LocationIndex
    @@locations = Array(Location).from_json( File.read("src/data/locations.json") )
end

error 400 do |env|
    {err: "Requisição inválida"}.to_json
end

after_all "/*" do |env|
    env.response.content_type = "application/json"
end

Kemal.config.port = 3000
Kemal.run
