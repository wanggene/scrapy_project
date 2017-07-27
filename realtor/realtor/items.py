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
	#propertyType = scrapy.Field() #
	zipcode = scrapy.Field() #
	detailslink = scrapy.Field() # 
	soldPrice = scrapy.Field() #
	soldDate = scrapy.Field() #
	bedroom = scrapy.Field() #
	bathroom = scrapy.Field() #
	floorsize = scrapy.Field() #
	lotsize = scrapy.Field() #
	lotunit = scrapy.Field() #


	Detail_1A = scrapy.Field()
	Detail_1B = scrapy.Field()
	Detail_2A = scrapy.Field()
	Detail_2B = scrapy.Field()
	Detail_3A = scrapy.Field()
	Detail_3B = scrapy.Field()

	propertyType = scrapy.Field() #
	year_built = scrapy.Field()
	school_district = scrapy.Field()


    # item in 
    #priceCompare = scrapy.Field()
    #listingTime = scrapy.Field()
    #priceSqft = scrapy.Field()
    #built = scrapy.Field()
    
