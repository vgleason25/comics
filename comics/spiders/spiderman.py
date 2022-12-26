import scrapy
from scrapy.linkextractors import LinkExtractor
from scrapy.spiders import CrawlSpider, Rule
from time import sleep
import random
import datetime #for converting sales dates


class SpidermanSpider(CrawlSpider):
    name = 'spiderman'
    allowed_domains = ['ebay.com']
    # start_urls = ['']
    user_agent='Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/107.0.0.0 Safari/537.36'

    def start_requests(self):
        yield scrapy.Request(url="https://www.ebay.com/sch/259104/i.html?_from=R40&_nkw=spiderman&LH_Sold=1&LH_Complete=1", 
        headers={
            'User-Agent': self.user_agent
        })

    rules = (
        Rule(LinkExtractor(restrict_xpaths="//ul[@class='srp-results srp-list clearfix']/li[contains(@class, 's-item s-item__pl-on-bottom')]/div/div/a"), 
        callback='parse_item', follow=True, process_request='set_user_agent'),
        Rule(LinkExtractor(restrict_xpaths="//a[@class='pagination__next icon-link']"), process_request='set_user_agent'),
    )

    def convert_to_int(self, value):

        if value == None: #this works
            # print(value)
            return value

        else:
            value=int(value) #turn value from string to int
            return value


    def split_grade(self, value):

        if value == None: #this works
            # print(value)
            return value

        else:
            float_strings = value.split() #splits the grade entry on the spaces
            for f in float_strings:
                f= f.strip("+-") #if there are + or - on the grade number, this will get rid of them
                try: 
                    f=float(f) #turn f into a float
                    return f
                except ValueError: #this is where parts of the the string that are not the grade number go to die
                    pass

    def convert_year(self, value):

        if value == None: #this works
            # print(value)
            return value

        else:
            try: 
                format = "%Y"

                # convert from string format to datetime format
                theDay = datetime.datetime.strptime(value, format)
                return theDay.year
                # print(theDay.year)
        
            except ValueError: #this is where parts of the the string that are not the a 4 digit year go to die. Sometimes seller's put in ranges
                pass
        
    def verify_issue(self, value):

        if value == None: #if nothing is entered in issue 
            #print(None)
            return value

        elif value.isdecimal(): #will only work if there is a single number, no commas or letters
            #print(value)
            return value

        elif "N" in value[:1] or "n" in value[:1]: #will work if the seller wrote something that starts with the letter "n" like "no, num, no." letter in the issue section 
            if "," not in value and "-" not in value and "&" not in value and "/" not in value: #if these are NOT present, would indicate NOT a lot is being listed with more than one issue
                result = ''
                for char in value:
                    if char in '1234567890':
                        result += char
                #print(result)
                return result

            else: # if the above symbols are present, that means a lot is probably listed 
                #print(8888)
                return "9999"

        # elif value.isalpha(): #will work if the seller wrote something that starts with a letter in the issue section like "various" or "see description"
        #     #print("is alpha")
        #     return None

        elif "," in value or "-" in value or "&" in value or " " in value or "/" in value: #this means a lot is being listed with more than one issue
            #print(9999)
            return "9999"
        else: #this will strip out any letters or symbols
            result = ''
            for char in value:
                if char in '1234567890':
                    result += char
            if result == "":
                return None
            else:
            # print(result)
                return result  

    
    def id_variant(self, value):
        if value == None: #if nothing is entered in issue 
            #print(None)
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


    def split_currency(self, value):
        substring1 = "$"
        free = "Free"
 
        if value == None or value == free:
            value== 'US' 
            return value

        elif substring1 in value:
            return value.split("$")[0].strip('\n\t\t\t\t\t\t\t\t\t\t') # split gets currency, strip removes sales price characters

        else:
             return value.split()[0]

    def split_price(self, value):
        substring1 = "$"
        #free = "Free"
        if value != None and substring1 in value:

            value = value.split("$")[1].strip('\n\t\t\t\t\t\t\t\t\t\t').replace(",", "") # split gets currency, strip removes sales price characters
            value = float(value)
            value = format(value, '.2f')
            return value
        elif value == None or value == 'free' or value == 'Free' or value == 'FREE':
            value = float('0.00') 
            return value
        else:
            value = value.split()[1].replace(",", "")
            value = float(value)
            value = format(value, '.2f')
            return value
    
    # def remove_Best_Offer_characters(self, value):
    #     if value is not None:
    #         return 1
    #     else:
    #         return 0
    
    def remove_time_of_sale_characters(self, value):
        if value is not None:
            value = value.strip('\r\n\t\t\t')
            # format
            format = "%b %d, %Y"

            # convert from string format to datetime format
            theDay = datetime.datetime.strptime(value, format)

            # get the date from the datetime using date()
            # function
            return theDay.date()
        else:
            return value

    def sell_method(self, value):
        highest_bidder= 'class="notranslate vi-VR-cvipPrice"'
        best_offer_accepted='style="font-weight:normal;text-decoration:line-through"'
        if value != None and highest_bidder in value:
            return "highest_bidder"
        elif value != None and best_offer_accepted in value:
            return "best_offer_accepted"
        elif value == None:
            return value
        else: 
            return "buy_it_now"

    def truncate_string(self, value):
        value = value[:2000]
        return value

    def set_user_agent(self, request, spider):
        request.headers['User-Agent'] = self.user_agent
        return request

    def parse_item(self, response):
        sleep(random.uniform(0,1)) 
        yield {
            'Title': response.xpath("//h1[@id='itemTitle']/text()").get(), #complete
            'Series_Title': response.xpath("//span[contains(string(), 'Series Title:')]/../../../following-sibling::div[1]/div/div/span/text()").get(),
            'Issue_Number': self.verify_issue(response.xpath("//span[contains(string(), 'Issue Number:')]/../../../following-sibling::div[1]/div/div/span/text()").get()),	
            'Issue_Variant': self.id_variant(response.xpath("//span[contains(string(), 'Issue Number:')]/../../../following-sibling::div[1]/div/div/span/text()").get()),	
            'Image_url': response.xpath("//img[@id='icImg']/@src").get(), #complete
            'Condition': response.xpath("//div[@id='vi-itm-cond']/text()").get(), #complete
            'Grade': self.split_grade(response.xpath("//span[contains(string(), 'Grade:')]/../../../following-sibling::div[1]/div/div/span/text()").get()), #complete
            'Publisher': response.xpath("//span[contains(string(), 'Publisher:')]/../../../following-sibling::div[1]/div/div/span/text()").get(), #the [2] at the end may not be necessary?
            'Publication_Year': self.convert_year(response.xpath("//span[contains(string(), 'Publication Year:')]/../../../following-sibling::div[1]/div/div/span/text()").get()), #the [2] at the end may not be necessary?
            'Format': response.xpath("//span[contains(string(), 'Format:')]/../../../following-sibling::div[1]/div/div/span/text()").get(), #the [2] at the end may not be necessary?
            'Tradition': response.xpath("//span[contains(string(), 'Tradition:')]/../../../following-sibling::div[1]/div/div/span/text()").get(), #the [2] at the end may not be necessary?
            'Features': response.xpath("//span[contains(string(), 'Features:')]/../../../following-sibling::div[1]/div/div/span/text()").get(), #the [2] at the end may not be necessary?
            'Era': response.xpath("//span[contains(string(), 'Era:')]/../../../following-sibling::div[1]/div/div/span/text()").get(),
            'Type': response.xpath("//span[contains(string(), 'Type:')]/../../../following-sibling::div[1]/div/div/span/text()").get(),
            'Genre': response.xpath("//span[contains(string(), 'Genre:')]/../../../following-sibling::div[1]/div/div/span/text()").get(),
            'Character': self.truncate_string(response.xpath("//span[contains(string(), 'Character:')]/../../../following-sibling::div[1]/div/div/span/text()")).get(),
            'Series': response.xpath("//span[contains(string(), 'Series:')]/../../../following-sibling::div[1]/div/div/span/text()").get(),
            'Universe': response.xpath("//span[contains(string(), 'Universe:')]/../../../following-sibling::div[1]/div/div/span/text()").get(),
            'Sale_Currency': self.split_currency(response.xpath("//span[contains(@class, 'notranslate')and not(contains(@id,'fshippingCost'))]/text()").get()), #complete
            'Sale_Price': self.split_price(response.xpath("//span[contains(@class, 'notranslate')and not(contains(@id,'fshippingCost'))]/text()").get()), #complete
            'Shipping_Price': self.split_price(response.xpath("//span[@id='fshippingCost']/span/text()").get()), #complete
            #'combined_sale_shipping_price': Sale_Price.value+Shipping_Price
            'Sell_Method': self.sell_method(response.xpath("//span[contains(@class, 'notranslate')and not(contains(@id,'fshippingCost'))]").get()), #complete
            'Num_of_Bids': self.convert_to_int(response.xpath("//a[@id='vi-VR-bid-lnk-']/span[1]/text()").get()), #complete
            # 'Shipping_Currency': self.split_currency(response.xpath("//span[@id='fshippingCost']/span/text()").get()), #complete
            'Time_of_Sale': self.remove_time_of_sale_characters(response.xpath("//div[@class='u-flL  vi-bboxrev-posabs vi-bboxrev-dsplinline ']/span/text()").get()), #try getall to get the date and the time 
            'Sellers_Location': response.xpath("//div[@class='u-flL lable' and contains(text(),'Located in:')]/following-sibling::div/text()").get(), #complete
            'Sellers_Handle': response.xpath("//span[@class='mbg-nw']/text()").get(), #complete
            'Sellers_Feedback_Score': self.convert_to_int(response.xpath("//a[contains(@aria-label, '(feedback score)')]/text()").get()),  #complete
            'listing_url': response.url
       }
