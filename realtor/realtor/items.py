# -*- coding: utf-8 -*-

# Define here the models for your scraped items
#
# See documentation in:
# http://doc.scrapy.org/en/latest/topics/items.html

import scrapy

class RealtorItem(scrapy.Item):
	propertyid = scrapy.Field() 
	address = scrapy.Field() #
	city = scrapy.Field() #
	state = scrapy.Field() #
	#nabeigh = scrapy.Field() #
	propertyType = scrapy.Field() #
	zipcode = scrapy.Field() #
	detailslink = scrapy.Field() # 
	soldPrice = scrapy.Field() #
	soldDate = scrapy.Field() #
	bedroom = scrapy.Field() #
	bathroom = scrapy.Field() #
	floorsize = scrapy.Field() #
	lotsize = scrapy.Field() #
	lotunit = scrapy.Field() #


	percent_Nearby = scrapy.Field()
	trend_Nearby = scrapy.Field()
	days_onmarket = scrapy.Field()
	onmarket = scrapy.Field()
	price_change = scrapy.Field()
	price_trend = scrapy.Field()

    # item in 
    #priceCompare = scrapy.Field()
    #listingTime = scrapy.Field()
    #priceSqft = scrapy.Field()
    #built = scrapy.Field()
    
