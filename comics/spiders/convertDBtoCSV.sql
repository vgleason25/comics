-- SQLite
-- SELECT Title, Series_Title, Issue_Number, Image_url, Condition, Grade, Publisher, Publication_Year, Format, Tradition, Features, Era, Type, Genre, Character, Series, Universe, Sale_Price, Sell_Method, Num_of_Bids, Shipping_Price, Time_of_Sale, Sellers_Location, Sellers_Handle, Sellers_Feedback_Score
-- FROM spiderman;
c:\Users\Vanessa Gleason\projects\comics\spiderman.db
.headers ON
.mode csv
.output spiderman.csv
SELECT Title, Series_Title, Issue_Number, Image_url, Condition, Grade, Publisher, Publication_Year, Format, Tradition, Features, Era, Type, Genre, Character, Series, Universe, Sale_Price, Sell_Method, Num_of_Bids, Shipping_Price, Time_of_Sale, Sellers_Location, Sellers_Handle, Sellers_Feedback_Score
FROM spiderman;
.quit
