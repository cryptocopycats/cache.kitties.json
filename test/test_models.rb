# encoding: utf-8


require 'helper'


class TestModels < MiniTest::Unit::TestCase

  def setup  # runs before every test
    PersonDb.delete!
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
    assert_equal 0, Person.count

    assert_equal 0, Grape.count
    assert_equal 0, Family.count
    assert_equal 0, Variety.count
    assert_equal 0, Vineyard.count
    assert_equal 0, Shop.count
    assert_equal 0, Tavern.count
    assert_equal 0, Vintage.count
    assert_equal 0, Wine.count
    assert_equal 0, Winery.count
    
    # print stats
    WineDb.tables
    PersonDb.tables
  end

end # class TestModels

