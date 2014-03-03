

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
require 'winedb/models/family'
require 'winedb/models/grape'
require 'winedb/models/person'
require 'winedb/models/region'
require 'winedb/models/tag'
require 'winedb/models/variety'
require 'winedb/models/vineyard'
require 'winedb/models/vintage'
require 'winedb/models/wine'
require 'winedb/models/winery'


require 'winedb/reader'

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


  def self.read( ary, include_path )
    reader = Reader.new( include_path )
    ary.each do |name|
      reader.load( name )
    end
  end

  def self.read_setup( setup, include_path, opts={} )
    reader = Reader.new( include_path, opts )
    reader.load_setup( setup )
  end

  def self.read_all( include_path, opts={} )  # load all builtins (using plain text reader); helper for convenience
    read_setup( 'setups/all', include_path, opts )
  end # method read_all


end  # module WineDb


puts WineDb.banner    # say hello
