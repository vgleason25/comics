# Define your item pipelines here
#
# Don't forget to add your pipeline to the ITEM_PIPELINES setting
# See: https://docs.scrapy.org/en/latest/topics/item-pipeline.html

# here you do PROCESSING
# useful for handling different item types with a single interface

from itemadapter import ItemAdapter
from scrapy.exceptions import DropItem
from price_parser import Price
from forex_python.converter import CurrencyRates
# from comics.spiders.spiderman import GBPtoUSD, CADtoUSD, AUDtoUSD, EURtoUSD

# from comics.items import orig_sale_currency, sale_price_in_USD

c = CurrencyRates()
GBPtoUSD = c.get_rate('GBP','USD')
CADtoUSD = c.get_rate('CAD','USD')
AUDtoUSD = c.get_rate('AUD','USD')
EURtoUSD = c.get_rate('EUR','USD')

##is the entry blank?
class BlankPipeline:

    def process_item(self, item, spider):
        adapter = ItemAdapter(item)

        #check if title is present
        if adapter.get('title'):
            return item

        else:
            #drop item if no title
            raise DropItem(f"Missing title in {item}")
        
## convert prices to USD and floats
class PriceToUSDPipeline:
    
    def process_item (self, item, spider):
        adapter = ItemAdapter(item)
        c = CurrencyRates()

        if adapter['orig_sale_currency'] != 'USD':
            adapter['sale_price_in_USD'] = c.convert(adapter['orig_sale_currency'], 'USD', adapter['sale_price_in_USD'])
            adapter['shipping_price_in_USD'] = c.convert(adapter['orig_sale_currency'], 'USD', adapter['shipping_price_in_USD'])
            return item
        
        else: 
            return item
            


