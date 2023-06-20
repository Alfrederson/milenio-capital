require "kemal"
require "../coisas/location"
require "../coisas/travel_plan"

require "./location_index"

class PlanParameters
    include JSON::Serializable
    @[JSON::Field(key: "travel_stops")]
    property travel_stops : Array(Int32)
end


class DimensionPopularity
    include JSON::Serializable
    @[JSON::Field(key: "count")]
    property count  : Int32
    @[JSON::Field(key: "total")]
    property total  : Int32
    @[JSON::Field(key: "average")]
    property average : Int32
    def initialize
        @count = 0
        @total = 0
        @average = 0
    end
end

module TravelPlanner
    extend self
    # não quero botar um sqlite aqui não
    @@travel_plans : Array(TravelPlan?) = [] of TravelPlan?

    @@item_counter = 0

    # cria um novo plano de viagem e retorna ele.
    def make_plan
        new_plan = TravelPlan.new( @@travel_plans.size + 1)
        @@travel_plans << new_plan
        new_plan
    end

    # devolve todos os planos
    def list_plans : Array(TravelPlan)
        @@travel_plans.select(TravelPlan)
    end

    # deleta um plano
    def erase_plan(id : Int32)
        # parece que o crystal usa Boehm garbage collector, então a minha esperança é que
        # isso faça o location original perder a referência e ser coletado depois.
        @@travel_plans[ id-1 ] = nil 
    end

    def find_by_id(id : Int32) : TravelPlan
        @@travel_plans[ id-1 ].not_nil!
    end
    

    def optimize(plan : TravelPlan)
        # cada dimensão tem uma popularidade média.
        new_plan = TravelPlan.new( plan.id )

        dimension_popularities = Hash(String, DimensionPopularity).new

        plan.stops.each do |stop|
            popularity_statistics = dimension_popularities[ stop.dimension ]? || 
                                    (dimension_popularities[ stop.dimension ] = DimensionPopularity.new)
            popularity_statistics.count += 1
            popularity_statistics.total += stop.popularity
            popularity_statistics.average = Int32.new(popularity_statistics.total / popularity_statistics.count)
        end

        # TODO: apagar debug. 
        # puts dimension_popularities.to_json

        new_plan.stops = plan.stops.sort{ |a, b|    
            if a.dimension == b.dimension
                (a.popularity <=> b.popularity) || 
                (a.name <=> b.name)
            else
                (dimension_popularities[a.dimension].average <=> dimension_popularities[b.dimension].average) || 
                (a.dimension <=> b.dimension)
            end
        }

        new_plan
    end
end





#
# - optimize (boolean - falso por padrão):
#    Quando verdadeiro, o array de travel_stops é ordenado
#    de maneira a otimizar a viagem.
# - expand (boolean - falso por padrão):
#    Quando verdadeiro, o campo de travel_stops 
#    é um array de entidades com informações detalhadas sobre cada parada.
#
get "/travel_plans" do |env|
    puts "Vendo todos os planos"
    expand   = env.params.query["expand"]? == "true"
    optimize = env.params.query["optimize"]? == "true"

    puts "Expandido: #{ expand } Otimizado: #{ optimize }"

    all_plans = TravelPlanner.list_plans
    if optimize
        # eu que do emprego pro garbage collector
        all_plans = all_plans.map{ |plan| TravelPlanner.optimize(plan) }
    end

    all_plans.map{ |plan| plan.describe( expand ) }.to_json        
end

get "/travel_plans/:id" do |env|
    puts "Vendo plano #{ env.params.url["id"] }"
    expand   = env.params.query["expand"]? == "true"
    optimize = env.params.query["optimize"]? == "true"
    puts "Expandido: #{ expand } Otimizado: #{ optimize }"

    begin
        travel_plan = TravelPlanner.find_by_id( Int32.new( env.params.url["id"] ))
        if optimize
            travel_plan = TravelPlanner.optimize( travel_plan )
        end
        travel_plan.describe( expand ).to_json
    rescue
        env.response.status_code = 400
    end
end

# ```json
# {
#  "travel_stops": [1, 2]
# }
# ```

post "/travel_plans" do |env|
    puts "Criando plano "

    create_request = PlanParameters.from_json( env.request.body.not_nil! )
    new_plan = TravelPlanner.make_plan
    create_request.travel_stops.each do |stop_id|
        new_plan.add_stop( LocationIndex.find_by_id( stop_id ).not_nil! )
    end

    env.response.status_code = 201
    new_plan.describe.to_json
end

# ```json
# {
#  "travel_stops": [1, 2]
# }
# ```
put "/travel_plans/:id" do |env|
    puts "Atualizando o plano #{ env.params.url["id"] }"
    begin
        update_request = PlanParameters.from_json( env.request.body.not_nil! )
        old_plan = TravelPlanner.find_by_id( Int32.new( env.params.url["id"] ) )

        old_plan.clear_stops
        update_request.travel_stops.each do |stop_id|
            old_plan.add_stop( LocationIndex.find_by_id( stop_id ).not_nil! )
        end

        env.response.status_code = 200
        old_plan.describe.to_json
    rescue
        env.response.status_code = 400
    end
end

delete "/travel_plans/:id" do |env|
    begin
        puts "removendo o plano #{ env.params.url["id"] }"

        TravelPlanner.erase_plan(  Int32.new(  env.params.url["id"]  ) )

        env.response.status_code = 204
    rescue
        env.response.status_code = 400
    end
end

