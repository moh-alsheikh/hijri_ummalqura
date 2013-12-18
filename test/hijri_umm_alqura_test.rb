# -*- coding: utf-8 -*-
require 'date'
require 'hijri_umm_alqura'
require 'minitest/autorun'
require 'minitest/pride'

class HijriUmmAlquraTest < MiniTest::Unit::TestCase
  
  def setup
    @date = HijriUmmAlqura::Hijri.new(1435,2,12)  # =>   ١٢ صفر ١٤٣٥ هـ
  end
  
  def test_formated_hijri_date
    assert_equal @date.to_s , '١٢ صفر ١٤٣٥ هـ'
  end
  
  def test_julian
    assert_equal @date.jd, 2456641.5
  end
  
  def test_gregorian
    assert_equal @date.gd , "2013-12-15"
  end
  
  def test_adding_days
    assert_equal @date.add(2, 'd') , "1435-02-14"
  end
  
  def test_adding_weeks
    assert_equal @date.add(1, 'w') , "1435-02-19"
  end
  
  def test_adding_months
    assert_equal @date.add(1, 'm') , "1435-03-12"
  end
  
  def test_adding_years
    assert_equal @date.add(1, 'y') , "1436-02-12"
  end
  
  def test_date_comparison
    assert @date == HijriUmmAlqura::Hijri.new(@date.year, @date.month, @date.day)
    refute @date == HijriUmmAlqura::Hijri.new(@date.year + 1, @date.month, @date.day)
    refute @date == HijriUmmAlqura::Hijri.new(@date.year, @date.month + 1, @date.day)
    refute @date == HijriUmmAlqura::Hijri.new(@date.year, @date.month, @date.day + 1)
  end
  
  def test_add
    assert_equal @date + 1 , "1435-02-13"
  end
  
  def test_subtract
    assert_equal @date - 1 , "1435-02-11"
  end
  
  def test_days_in_month
    assert_equal 29 , @date.days_in_month
  end
  
  # Test module methods
  
  def test_julian_hijri_conversion
    assert_equal HijriUmmAlqura.jd(2456771.5) , "1435-06-24"
  end
  
  def test_gregorian_hijri_conversion
    assert_equal HijriUmmAlqura.gd_to_hd(2013,12,15) , "1435-02-12"
  end
  
  def test_hijri_gregorian_conversion
    assert_equal HijriUmmAlqura.hd_to_gd(1435,2,12) , "2013-12-15"
  end
    
  def test_julian_gregorian_conversion
    assert_equal HijriUmmAlqura.jd_to_gd(2456641.5) , "2013-12-15"
  end
  
  def test_gregorian_julian_conversion
    assert_equal HijriUmmAlqura.gd_to_jd(2013,12,15) , 2456641.5
  end
  
end
