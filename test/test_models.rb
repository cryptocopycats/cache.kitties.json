# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_helper.rb
#  or better
#     rake test

require 'helper'


class TestModels < MiniTest::Unit::TestCase

  def setup  # runs before every test
    WineDb.delete!   # always clean-out tables
  end
  
  def test_worlddb_assocs
    assert_equal 0, AT.wines.count
    assert_equal 0, AT.wineries.count
    assert_equal 0, AT.taverns.count
    assert_equal 0, AT.shops.count

    assert_equal 0, N.wines.count
    assert_equal 0, N.wineries.count
    assert_equal 0, N.taverns.count
    assert_equal 0, N.shops.count

    assert_equal 0, FEUERSBRUNN.wines.count
    assert_equal 0, FEUERSBRUNN.wineries.count
    assert_equal 0, FEUERSBRUNN.taverns.count
    assert_equal 0, FEUERSBRUNN.shops.count
    assert_equal 0, FEUERSBRUNN.vineyards.count
  end


  def test_count
    assert_equal 0, Grape.count
    assert_equal 0, Family.count
    assert_equal 0, Variety.count
    assert_equal 0, Vineyard.count
    assert_equal 0, Person.count
    assert_equal 0, Shop.count
    assert_equal 0, Tavern.count
    assert_equal 0, Vintage.count
    assert_equal 0, Wine.count
    assert_equal 0, Winery.count
    
    WineDb.tables  # print stats
  end


  def test_load_wine_values
 
    key = 'gruenerveltlinerspiegel'

    values = [
      'Grüner Veltliner Spiegel',
      'gv'
    ]

    more_attribs = {
      country_id: AT.id
    }

    wine = Wine.create_or_update_from_values( values, more_attribs )

    wine2 = Wine.find_by_key!( key )
    assert_equal wine.id,  wine2.id

    assert_equal wine.title,         values[0]
    assert_equal wine.country_id,    AT.id
    assert_equal wine.country.title, AT.title
  end

  def test_load_winery_values

    key = 'antonbauer'

    values = [
      key,
      'Anton Bauer (1971)',
      'www.antonbauer.at',
      'Neufang 42 // 3483 Feuersbrunn',
      '25 ha'  ### todo: make sure it will not get matched as tag
    ]

    more_attribs = {
      country_id: AT.id
    }

    wy = Winery.create_or_update_from_values( values, more_attribs )

    wy2 = Winery.find_by_key!( key )
    assert_equal wy.id, wy2.id

    assert_equal wy.title,         values[1]
    assert_equal wy.country_id,    AT.id
    assert_equal wy.country.title, AT.title
    assert_equal wy.web,           'www.antonbauer.at'
    assert_equal wy.address,       'Neufang 42 // 3483 Feuersbrunn'
  end


end # class TestModels

