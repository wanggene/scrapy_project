from scrapy import Spider, Request
from scrapy.selector import Selector
from realtor.items import RealtorItem


class RealtorSpider(Spider):
	name = "realtor_spider" 
	allowed_urls = ['http://www.realtor.com']
#	start_urls = ['http://www.realtor.com/soldhomeprices/Flushing_NY?pgsz=50']
	start_urls = ['http://www.realtor.com/soldhomeprices/Flushing_NY/pg-2?pgsz=50']



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
			propertyid = rows[i].xpath('./div[1]/@id').extract_first()
			address = rows[i].xpath('./div[1]/div[2]/div/div[3]/a/span[1]/text()').extract_first() 
			city = rows[i].xpath('./div[1]/div[2]/div/div[3]/a/span[2]/text()').extract_first()    
			soldPrice = rows[i].xpath('./div[1]/div[2]/div/div[2]/text()').extract_first() 
			soldDate = rows[i].xpath('./div[1]/div[2]/div/div[2]/span/text()').extract()[1] 
			state = rows[i].xpath('./div[1]/div[2]/div/div[3]/a/span[3]/text()').extract_first() 	
			zipcode = rows[i].xpath('./div[1]/div[2]/div/div[3]/a/span[4]/text()').extract_first() 

			#neigbous1 = rows[i].xpath('./div[1]/div[2]/div/div[4]/a[1]/text()').extract_first()# northeastern queens
			#neigbous2 = rows[i].xpath('./div[1]/div[2]/div/div[4]/a[2]/text()').extract_first() # corona
			propertyType = rows[i].xpath('./div[1]/div[2]/div/div[5]/span/text()').extract_first()     
			bedroom = rows[i].xpath('./div[1]/div[2]/div/div[6]/ul/li[1]/span/text()').extract_first() 
			bathroom = rows[i].xpath('./div[1]/div[2]/div/div[6]/ul/li[2]/span/text()').extract_first()
			floorsize = rows[i].xpath('./div[1]/div[2]/div/div[6]/ul/li[3]/span/text()').extract_first()
			lotsize = rows[i].xpath('./div[1]/div[2]/div/div[6]/ul/li[4]/span/text()').extract_first()
			lotunit = rows[i].xpath('./div[1]/div[2]/div/div[6]/ul/li[4]/text()').extract_first()
			detailslink= rows[i].xpath('./div[1]/div[2]/div/div/a/@href').extract_first()




			# verify 
			propertyid = self.verify(propertyid)
			address = self.verify(address)
			city = self.verify(city)
			soldPrice = self.verify(soldPrice)
			soldDate = self.verify(soldDate)
			state = self.verify(state)
			zipcode = self.verify(zipcode)
			propertyType = self.verify(propertyType)
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
					'soldDate': soldDate, 'state' : state, 'zipcode': zipcode, 'propertyType' :propertyType,
					'bedroom': bedroom, 'bathroom': bathroom, 'floorsize':floorsize,'lotsize' :lotsize,
					'lotunit': lotunit, 'detailslink': detailslink })


		# following pagination link

	#	next_page_url = response.xpath('.//span[@class="page current"]/following-sibling::span/a/@href').extract_first()
	#	if next_page_url:
	#		next_page_url = response.urljoin(next_page_url)
	#		yield Request(url = next_page_url, callback = self.parse)


	def parse_details(self, response):
		propertyid = response.meta['propertyid']
		address = response.meta['address']
		city = response.meta['city']
		soldPrice = response.meta['soldPrice']
		soldDate = response.meta['soldDate']
		state = response.meta['state']
		zipcode = response.meta['zipcode']
		propertyType = response.meta['propertyType']
		bedroom = response.meta['bedroom']
		bathroom = response.meta['bathroom']
		floorsize = response.meta['floorsize']
		lotsize = response.meta['lotsize']
		lotunit = response.meta['lotunit']
		detailslink = response.meta['detailslink']

		details = response.xpath('//*[@id="market-summary-data"]')

		percent_Nearby = details.xpath('./div/div[1]/div/div/div[2]/div/text()').extract_first()
		trend_Nearby = details.xpath('./div/div[1]/div/div/div[2]/span/text()').extract_first()

		days_onmarket = details.xpath('./div/div[2]/div/div/div[2]/div/text()').extract_first()
		onmarket = details.xpath('./div/div[2]/div/div/div[2]/span/text()').extract_first()

		price_change = details.xpath('./div/div[3]/div/div/div[2]/div/text()').extract_first()
		price_trend = details.xpath('./div/div[3]/div/div/div[2]/span/text()').extract_first()



		# lat 
		#location = esponse.xpath('//*[@id="ldp-amenities-map-container"]')
		#lat = location.xpath('./div/@data-property-lat').extract_first()


# details
		percent_Nearby = self.verify(percent_Nearby)
		trend_Nearby = self.verify(trend_Nearby)
		days_onmarket = self.verify(days_onmarket)
		onmarket = self.verify(onmarket)
		price_change = self.verify(price_change)
		price_trend = self.verify(price_trend)

# item
		item = RealtorItem()
		item['propertyid'] = propertyid
		item['address'] = address
		item['city'] = city
		item['soldPrice'] = soldPrice
		item['soldDate'] = soldDate
		item['state'] = state
		item['zipcode'] = zipcode
		item['propertyType'] = propertyType
		item['bedroom'] = bedroom
		item['bathroom'] = bathroom
		item['floorsize'] = floorsize
		item['lotsize'] = lotsize
		item['lotunit'] = lotunit
		item['detailslink'] = detailslink

		item['percent_Nearby'] = percent_Nearby
		item['trend_Nearby'] = trend_Nearby
		item['days_onmarket'] = days_onmarket
		item['onmarket'] = onmarket
		item['price_change'] = price_change
		item['price_trend'] = price_trend


		yield item


