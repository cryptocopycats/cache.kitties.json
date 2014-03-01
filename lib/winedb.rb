

# 3rd party gems / libs

require 'active_record'   ## todo: add sqlite3? etc.

require 'logutils'
require 'textutils'
require 'worlddb'


### our own code

require 'winedb/version'  # let it always go first
require 'winedb/schema'

require 'winedb/models/forward'
require 'winedb/models/city'
require 'winedb/models/country'
require 'winedb/models/region'
require 'winedb/models/tag'
require 'winedb/models/wine'
require 'winedb/models/winery'


module WineDb
  
  def self.banner
    "winedb/#{VERSION} on Ruby #{RUBY_VERSION} (#{RUBY_RELEASE_DATE}) [#{RUBY_PLATFORM}]"
  end

  def self.root
    "#{File.expand_path( File.dirname(File.dirname(__FILE__)) )}"
  end

  def self.create
    CreateDb.new.up

    WineDb::Model::Prop.create!( key: 'db.schema.wine.version', value: VERSION )
  end


end  # module WineDb


puts WineDb.banner    # say hello
