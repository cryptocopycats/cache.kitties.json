# encoding: UTF-8

module WineDb


module Matcher

  def fix_match_xxx_for_country_n_region( name, xxx ) # xxx e.g. wine|wineries

    ## todo/fix: move code into worlddb matcher!!!!
    ## -- allow opt_folders after long regions
    ## -- allow anything before -- for xxx

    ### fix allow prefixes for wines (move into core!!!) e.g.
    ##
    #  at-austria!/1--n-niederoesterreich--eastern/wagram--wines
    #  at-austria!/1--n-niederoesterreich--eastern/wagram--wagram--wines

    ### strip subregion if present e.g.
    #  /wagram--wines  becomes /wines n
    #  /wagram--wagram--wines   becomes / wines etc.

    # auto-add required country n region code (from folder structure)

    # note: allow  /cities and /1--hokkaido--cities and /hokkaido--cities too
    xxx_pattern = "(?:#{xxx}|[^\\/]+--#{xxx})"    # note: double escape \\ required for backslash
    
    ## allow optional folders -- TODO: add restriction ?? e.g. must be 4+ alphas ???
    opt_folders_pattern = "(?:\/[^\/]+)*"
    ## note: for now only (2) n (3)  that is long region allow opt folders

    if name =~ /(?:^|\/)([a-z]{2,3})-[^\/]+\/([a-z]{1,3})-[^\/]+\/#{xxx_pattern}/  ||                # (1)
       name =~ /(?:^|\/)[0-9]+--([a-z]{2,3})-[^\/]+\/[0-9]+--([a-z]{1,3})-[^\/]+#{opt_folders_pattern}\/#{xxx_pattern}/ || # (2)
       name =~ /(?:^|\/)([a-z]{2,3})-[^\/]+\/[0-9]+--([a-z]{1,3})-[^\/]+#{opt_folders_pattern}\/#{xxx_pattern}/         || # (3)
       name =~ /(?:^|\/)[0-9]+--([a-z]{2,3})-[^\/]+\/([a-z]{1,3})-[^\/]+\/#{xxx_pattern}/            # (4)

      #######
      # nb: country must start name (^) or coming after / e.g. europe/at-austria/...
      # (1)
      # new style: e.g.  /at-austria/w-wien/cities or
      #                  ^at-austria!/w-wien/cities
      # (2)
      # new new style e.g.  /1--at-austria--central/1--w-wien--eastern/cities
      #
      # (3)
      #  new new mixed style e.g.  /at-austria/1--w-wien--eastern/cities
      #      "classic" country plus new new region
      #
      # (4)
      #  new new mixed style e.g.  /1--at-austria--central/w-wien/cities
      #      new new country plus "classic" region

      country_key = $1.dup
      region_key  = $2.dup
      yield( country_key, region_key )
      true # bingo - match found
    else
      false # no match found
    end
  end


  def match_wines_for_country( name, &blk )
    ## check: allow/add synonyms e.g. weine, vinos etc. ???
    match_xxx_for_country( name, 'wines', &blk )
  end

  def match_wines_for_country_n_region( name, &blk )
    fix_match_xxx_for_country_n_region( name, 'wines', &blk )
  end

  def match_wineries_for_country( name, &blk )
    match_xxx_for_country( name, 'wineries', &blk )
  end

  def match_wineries_for_country_n_region( name, &blk )
    ## check: allow/add synonyms e.g. producers ? weingueter ??
    fix_match_xxx_for_country_n_region( name, 'wineries', &blk )
  end

  ## for now vineyards, shops, taverns require country n region
  def match_vineyards_for_country_n_region( name, &blk )
    fix_match_xxx_for_country_n_region( name, 'vineyards', &blk )
  end

  def match_shops_for_country_n_region( name, &blk )
    ## check: allow/add synonyms e.g. vinotheken, enotecas
    fix_match_xxx_for_country_n_region( name, 'shops', &blk )
  end

  def match_taverns_for_country_n_region( name, &blk )
    ## also try synonyms e.g. heurige (if not match for taverns)
    found = fix_match_xxx_for_country_n_region( name, 'taverns', &blk )
    found = fix_match_xxx_for_country_n_region( name, 'heurige', &blk ) unless found
    found
  end


end # module Matcher


