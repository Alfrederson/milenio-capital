require "../coisas/location"
module LocationIndex
    extend self

    @@locations : Array(Location)    
    def find_by_id(id : Int32) : Location?
        index = id - 1
        @@locations[index] if index >= 0 && index < @@locations.size
    end
end