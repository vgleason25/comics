# Define your item pipelines here
#
# Don't forget to add your pipeline to the ITEM_PIPELINES setting
# See: https://docs.scrapy.org/en/latest/topics/item-pipeline.html


# useful for handling different item types with a single interface
from itemadapter import ItemAdapter
import sqlite3


class SQLitePipeline(object):
 
    def open_spider(self, spider):
        self.connection = sqlite3.connect("spiderman.db")
        self.c = self.connection.cursor()
        try: 
            self.c.execute('''
            CREATE TABLE spiderman(
                Title TEXT,
                Series_Title TEXT,
                Issue_Number INTEGER,
                Image_url BLOB,
                Condition TEXT,
                Grade TEXT,
                Publisher TEXT,
                Publication_Year TEXT,
                Format TEXT,
                Tradition TEXT,
                Features TEXT,
                Era TEXT,
                Type TEXT,
                Genre TEXT,
                Character TEXT,
                Series TEXT,
                Universe  TEXT,
                Sale_Price TEXT,
                Sell_Method TEXT,
                Num_of_Bids INTEGER,
                Shipping_Price TEXT,
                Time_of_Sale TEXT,
                Sellers_Location TEXT,
                Sellers_Handle TEXT,
                Sellers_Feedback_Score INTEGER
            )
            ''')
            self.connection.commit()
        except sqlite3.OperationalError:
            pass
 
    def close_spider(self, spider):
       self.connection.close()
 
    def process_item(self, item, spider):
        self.c.execute('''
            INSERT INTO spiderman 
        (Title,Series_Title,Issue_Number,Image_url,Condition,Grade,Publisher,Publication_Year,Format,Tradition,Features,Era,Type,Genre,Character,Series,Universe,Sale_Price,Sell_Method,Num_of_Bids,Shipping_Price,Time_of_Sale,Sellers_Location,Sellers_Handle,Sellers_Feedback_Score) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)
        ''',(
                item.get('Title'),
                item.get('Series_Title'),
                item.get('Issue_Number'),
                item.get('Image_url'),
                item.get('Condition'),
                item.get('Grade'),
                item.get('Publisher'),
                item.get('Publication_Year'),
                item.get('Format'),
                item.get('Tradition'),
                item.get('Features'),
                item.get('Era'),
                item.get('Type'),
                item.get('Genre'),
                item.get('Character'),
                item.get('Series'),
                item.get('Universe'),
                item.get('Sale_Price'),
                item.get('Sell_Method'),
                item.get('Num_of_Bids'),
                item.get('Shipping_Price'),
                item.get('Time_of_Sale'),
                item.get('Sellers_Location'),
                item.get('Sellers_Handle'),
                item.get('Sellers_Feedback_Score'),
        ))
        self.connection.commit()
        return item