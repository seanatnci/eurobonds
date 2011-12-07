require 'rubygems'
require 'nokogiri'
require 'open-uri'

class EuroBond 
 attr_accessor :country ,:cusip, :price, :updown, :change, :percent, :datetime

# 
 def self.getbond(cusip,country)
  httpstr = 'http://www.bloomberg.com/quote/' + cusip
  doc = Nokogiri::HTML(open(httpstr))
  newdoc = doc.xpath("//div[@class='ticker_header']")
  paradoc = newdoc.css("p")
  spandoc = newdoc.css("span")
  bond = EuroBond.new
  bond.cusip = cusip
  bond.country = country
  spandoc.each do | element |
   str = element.text.strip
   val = element.values
   if val[0] =~ /(price)/
      bond.price = str
   end
   if val[0] =~ /(trending)/
      if val[0] =~ /(down)/
         @updown = "down"
      else
         @updown = "up"
      end
      bond.updown = @updown
      change = str.split(' ')
      bond.change = change[0]
      bond.percent = change[1]
    end
   end
   paradoc.each do | element |
       dt = element.text.strip
       bond.datetime = dt.split('.')[0]
   end
   return bond
 end
#
 def self.getbonds
    bonds = []
    eurobonds = { 'germany' => 'GDBR10:IND',
              'italy' => 'GBTPGR10:IND', 'ireland' => 'GIGB9Y:IND',
              'france' => 'GFRN10:IND', 'belgium' => 'GBGB10YR:IND',
              'austria' => 'GAGB10YR:IND', 'finland' => 'GFIN10YR:IND',
              'greece' => 'GGGB10YR:IND', 'netherlands' => 'GNTH10YR:IND',
              'spain' => 'GSPG10YR:IND', 'portugal' => 'GSPT10YR:IND' }
    eurobonds.each do | key,value |
       bonds << self.getbond(value,key)
    end
    return bonds.sort! { |a,b| b.price.to_f <=> a.price.to_f }
 end
 def changecolor
   @updown == 'up' ? 'green' : 'red'
 end
 def displaychange
   @updown == 'up' ? '+' + change : '-' + change
 end
 def displaypercent
   @updown == 'up' ? '+' + percent : '-' + percent
 end
 def displaydate
   @datetime[6..29]
 end
 def flag
   return @country+'.png'
 end
end



