import scrapy
from scrapy.linkextractors import LinkExtractor #for rules section
from scrapy.spiders import CrawlSpider, Rule #to go from a regular spider to a crawl spider
from time import sleep #to wait out page changes
import random #to get random wait time
import datetime  # for converting sales dates
#from comics.itemloaders import ComicsItemLoader # dont actually need this?
from itemloaders import ItemLoader  # IDK if I need this in addition to the above?
from scrapy.loader import ItemLoader # https://www.youtube.com/watch?v=wyE4oDxScfE uses this in items.py instead of itemloaders.py
from comics.items import ComicsItem #class holding all the items in items.py
#from forex_python.converter import CurrencyRates dont think i need tha on this page 
from urllib.parse import urlencode #from 17-09
from config import SECRET_SCRAPEOPS_API_KEY #to test

API_KEY = SECRET_SCRAPEOPS_API_KEY

##having issues with not wanting to have my API visible on GitHub so aborting this
def get_proxy_url(url):
   payload = {'api_key': API_KEY, 'url': url}
   proxy_url = 'https://proxy.scrapeops.io/v1/?' + urlencode(payload)
   return proxy_url

class SpidermanSpider(CrawlSpider):
    name = 'spiderman'
    allowed_domains = ['ebay.com']  #try without this for 17-09 "Integrating ScrapeOps" 
    start_urls = ['']
    user_agent = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/107.0.0.0 Safari/537.36'  #try without this for 7-09 "Integrating ScrapeOps" 


    # #below was attempted from 17-09 "Integrating ScrapeOps" --never got it to work
    # def start_requests(self):
    #     start_url = "https://www.ebay.com/sch/259104/i.html?_from=R40&_nkw=spiderman&LH_Sold=1&LH_Complete=1"
    #     yield scrapy.Request(url=get_proxy_url(start_url), callback=self.parse_item)

    #modified to include headers and drop callback from 17-09 "Integrating ScrapeOps" 
    def start_requests(self):
        start_url = "https://www.ebay.com/sch/259104/i.html?_from=R40&_nkw=spiderman&LH_Sold=1&LH_Complete=1"
        yield scrapy.Request(url=get_proxy_url(start_url), headers={
                                 'User-Agent': self.user_agent
                             })

    # #ORIGINAL - it works 
    # def start_requests(self):
    #     yield scrapy.Request(url="https://www.ebay.com/sch/259104/i.html?_from=R40&_nkw=spiderman&LH_Sold=1&LH_Complete=1",
    #                          headers={
    #                              'User-Agent': self.user_agent
    #                          })


    rules = (
        Rule(LinkExtractor(restrict_xpaths="//ul[@class='srp-results srp-list clearfix']/li[contains(@class, 's-item s-item__pl-on-bottom')]/div/div/a"),
             callback='parse_item', follow=True, process_request='set_user_agent'),
        Rule(LinkExtractor(
            restrict_xpaths="//a[@class='pagination__next icon-link']"), process_request='set_user_agent'),
    )


    def set_user_agent(self, request, spider):
        request.headers['User-Agent'] = self.user_agent
        return request


    def parse_item(self, response):
        sleep(random.uniform(0, 1))
        
        #comic_item = ComicsItem()  # ComicsItem defined as a class within items.py

        l = ItemLoader(item=ComicsItem(),  # first, item loader needs instanace of the item by refering to the class
                       response=response)  # second thing you need to provide is the response which equals response as defined in 'def parse_item' above
                        # if you are using a "for products in response.css('div.product-item-info'):" for example, instead of response=response, 
                        #you would have selector=products INSTEAD of response=response
        #add_xpath is the input processor
        l.add_xpath('title', "//h1[@id='itemTitle']/text()") #reqires field name and xpath
        l.add_xpath('series_title', "//span[contains(string(), 'Series Title:')]/../../../following-sibling::div[1]/div/div/span")
        l.add_xpath('issue_number',"//span[contains(string(), 'Issue Number:')]/../../../following-sibling::div[1]/div/div/span")
        l.add_xpath('issue_variant', "//span[contains(string(), 'Variant Type:')]/../../../following-sibling::div[1]/div/div/span")
        l.add_xpath('image_url', "//img[@id='icImg']/@src")
        l.add_xpath('condition', "//div[@id='vi-itm-cond']/text()")  # complete
        l.add_xpath('grade', "//span[contains(string(), 'Grade:')]/../../../following-sibling::div[1]/div/div/span/text()") # complete
        l.add_xpath('publisher', "//span[contains(string(), 'Publisher:')]/../../../following-sibling::div[1]/div/div/span/text()")
        l.add_xpath('publication_year', "//span[contains(string(), 'Publication Year:')]/../../../following-sibling::div[1]/div/div/span/text()")  # the [2] at the end may not be necessary?
        l.add_xpath('format', "//span[contains(string(), 'Format:')]/../../../following-sibling::div[1]/div/div/span")
        l.add_xpath('tradition', "//span[contains(string(), 'Tradition:')]/../../../following-sibling::div[1]/div/div/span/text()")
        l.add_xpath('features', "//span[contains(string(), 'Features:')]/../../../following-sibling::div[1]/div/div/span")
        l.add_xpath('era', "//span[contains(string(), 'Era:')]/../../../following-sibling::div[1]/div/div/span")
        l.add_xpath('type', "//span[contains(string(), 'Type:')]/../../../following-sibling::div[1]/div/div/span/text()")
        l.add_xpath('genre', "//span[contains(string(), 'Genre:')]/../../../following-sibling::div[1]/div/div/span")
        l.add_xpath('character', "//span[contains(string(), 'Character:')]/../../../following-sibling::div[1]/div/div/span/text()")
        l.add_xpath('series', "//span[contains(string(), 'Series:')]/../../../following-sibling::div[1]/div/div/span/text()")
        l.add_xpath('universe', "//span[contains(string(), 'Universe:')]/../../../following-sibling::div[1]/div/div/span/text()")
        l.add_xpath('orig_sale_currency', "//span[contains(@class, 'notranslate')and not(contains(@id,'fshippingCost'))]/text()")  # complete
        l.add_xpath('sale_price_in_USD', "//span[contains(@class, 'notranslate')and not(contains(@id,'fshippingCost'))]/text()")  # complete
        l.add_xpath('shipping_price_in_USD', "//span[@id='fshippingCost']/span/text()")  # complete
        l.add_xpath('sell_method', "//span[contains(@class, 'notranslate')and not(contains(@id,'fshippingCost'))]") # complete
        l.add_xpath('num_of_bids', "//a[@id='vi-VR-bid-lnk-']/span[1]/text()")  # complete
        l.add_xpath('time_of_sale', "//div[@class='u-flL  vi-bboxrev-posabs vi-bboxrev-dsplinline ']/span[1]/text()[1]")  # i think i got this one converted on the intems.py with get_date function
        l.add_xpath('sellers_location', "//div[@class='u-flL lable' and contains(text(),'Located in:')]/following-sibling::div/text()") # complete
        l.add_xpath('sellers_handle', "//span[@class='mbg-nw']/text()")  # complete
        l.add_xpath('sellers_feedback_score', "//a[contains(@aria-label, '(feedback score)')]/text()")  # complete
        l.add_xpath('listing_url', "//h1[@class='it-ttl']/../span/a/@href") #the location used to be: response.url, response.request.url  IDK which is correct 

        #the output process occurs when you call ItemLoader.load_item:
        yield l.load_item()

