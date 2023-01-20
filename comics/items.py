# items.py provide the CONTAINER of scraped data
#
# If you don't use items.py, you just yield data in a dictionary. 
# However, the preferred way of yielding data in Scrapy is using its Item functionality.
# Scrapy Items are simply a predefined data structure that holds your data. Using Scrapy Items has a number of advantages:
# 1) More structured way of storing data.
# 2) Enables easier use of Scrapy Item Pipelines & Item Loaders.
# 3) Ability to configure unit tests with Scrapy extensions like Spidermon.
# See documentation in
# https://docs.scrapy.org/en/latest/topics/items.html

import scrapy
from price_parser import Price
import datetime  # for converting sales dates
# from scrapy.loader import ItemLoader # https://www.youtube.com/watch?v=wyE4oDxScfE uses this in items.py instead of itemloaders.py
from w3lib.html import remove_tags #I dont use this one in this document but youtube video instructors like it. It removes tags
from itemloaders.processors import (TakeFirst, # TakeFirst takes the first value returned in the xpath expression 
                                    MapCompose, # MapCompose takes each item and apply the function to that item Example: MapCompose(get_currency) will apply get_currency to item. Do NOT include (), like MapCompose(get_currency()), it will break
                                    Join, #use inplace of TakeFirst. Returns all info in xpath expression
                                    Compose, 
                                        )

#code from https://www.youtube.com/watch?v=9bGzr0cHQ20 to get price and currency
#youtuber put these in items.py

def verify_issue(raw_issue):

    if raw_issue == None:  # if nothing is entered in issue
        # print(None)
        return raw_issue

    elif raw_issue.isdecimal():  # will only work if there is a single number, no commas or letters
        # print(raw_issue)
        return raw_issue

    # will work if the seller wrote something that starts with the letter "n" like "no, num, no." letter in the issue section
    elif "N" in raw_issue[:1] or "n" in raw_issue[:1]:
        # if these are NOT present, would indicate NOT a lot is being listed with more than one issue
        if "," not in raw_issue and "-" not in raw_issue and "&" not in raw_issue and "/" not in raw_issue:
            result = ''
            for char in raw_issue:
                if char in '1234567890':
                    result += char
            # print(result)
            return result

        else:  # if the above symbols are present, that means a lot is probably listed
            # print(8888)
            return "9999"

    # elif value.isalpha(): #will work if the seller wrote something that starts with a letter in the issue section like "various" or "see description"
    #     #print("is alpha")
    #     return None

    # this means a lot is being listed with more than one issue
    elif "," in raw_issue or "-" in raw_issue or "&" in raw_issue or " " in raw_issue or "/" in raw_issue:
        # print(9999)
        return "9999"
    else:  # this will strip out any letters or symbols
        result = ''
        for char in raw_issue:
            if char in '1234567890':
                result += char
        if result == "":
            return None
        else:
            # print(result)
            return result


def id_variant(value):
    if value == None:  # if nothing is entered in issue
        # print(None)
        return value
    else:
        result = ''
        for char in value:
            if char not in '1234567890#-,/':
                result += char
        if result == "":
            return None
        else:
            # print(result)
            return result

def split_grade(value):

    if value == None:  # this works
        # print(value)
        return value

    else:
        float_strings = value.split()  # splits the grade entry on the spaces
        for f in float_strings:
            # if there are + or - on the grade number, this will get rid of them
            f = f.strip("+-")
            try:
                f = float(f)  # turn f into a float
                return f
            except ValueError:  # this is where parts of the the string that are not the grade number go to die
                pass

def convert_year(value):

    if value == None:  # this works
        # print(value)
        return value
    elif len(value)!=4:
        # print(None)
        return None

    else:
        format = "%Y"

        # convert from string format to datetime format
        theDay = datetime.datetime.strptime(value, format)
        return theDay.year
        # print(theDay.year)

def truncate_string(value):
    value = value[:200]
    return value

def get_price(price_raw):
    price_object = Price.fromstring(price_raw)
# print(price_object)
    if price_object.amount_float == None:
        price = float(0.00)
        return price
    else:
        price=price_object.amount_float
        return price


def get_currency(price_raw):
    price_object = Price.fromstring(price_raw)
    #print(price_object)
    if 'AU' in price_raw:
        currency = 'AUD'
        #print(currency) 
        return currency
    elif 'C' in price_raw:
        currency = 'CAD'
        # print(currency)
        return currency 
    elif price_object.currency == 'US':
        currency = 'USD'
        # print(currency) 
        return currency  
    elif price_object.currency == None:
        currency = 'USD'
        # print(currency)
        return currency
    elif price_object.currency != None and price_object.currency != '$':
        currency=price_object.currency
        # print(currency)
        return currency
    else:
        currency = 'USD'
        # print(currency)
        return currency

