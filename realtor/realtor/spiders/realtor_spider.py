from scrapy import Spider
from scrapy.selector import Selector
from realtor.items import RealtorItem


class RealtorSpider(Spider):
	name = "realtor_spider" 
	allowed_urls = ['http://www.realtor.com']

	start_urls = ['http://www.realtor.com/soldhomeprices/Flushing_NY?pgsz=50']
#				   http://www.realtor.com/soldhomeprices/Flushing_NY/pg-2?pgsz=50



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
		for 


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

			yield item


	

















