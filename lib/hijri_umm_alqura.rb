# -*- coding: utf-8 -*-
# implimintation of UmmAlQura calendar 
# by Mohammed Alsheikh Novmber 2013.
# This work originally implemented in javascript by Keith Wood  keith-wood.name

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
      gregorian_date = format_date(g_date)     
        
      return gregorian_date
    end
            
    # Add Days - Weeks - Months - Years
    def add(date = self, offset, period)
      # ADD YEARS  
      y = period == 'y' ? (date.year + offset) : date.year 
      # ADD MONTHS
      m = period == 'm' ? (month_of_year(date.year, date.month) + offset) : month_of_year(date.year, date.month) 
      d = date.day
        
      begin
        # ADD DAYS OR WEEKS 
        if (period == 'd' || period == 'w') 
          
          week_days = period == 'w' ? 7 : 1
          j_date = jd
          j_date = j_date + offset * week_days 
          result = HijriUmmAlqura.jd(j_date)
          
          return format_date(result)
          
        elsif (period == 'm') 
          
          rys = resync_year_month(y, m)
          y  = rys[0]
          m = rys[1]
          
          return format_date([y, m, d])
          
        elsif (period == 'y') 
          
          return format_date([y, m, d])
          
        end
       
      rescue Exception => msg  
        puts msg 
      end
      
    end
   
    #-------------------------------------------
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
      
    #-------------------------------------------
    def from_month_of_year(year, ord) 
      m = (ord + 1 -2 * 1) % months_in_year + 1
      return m
    end
      
    #-------------------------------------------
    def month_of_year(year,month)
      return (month + months_in_year - 1) % months_in_year + 1
    end
        
    #-------------------------------------------
    def months_in_year
      return 12
    end
      
    #-------------------------------------------
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
      
    #-------------------------------------------  
    def dayofweek(year, month, day) 
      ((HijriUmmAlqura.gd_to_jd(year.to_i, month.to_i, day.to_i).floor + 2) % 7)
    end
      
    #-------------------------------------------
    def weekday(year, month, day) 
      dayofweek(year, month, day)  unless dayofweek(year, month, day) != 5
    end
      
    # return today in hijri plus n days 
    def + (n)
      t = today.split("-")
      case n
      when Numeric then
        return  format_date(add_days(t[0], t[1], t[2], n ) )
      end
      raise TypeError, 'expected numeric'
    end
    
    # Today Hijri
    def today(date = self)  
      today = self.to_s
      return today
    end
  
    # Retrive the day of week
    def dayofweekname(input)
      d = DateTime.new(input[0].to_i,input[1].to_i,input[2].to_i,0,0,0,'+03:00')
      d = weekday(d.strftime("%Y"), d.strftime("%m") ,d.strftime("%d"))        
      puts d
      #case d.to_i
      #when 0 then "السبت"
      #when 1 then "الأحد"
      #when 2 then "الإثنين"
      #when 3 then "الثلاثاء"
      #when 4 then "الأربعاء"
      #when 5 then "الخميس"
      #when 6 then "الجمعة"
      #else
      #end
    end  
    
    # Add left zero to day - month 
    def add_left_zero(input)
      input.to_s.rjust(2,'0')
    end
  
    # Format date to yyyy-mm-dd
    def format_date(input)    
      today = input[0].to_s + "-" + add_left_zero(input[1].to_s) + "-" + add_left_zero(input[2].to_s)
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
  # =>        MODULE METHODS
  #-------------------------------------------------------------------
    
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
	
    return [year, month, day]
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
       
    return year, month, day
  end
    
    
  # Gregorian to hijri
  def HijriUmmAlqura.gd_to_hd(year, month, day)
      
    begin
      j_date = HijriUmmAlqura.gd_to_jd(year,month,day)
      h_date = HijriUmmAlqura.jd(j_date)
      hijri_date = format_date(h_date)
    rescue ArgumentError 
      raise ArgumentError.new("Only numbers are allowed")
    end
      
    return hijri_date
  end
    
end

##########################################################
# Use examples for hijri 
##########################################################
hijri_date = HijriUmmAlqura::Hijri.new(1435,2,12)
    
# 1- return julian date  =>   2456641.5
puts hijri_date.jd

# 2- return formated hijri date =>   ١٢ صفر ١٤٣٥ هـ
puts hijri_date

# 3- return gregorian date  =>   2456641.5
puts hijri_date.gd


# return gregorian date
#puts hijri_date.gd
  
# return hijri date from julian
#puts HijriUmmAlqura.jd(2456641.5)
  
# return hijri date after adding [days-weeks-months-years]
#puts hijri_date.add(55, 'm')

# Convert Gregorian to Hijri (yyyy,mm,dd)
#puts hijri_date.HijriUmmAlqura.gd_to_hd(2014,4,13)

# Convert Hijri to Gregorian (yyyy,mm,dd)
#puts hijri_date.gd(1435,1,30)

# current date in hijri
# puts hijri_date.today

# Current date in hijri with name of month and day

#for i in (1..30) do  
#  d = hijri_date.today.split("-")
#  hdate  = hijri_date.today_with_month_and_day_names(2013,11,i)
#  mdate = hijri_date.jd_to_gd(hijri_date.HijriUmmAlqura.gd_to_jd(2013,11,i))
#  puts  hdate + " >> " + mdate.to_s
#end

#puts hijri_date + 6000

# Convert Gregorian to Hijri (yyyy,mm,dd) with name of month and day
#puts hijri_date.today_with_month_and_day_names(2013,10,30)

#puts hijri_date.add_days('1435', '01', '15' , 15 )