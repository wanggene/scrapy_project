from scrapy import Spider, Request
from scrapy.selector import Selector
from realtor.items import RealtorItem



class RealtorSpider(Spider):
	name = "realtor_spider" 
	allowed_urls = ['http://www.realtor.com']
	
#	start_urls = ['http://www.realtor.com/soldhomeprices/Flushing_NY?pgsz=50']
#	start_urls = ['http://www.realtor.com/soldhomeprices/Flushing_NY/pg-2?pgsz=50']     # 5 pages each
	start_urls = ['http://www.realtor.com/soldhomeprices/Nassau-County_NY/price-200000-2000000/sby-10/pg-54?pgsz=50']
# # by Date descending, 50 links/page
# page 31



	def verify(self, content):
		if isinstance(content, list):
			if len(content) > 0:
				return content[0]
	 			# In Python 2, everything you scraped is in unicode, which might cause some trouble when you save it to local file.
	 			# The rule of thumb is to encode it with ascii using the following command.
				# return content.encode('ascii','ignore')
			else:
				return ""
		else:
			return content
			# Use the following command if you are using Python 2
			# return content.encode('ascii','ignore')
	
	def parse(self, response):
#		self.log('I just visited: ' + response.url)   # added
		rows = response.xpath('//*[@data-status = "recently_sold"]')
		
		for i in range(1, len(rows)):
			propertyid = rows[i].xpath('.//@data-propertyid').extract_first()  # corrected	
			address = rows[i].xpath('.//*[@class="listing-street-address"]/text()').extract_first() # corrected

			city = rows[i].xpath('.//*[@class="listing-city"]/text()').extract_first()    # corrected

			soldPrice = rows[i].xpath('.//*[@class="srp-item-price"]/text()').extract_first().strip(' |\n') # corrected

			soldDate = rows[i].xpath('.//*[@class="srp-item-price-helper"]/text()').extract()[1].strip(' |\n') #corrected

			state = rows[i].xpath('.//*[@class="listing-region"]/text()').extract_first()	# corrected
			zipcode = rows[i].xpath('.//*[@class="listing-postal"]/text()').extract_first() # corrected

			#neigbous1 = rows[i].xpath('./div[1]/div[2]/div/div[4]/a[1]/text()').extract_first()# northeastern queens
			#neigbous2 = rows[i].xpath('./div[1]/div[2]/div/div[4]/a[2]/text()').extract_first() # corona
			#propertyType = rows[i].xpath('.//*[@class="srp-property-type"]/text()').extract_first() # if detail use detail 
     

			# bedroom = rows[i].xpath('./div[1]/div[2]/div/div[6]/ul/li[1]/span/text()').extract_first()
			bedroom = rows[i].xpath('.//*[@data-label="property-meta-beds"]/span/text()').extract_first() # corrected

			#bathroom = rows[i].xpath('./div[1]/div[2]/div/div[6]/ul/li[2]/span/text()').extract_first() 
			bathroom = rows[i].xpath('.//*[@data-label="property-meta-baths"]/span/text()').extract_first() # corrected

			#floorsize = rows[i].xpath('./div[1]/div[2]/div/div[6]/ul/li[3]/span/text()').extract_first()
			floorsize = rows[i].xpath('.//*[@data-label="property-meta-sqft"]/span/text()').extract_first() # corrected

			#lotsize = rows[i].xpath('./div[1]/div[2]/div/div[6]/ul/li[4]/span/text()').extract_first()
			lotsize = rows[i].xpath('.//*[@data-label="property-meta-lotsize"]/span/text()').extract_first() # corrected

			#lotunit = rows[i].xpath('./div[1]/div[2]/div/div[6]/ul/li[4]/text()').extract_first()
			lotunit = rows[i].xpath('.//*[@data-label="property-meta-lotsize"]/text()').extract_first() #.strip(' |\n') # corrected

			#detailslink= rows[i].xpath('./div[1]/div[2]/div/div/a/@href').extract_first()
			detailslink= rows[i].xpath('.//*[@class="srp-item-ldp-link hidden-xs hidden-xxs"]/a/@href').extract_first() # corrected


		

			# verify 
			propertyid = self.verify(propertyid)
			address = self.verify(address)
			city = self.verify(city)
			soldPrice = self.verify(soldPrice)
			soldDate = self.verify(soldDate)
			state = self.verify(state)
			zipcode = self.verify(zipcode)
			#propertyType = self.verify(propertyType) # move to detail page
			bedroom = self.verify(bedroom)
			bathroom = self.verify(bathroom)
			floorsize = self.verify(floorsize)
			lotsize = self.verify(lotsize)
			lotunit = self.verify(lotunit)
			detailslink = self.verify(detailslink)



			if detailslink:
				details_url = response.urljoin(detailslink)
				yield Request(url = details_url, callback = self.parse_details, 
					meta={'propertyid': propertyid, 'address': address, 'city':city, 'soldPrice': soldPrice,
					'soldDate': soldDate, 'state' : state, 'zipcode': zipcode, 
					'bedroom': bedroom, 'bathroom': bathroom, 'floorsize':floorsize,'lotsize' :lotsize,
					'lotunit': lotunit, 'detailslink': detailslink })


		# following pagination link

		next_page_url = response.xpath('.//span[@class="page current"]/following-sibling::span[1]/a/@href').extract_first()
		#########next_page_url = response.xpath('.//span[@class="page current"]/following-sibling::span/a/@href').extract_first()

		if next_page_url:   # set up how many page each run                    
			next_page_url = response.urljoin(next_page_url)
			# set up a break point
			
			yield Request(url = next_page_url, callback = self.parse)


	def parse_details(self, response):
		propertyid = response.meta['propertyid']
		address = response.meta['address']
		city = response.meta['city']
		soldPrice = response.meta['soldPrice']
		soldDate = response.meta['soldDate']
		state = response.meta['state']
		zipcode = response.meta['zipcode']
		propertyType = response.meta['propertyType'] # pro
		bedroom = response.meta['bedroom']
		bathroom = response.meta['bathroom']
		floorsize = response.meta['floorsize']
		lotsize = response.meta['lotsize']
		lotunit = response.meta['lotunit']
		detailslink = response.meta['detailslink']

		#############
		
		details = response.xpath('//*[@id="market-summary-data"]')

		Detail_1A = details.xpath('.//div/div[1]/div/div/div[2]/div/text()').extract_first().strip(' |\n')
		Detail_1B = details.xpath('.//div/div[1]/div/div/div[2]/span/text()').extract_first().strip(' |\n')

		Detail_2A = details.xpath('.//div/div[2]/div/div/div[2]/div/text()').extract_first()#.strip(' |\n')
		Detail_2B = details.xpath('.//div/div[2]/div/div/div[2]/span/text()').extract_first()#.strip(' |\n')

		Detail_3A = details.xpath('.//div/div[3]/div/div/div[2]/div/text()').extract_first()#.strip(' |\n')
		Detail_3B = details.xpath('.//div/div[3]/div/div/div[2]/span/text()').extract_first()#.strip(' |\n')


		###############
		more_details = response.xpath('//*[@class="listing-section"]')


		propertyType = more_details.xpath('.//*[@data-label="property-type"]/div[2]/text()').extract_first()
		year_built = more_details.xpath('.//*[@data-label="property-year"]/div[2]/text()').extract_first()
		school_district = more_details.xpath('.//*[@id="ldp-detail-schools"]/ul/li/text()').extract_first()#.strip(' |\n')
		


		# lat 
		#location = esponse.xpath('//*[@id="ldp-amenities-map-container"]')
		#lat = location.xpath('./div/@data-property-lat').extract_first()


