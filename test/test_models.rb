# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_helper.rb
#  or better
#     rake test

require 'helper'


class TestModels < MiniTest::Unit::TestCase

  def test_load_wine_values

    key = 'gruenerveltlinerspiegel'

    values = [
      'Grüner Veltliner Spiegel',
      '12.3 %',
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
    assert_equal wine.abv,           12.3
  end

  def test_load_winery_values

    key = 'antonbauer'

    values = [
      key,
      'Anton Bauer (1971)',
      'www.antonbauer.at',
      'Neufang 42 // 3483 Feuersbrunn',
      '25 ha',  ### todo: make sure it will not get matched as tag
      'tag'
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

