module WorldDb
  module Model

class City
    has_many :wines,    class_name: 'WineDb::Model::Wine',   foreign_key: 'city_id'
    has_many :wineries, class_name: 'WineDb::Model::Winery', foreign_key: 'city_id'
end # class Country


  end # module Model
end # module WorldDb