def get_date(raw_date):
    if raw_date is not None:
        raw_date = raw_date.replace('\r\n\t\t\t',"")
        # print(raw_date)
        # print(len(raw_date))
        format = "%b %d, %Y"

        # convert from string format to datetime format
        theDay = datetime.datetime.strptime(raw_date, format)

        # get the date from the datetime using date()
        # function
        # print(theDay.date())
        return theDay.date()
    else:
        return raw_date
        # print(raw_date.strip())

def sell_method(value):
    highest_bidder = 'class="notranslate vi-VR-cvipPrice"'
    best_offer_accepted = 'style="font-weight:normal;text-decoration:line-through"'
    if value != None and highest_bidder in value:
        return "highest_bidder"
    elif value != None and best_offer_accepted in value:
        return "best_offer_accepted"
    elif value == None:
        return value
    else:
        return "buy_it_now"

def convert_to_int(value):

    if value == None:  # this works
        # print(value)
        return value

    else:
        value = int(value)  # turn value from string to int
        return value


class ComicsItem(scrapy.Item):
    # define the fields for your item here like:
    # name = scrapy.Field()
    #correct V
    title = scrapy.Field(
        output_processor = TakeFirst() #calling method
        )
    #correct V
    series_title = scrapy.Field(
        input_processor = MapCompose(remove_tags), #calling method
        output_processor = TakeFirst() #calling method
        )
    #correct V
    issue_number = scrapy.Field(
        input_processor = MapCompose(remove_tags, verify_issue),
        output_processor = TakeFirst() #calling method
        )
        #complete V #might be fixed? it is just not as common, I think
    issue_variant = scrapy.Field(
        input_processor = MapCompose(remove_tags), #id_variant
        output_processor = TakeFirst() #calling method
        )
    #correct V
    image_url = scrapy.Field(
        output_processor = TakeFirst() #calling method
        )
    #correct V
    condition = scrapy.Field(
        output_processor = TakeFirst() #calling method
        )
    #correct V
    grade = scrapy.Field(
        input_processor = MapCompose(split_grade),
        output_processor = TakeFirst() #calling method
        )
    #correct V
    publisher = scrapy.Field(
        output_processor = TakeFirst() #calling method
        )
    #correct V
    publication_year = scrapy.Field(
        input_processor = MapCompose(convert_year),
        output_processor = TakeFirst() #calling method
        )
    #correct V    
    format = scrapy.Field(
        input_processor = MapCompose(remove_tags), #calling method
        output_processor = TakeFirst() #calling method
        )

    tradition = scrapy.Field(
        output_processor = TakeFirst() #calling method
        )
    features = scrapy.Field(
        input_processor = MapCompose(remove_tags), #calling method
        output_processor = TakeFirst() #calling method
        )
    era = scrapy.Field(
        input_processor = MapCompose(remove_tags), #calling method
        output_processor = TakeFirst() #calling method
        )
    type = scrapy.Field(
        output_processor = TakeFirst() #calling method
        )
    genre = scrapy.Field(
        input_processor = MapCompose(remove_tags), #calling method
        output_processor = TakeFirst() #calling method
        )
    #correct
    character = scrapy.Field(
        input_processor = MapCompose(truncate_string),
        output_processor = TakeFirst() #calling method
        )
    #correct V
    series = scrapy.Field(
        output_processor = TakeFirst() #calling method
        )
    universe = scrapy.Field(
        output_processor = TakeFirst() #calling method
        )
    #correct V
    orig_sale_currency = scrapy.Field(
        input_processor = MapCompose(get_currency),
        output_processor = TakeFirst() #calling method
       )
    #correct V
    sale_price_in_USD = scrapy.Field(
        input_processor = MapCompose(get_price),
        output_processor = TakeFirst() #calling method
      )
   #correct V
    shipping_price_in_USD = scrapy.Field(
        input_processor = MapCompose(get_price),
        output_processor = TakeFirst()  #calling method
       )
    #correct V
    sell_method = scrapy.Field(
        input_processor = MapCompose(sell_method),
        output_processor = TakeFirst() #calling method
       )
       #complete V
    num_of_bids = scrapy.Field(
        input_processor = MapCompose(convert_to_int),
        output_processor = TakeFirst() #calling method
       )
       #comment out to see if everyone else works
    time_of_sale = scrapy.Field(
        input_processor = MapCompose(remove_tags, get_date),
        output_processor = TakeFirst() #calling method
       )
    #correct V
    sellers_location = scrapy.Field(
        output_processor = TakeFirst() #calling method
       )
    #correct V
    sellers_handle = scrapy.Field(
        output_processor = TakeFirst() #calling method
      )
    #correct V
    sellers_feedback_score = scrapy.Field(
        input_processor = MapCompose(convert_to_int),
        output_processor = TakeFirst() #calling method
       )
    #correct V
    listing_url = scrapy.Field(
        output_processor = TakeFirst() #calling method
      )