# details
		Detail_1A = self.verify(Detail_1A)
		Detail_1B = self.verify(Detail_1B)
		Detail_2A = self.verify(Detail_2A)
		Detail_2B = self.verify(Detail_2B)
		Detail_3A = self.verify(Detail_3A)
		Detail_3B = self.verify(Detail_3B)

		propertyType = self.verify(propertyType)
		year_built = self.verify(year_built)
		school_district = self.verify(school_district)

# items
		item = RealtorItem()
		item['propertyid'] = propertyid
		item['address'] = address
		item['city'] = city
		item['soldPrice'] = soldPrice
		item['soldDate'] = soldDate
		item['state'] = state
		item['zipcode'] = zipcode
		item['propertyType'] = propertyType # 
		item['bedroom'] = bedroom
		item['bathroom'] = bathroom
		item['floorsize'] = floorsize
		item['lotsize'] = lotsize
		item['lotunit'] = lotunit
		item['detailslink'] = detailslink

		item['Detail_1A'] = Detail_1A
		item['Detail_1B'] = Detail_1B
		item['Detail_2A'] = Detail_2A
		item['Detail_2B'] = Detail_2B
		item['Detail_3A'] = Detail_3A
		item['Detail_3B'] = Detail_3B

		item['propertyType'] = propertyType
		item['year_built'] = year_built
		item['school_district'] = school_district


		yield item