class Reader

  include LogUtils::Logging

  include WineDb::Models

  include WorldDb::Matcher   ## fix: move to WineDb::Matcher module ??? - cleaner?? why? why not?
  include WineDb::Matcher # lets us use match_teams_for_country etc.

  attr_reader :include_path


  def initialize( include_path, opts = {} )
    @include_path = include_path
  end


  def load_setup( name )
    path = "#{include_path}/#{name}.yml"

    logger.info "parsing data '#{name}' (#{path})..."

    reader = FixtureReader.new( path )

    reader.each do |fixture_name|
      load( fixture_name )
    end
  end # method load_setup


  def load( name )

    if match_wines_for_country_n_region( name ) do |country_key, region_key|
        ### fix: use region_key too
        load_wines_for_country( country_key, name )
       end
    elsif match_wines_for_country( name ) do |country_key|
            load_wines_for_country( country_key, name )
          end
    elsif match_wineries_for_country_n_region( name ) do |country_key, region_key|
        ### fix: use region_key too
            load_wineries_for_country( country_key, name )
          end
    elsif match_wineries_for_country( name ) do |country_key|
            load_wineries_for_country( country_key, name )
          end
    else
      logger.error "unknown wine.db fixture type >#{name}<"
      # todo/fix: exit w/ error
    end
  end


  def load_wines_for_country( country_key, name, more_attribs={} )
    country = Country.find_by_key!( country_key )
    logger.debug "Country #{country.key} >#{country.title} (#{country.code})<"

    more_attribs[ :country_id ] = country.id

    more_attribs[ :txt ] = name  # store source ref

    load_wines_worker( name, more_attribs )
  end


  def load_wines_worker( name, more_attribs={} )
    reader = ValuesReaderV2.new( name, include_path, more_attribs )

    ### todo: cleanup - check if [] works for build_title...
    #     better cleaner way ???
    if more_attribs[:region_id].present?
      known_wineries_source = Winery.where( region_id:  more_attribs[:region_id] )
    elsif more_attribs[:country_id].present?
      known_wineries_source = Winery.where( country_id: more_attribs[:country_id] )
    else
      logger.warn "no region or country specified; use empty winery ary for header mapper"
      known_wineries_source = []
    end

    known_wineries = TextUtils.build_title_table_for( known_wineries_source )

    reader.each_line do |new_attributes, values|

      ## note: check for header attrib; if present remove
      ### todo: cleanup code later
      ## fix: add to new_attributes hash instead of values ary
      ##   - fix: match_winery()   move region,city code out of values loop for reuse at the end
      if new_attributes[:header].present?
        winery_line = new_attributes[:header].dup   # note: make sure we make a copy; will use in-place string ops
        new_attributes.delete(:header)   ## note: do NOT forget to remove from hash!

        logger.debug "  trying to find winery in line >#{winery_line}<"
        ## todo: check what map_titles_for! returns (nothing ???)
        TextUtils.map_titles_for!( 'winery', winery_line, known_wineries )
        winery_key = TextUtils.find_key_for!( 'winery', winery_line )
        logger.debug "  winery_key = >#{winery_key}<"
        unless winery_key.nil?
          ## bingo! add winery_id upfront, that is, as first value in ary
          values = values.unshift "winery:#{winery_key}"
        end
      end

      Wine.create_or_update_from_attribs( new_attributes, values )
    end # each_line
  end


  def load_wineries_for_country( country_key, name, more_attribs={} )
    country = Country.find_by_key!( country_key )
    logger.debug "Country #{country.key} >#{country.title} (#{country.code})<"

    more_attribs[ :country_id ] = country.id

    more_attribs[ :txt ] = name  # store source ref

    load_wineries_worker( name, more_attribs )
  end

  def load_wineries_worker( name, more_attribs={} )
    reader = ValuesReaderV2.new( name, include_path, more_attribs )

    reader.each_line do |new_attributes, values|
      
      #######
      # fix: move to (inside)
      #    Winery.create_or_update_from_attribs ||||
      ## note: group header not used for now; do NOT forget to remove from hash!
      if new_attributes[:header].present?
        logger.warn "removing unused group header #{new_attributes[:header]}"
        new_attributes.delete(:header)   ## note: do NOT forget to remove from hash!
      end
      
      Winery.create_or_update_from_attribs( new_attributes, values )
    end # each_line
  end

end # class Reader
end # module WineDb
