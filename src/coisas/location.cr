require "json"
class Location
  include JSON::Serializable
  @[JSON::Field(key: "id" )]
  property id : Int32

  @[JSON::Field(key: "name" )]
  property name : String

  @[JSON::Field(key: "type" )]
  property type : String

  @[JSON::Field(key: "dimension" )]
  property dimension : String

  @[JSON::Field(key: "popularity")]
  property popularity : Int32

  def describe( expanded : Bool = false)
    if expanded
      {id: id, name: name, type: type, dimension: dimension} #, popularity: popularity}
    else
      id
    end
  end
end

