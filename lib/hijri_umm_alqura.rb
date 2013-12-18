# -*- coding: utf-8 -*-

# implimintation of UmmAlQura calendar 
# by Mohammed Alsheikh December 2013.

# Thanks for Keith Wood who implemented UmmAlQura calendar in javascript.
# keith-wood.name 
# Many thanks for Murtaza Gulamali for his work in hijri date gem, I really inspired by your work.
# https://github.com/mygulamali/hijri_date

require "date"
require "hijri_umm_alqura/constants"

module HijriUmmAlqura 
  # Hijri class implementation 
  class Hijri
    
    attr_accessor :year, :month, :day
    
    # constructor
    def initialize(year = 1435, month = 1 , day = 1)
      @year = year
      @month = month
      @day = day
    end
    
    # return hijri date with month and day names
    def to_s
      today = arabno_to_hindi(day)  + " "
      today = today + HijriUmmAlqura::MONTHNAMES[month] + " "
      today = today + arabno_to_hindi(year) + " هـ" 
    end
  
    # Hijri to julian 
    def jd(date = self)
      index = (12 * (date.year - 1)) + date.month - 16260
      mcjdn = date.day + HijriUmmAlqura::UMMALQURA_DAT[index - 1] - 1
      mcjdn = mcjdn + 2400000 - 0.5
      return mcjdn
    end
      
    # Hijri to gregorian
    def gd(date = self)        
      j_date = jd(date)
      g_date = HijriUmmAlqura.jd_to_gd(j_date)
      return g_date
    end
            
    # Add Days - Weeks - Months - Years
    def add(date = self, offset, period)
      y = period == 'y' ? (date.year + offset) : date.year 
      m = period == 'm' ? (month_of_year(date.year, date.month) + offset) : month_of_year(date.year, date.month) 
      d = date.day
      begin
        if (period == 'd' || period == 'w') 
          week_days = period == 'w' ? 7 : 1
          j_date = jd
          j_date = j_date + offset * week_days 
          result = HijriUmmAlqura.jd(j_date)
          return result
        elsif (period == 'm') 
          rys = resync_year_month(y, m)
          y  = rys[0]
          m = rys[1]
          return HijriUmmAlqura.format_date([y, m, d])
        elsif (period == 'y') 
          return HijriUmmAlqura.format_date([y, m, d])
        end
      rescue Exception => e  
        puts "Exception details: #{e.class} #{e.message}" 
      end
    end
   
    def resync_year_month(y, m)
      if m < 1
        while (m < 1)
          y = y - 1
          m += months_in_year
        end
      else
        year_months = months_in_year
        while (m > year_months - 1 + 1)
          y = y + 1
          m -= year_months
          year_months = months_in_year
        end
      end
      
      return [y,m]
    end

    def month_of_year(year,month)
      return (month + months_in_year - 1) % months_in_year + 1
    end
        
    def months_in_year
      return 12
    end
        
    def days_in_month
      mcjdn = jd - 2400000 + 0.5
      index = 0
      for i in 0..HijriUmmAlqura::UMMALQURA_DAT.length
        if HijriUmmAlqura::UMMALQURA_DAT[i]  && (HijriUmmAlqura::UMMALQURA_DAT[i] > mcjdn)
          return (HijriUmmAlqura::UMMALQURA_DAT[index] - HijriUmmAlqura::UMMALQURA_DAT[index - 1])
        end
        i+=1      
        index+=1
      end
      return 30
    end
        
    # comparison operator
    def == (date)
      if date.is_a?(HijriUmmAlqura::Hijri)
        if date.year == self.year and date.month == self.month and date.day == self.day
          return true
        end
        return false
      end
      raise TypeError, 'expected HijriDate::Date'
    end
    
    # return hijri date plus n days 
    def + (n)
      case n
      when Numeric then  
        j_date = jd + n * 1 
        result = HijriUmmAlqura.jd(j_date)
        return result
      end
      raise TypeError, 'expected numeric'
    end
  
    # return hijri date minus n days 
    def - (n)
      case n
      when Numeric then  
        j_date = jd - n * 1 
        result = HijriUmmAlqura.jd(j_date)
        return result
      end
      raise TypeError, 'expected numeric'
    end
  
    # Convert arabic numbers to hindi numbers
    def arabno_to_hindi(input)      
      arabic_to_hindi = {
        '9' => '٩',
        '8' => '٨',
        '7' => '٧',
        '6' => '٦',
        '5' => '٥',
        '4' => '٤',
        '3' => '٣',
        '2' => '٢',
        '1' => '١',
        '0' => '٠'
      }
      text = ""
      input = input.to_s.split("")
      input.each do |i|
        text+= arabic_to_hindi[i]
      end
      text
    end
  end
  
  #-------------------------------------------------------------------  
  # MODULE METHODS

  # Format date to yyyy-mm-dd
  def HijriUmmAlqura.format_date(input)    
    today = input[0].to_s + "-" + (input[1].to_s).to_s.rjust(2,'0') + "-" + (input[2].to_s).to_s.rjust(2,'0')
  end
    
  #  julian to hijri
  def HijriUmmAlqura.jd(jd = 2456641.5)
    mcjdn = jd - 2400000 + 0.5
    index = 0
    i = 0

    for i in 0..HijriUmmAlqura::UMMALQURA_DAT.length
      break if (HijriUmmAlqura::UMMALQURA_DAT[i] > mcjdn)
      i+=1      
      index+=1
    end
      
    lunation = index + 16260
    ii = ((lunation - 1) / 12).floor
    year = ii + 1
    month = lunation - 12 * ii
    day = (mcjdn - HijriUmmAlqura::UMMALQURA_DAT[index - 1] + 1).to_i
    h_date = HijriUmmAlqura.format_date([year, month, day])
    return h_date
  end
    
  # gregorian to julian 
  def HijriUmmAlqura.gd_to_jd(year, month, day)
    year = 1 if year < 0
    if ( month < 3 ) 
      month = month + 12
      year = year - 1 
    end
    a = (year / 100).floor
    b = 2 - a + (a / 4).floor
    return (365.25 * (year + 4716)).floor + (30.6001 * (month + 1)).floor + day + b - 1524.5
  end
    
  # Julian to gregorian
  def HijriUmmAlqura.jd_to_gd(jd)
    z = (jd + 0.5).floor
    a = ((z - 1867216.25) / 36524.25).floor
    a = z + 1 + a -(a / 4).floor
    b = a + 1524
    c = ((b - 122.1) / 365.25).floor
    d = (365.25 * c).floor
    e = ((b - d) / 30.6001).floor
    day = b - d - (e * 30.6001).floor
    month = e - (e > 13.5 ? 13 : 1)
    year = c - (month > 2.5 ? 4716 : 4715)
    year = 1 if year <= 0 
    g_date = HijriUmmAlqura.format_date([year, month, day])
    return g_date
  end
  
  # hijri to gregorian 
  def HijriUmmAlqura.hd_to_gd(year, month, day)
    begin
      h_date = HijriUmmAlqura::Hijri.new(year, month, day)
      g_date = h_date.gd.split('-')
      g_date = HijriUmmAlqura.format_date(g_date)
    rescue ArgumentError 
      raise ArgumentError.new("Only numbers are allowed")
    end
    return g_date
  end  
  
  # Hijri to julian 
  def HijriUmmAlqura.hd_to_jd(year, month, day)
    index = (12 * (year - 1)) + month - 16260
    mcjdn = day + HijriUmmAlqura::UMMALQURA_DAT[index - 1] - 1
    mcjdn = mcjdn + 2400000 - 0.5
    return mcjdn
  end
    
  # Gregorian to hijri
  def HijriUmmAlqura.gd_to_hd(year, month, day)
    begin
      j_date = HijriUmmAlqura.gd_to_jd(year,month,day)
      h_date = HijriUmmAlqura.jd(j_date)
    rescue ArgumentError 
      raise ArgumentError.new("Only numbers are allowed")
    end
    return h_date
  end
  
  # Days in month
  def HijriUmmAlqura.days_in_month(year, month, day)
    jd = HijriUmmAlqura.hd_to_jd(year, month, day)
    mcjdn = jd - 2400000 + 0.5
    index = 0
    
    for i in 0..HijriUmmAlqura::UMMALQURA_DAT.length
      if HijriUmmAlqura::UMMALQURA_DAT[i]  && (HijriUmmAlqura::UMMALQURA_DAT[i] > mcjdn)
        return (HijriUmmAlqura::UMMALQURA_DAT[index] - HijriUmmAlqura::UMMALQURA_DAT[index - 1])
      end
      i+=1      
      index+=1
    end
      
    return 30
  end    
end