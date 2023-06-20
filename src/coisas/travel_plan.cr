require "./location"

# um travel plan contem uma lista de paradas, que são localizações.
class TravelPlan
    property stops : Array(Location)
    property id : Int32

    def initialize(_id : Int32)
        @id    = _id
        @stops = [] of Location
    end

    def add_stop(value : Location)
        @stops << value
    end

    def clear_stops
        @stops = [] of Location
    end

    def describe(expand : Bool = false)
        {id:id, travel_stops: stops.map { |stop| stop.describe( expand )}}
    end
  
end