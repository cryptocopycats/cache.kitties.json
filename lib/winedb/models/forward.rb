### forward references
##   require first to resolve circular references


module WineDb
  module Model

  ## todo: why? why not use include WorldDb::Models here???

  Continent = WorldDb::Model::Continent
  Country   = WorldDb::Model::Country
  Region    = WorldDb::Model::Region
  City      = WorldDb::Model::City

  Tag       = WorldDb::Model::Tag
  Tagging   = WorldDb::Model::Tagging

  Prop      = WorldDb::Model::Prop

  class Wine < ActiveRecord::Base ; end
  class Winery < ActiveRecord::Base ; end

 end
end


module WorldDb
  module Model

  Wine   = WineDb::Model::Wine
  Winery = WineDb::Model::Winery

  end
end
