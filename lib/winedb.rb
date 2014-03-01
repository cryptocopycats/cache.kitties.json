

require 'winedb/version'  # let it always go first


module WineDb
  
  def self.banner
    "winedb/#{VERSION} on Ruby #{RUBY_VERSION} (#{RUBY_RELEASE_DATE}) [#{RUBY_PLATFORM}]"
  end

  def self.root
    "#{File.expand_path( File.dirname(File.dirname(__FILE__)) )}"
  end

end  # module WineDb


puts WineDb.banner    # say hello
