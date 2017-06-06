R.Version()
getwd()
setwd("C:/Users/JJ/Documents/text_mining")
getwd()

install.packages("twitteR") 
install.packages("httpuv") 
install.packages("ROAuth")
install.packages("stringr")
install.packages("tm") 
install.packages("ggmap") 
install.packages("dplyr") 
install.packages("plyr")
install.packages("wordcloud")
install.packages("openssl") 


library(twitteR) 
library(httpuv) 
library(ROAuth) 
library(RCurl)
library(bitops)
library(stringr) 
library(tm) 
library(NLP) 
library(ggmap)
library(ggplot2) 
library(plyr)
library(dplyr) 
library(wordcloud) 
library(RColorBrewer) 
library(openssl) 

key="RfZSx1YhwImHuDCKoPozuLK5i"
secret="edyh0wrpoLyaCKwia0DJoVm5m41Y33c278LQqZRfFh8R1v3pNH"
download.file(url="http://curl.haxx.se/ca/cacert.pem",destfile="C:/Users/JJ/Documents/text_mining/cacert.pem",method="auto")
authenticate <- OAuthFactory$new(consumerKey=key,consumerSecret=secret,requestURL="https://api.twitter.com/oauth/request_token",accessURL="https://api.twitter.com/oauth/access_token",authURL="https://api.twitter.com/oauth/authorize")
setup_twitter_oauth(key, secret)
save(authenticate, file="twitter authentication.Rdata")

# Run Twitter Search. Format is searchTwitter("Search Terms", n=100, lang="en", geocode="lat,lng", also accepts since and until).
#cities=DC,New York,San Fransisco,Colorado,Mountainview,Tampa,Austin,Boston,
# Seatle,Vegas,Montgomery,Phoenix,Little Rock,Atlanta,Springfield,
# Cheyenne,Bisruk,Helena,Springfield,Madison,Lansing,Salt Lake City,Nashville
# Jefferson City,Raleigh,Harrisburg,Boise,Lincoln,Salem,St. Paul

trump_tweets_loc1<- searchTwitteR('@realDonaldTrump', n = 2000,geocode='38.9,-77,5mi')
trump_tweets_loc2<- searchTwitteR('@realDonaldTrump', n = 2000,geocode='40.7,-74,5mi')
trump_tweets_loc3<- searchTwitteR('@realDonaldTrump', n = 2000,geocode='37.8,-122,15mi')

trump_tweets_loc4<- searchTwitteR('@realDonaldTrump', n = 2000,geocode='39,-105.5,35mi')
trump_tweets_loc5<- searchTwitteR('@realDonaldTrump', n = 2000,geocode='37.4,-122,10mi')
trump_tweets_loc6<- searchTwitteR('@realDonaldTrump', n = 2000,geocode='28,-82.5,5mi')

trump_tweets_loc7<- searchTwitteR('@realDonaldTrump', n = 2000,geocode='30,-98,50mi')
trump_tweets_loc8<- searchTwitteR('@realDonaldTrump', n = 2000,geocode='42.4,-71,5mi')
trump_tweets_loc9<- searchTwitteR('@realDonaldTrump', n = 2000,geocode='48,-122,50mi')

trump_tweets_loc10<- searchTwitteR('@realDonaldTrump', n = 2000,geocode='36,-115,10mi')
trump_tweets_loc11<- searchTwitteR('@realDonaldTrump', n = 2000,geocode='32.3,-86.3,50mi')
trump_tweets_loc12<- searchTwitteR('@realDonaldTrump', n = 2000,geocode='33.5,-112,5mi')

trump_tweets_loc13<- searchTwitteR('@realDonaldTrump', n = 2000,geocode='34.7,-92.3,30mi')
trump_tweets_loc14<- searchTwitteR('@realDonaldTrump', n = 2000,geocode='33.8,-84.4,5mi')
trump_tweets_loc15<- searchTwitteR('@realDonaldTrump', n = 2000,geocode='37.2,-93.3,100mi')

trump_tweets_loc16<- searchTwitteR('@realDonaldTrump', n = 2000,geocode='41.2,-104.8,100mi')
trump_tweets_loc17<- searchTwitteR('@realDonaldTrump', n = 2000,geocode='46.8,-100.8,200mi')
trump_tweets_loc18<- searchTwitteR('@realDonaldTrump', n = 2000,geocode='46.6,-112,200mi')

trump_tweets_loc19<- searchTwitteR('@realDonaldTrump', n = 2000,geocode='37.2,-93.3,100mi')
trump_tweets_loc20<- searchTwitteR('@realDonaldTrump', n = 2000,geocode='43,-89,200mi')
trump_tweets_loc21<- searchTwitteR('@realDonaldTrump', n = 2000,geocode='42.7,-84.5,40mi')

trump_tweets_loc22<- searchTwitteR('@realDonaldTrump', n = 2000,geocode='40.8,-111.8,200mi')
trump_tweets_loc23<- searchTwitteR('@realDonaldTrump', n = 2000,geocode='36.2,-86.8,5mi')
trump_tweets_loc24<- searchTwitteR('@realDonaldTrump', n = 2000,geocode='38.6,-92.2,150mi')

trump_tweets_loc25<- searchTwitteR('@realDonaldTrump', n = 2000,geocode='35.8,-78.6,5mi')
trump_tweets_loc26<- searchTwitteR('@realDonaldTrump', n = 2000,geocode='40.3,-76.8,50mi')
trump_tweets_loc27<- searchTwitteR('@realDonaldTrump', n = 2000,geocode='43.6,-116.2,200mi')

trump_tweets_loc28<- searchTwitteR('@realDonaldTrump', n = 2000,geocode='40.8,-98.7,200mi')
trump_tweets_loc29<- searchTwitteR('@realDonaldTrump', n = 2000,geocode='44.9,-123,100mi')
trump_tweets_loc30<- searchTwitteR('@realDonaldTrump', n = 2000,geocode='44.9,-93,200mi')

feed_trump_loc1 = laply(trump_tweets_loc1, function(t) t$getText()) 
feed_trump_loc2 = laply(trump_tweets_loc2, function(t) t$getText()) 
feed_trump_loc3 = laply(trump_tweets_loc3, function(t) t$getText()) 

feed_trump_loc4 = laply(trump_tweets_loc4, function(t) t$getText()) 
feed_trump_loc5 = laply(trump_tweets_loc5, function(t) t$getText()) 
feed_trump_loc6 = laply(trump_tweets_loc6, function(t) t$getText())

feed_trump_loc7 = laply(trump_tweets_loc7, function(t) t$getText()) 
feed_trump_loc8 = laply(trump_tweets_loc8, function(t) t$getText()) 
feed_trump_loc9 = laply(trump_tweets_loc9, function(t) t$getText()) 

feed_trump_loc10 = laply(trump_tweets_loc10, function(t) t$getText()) 
feed_trump_loc11 = laply(trump_tweets_loc11, function(t) t$getText()) 
feed_trump_loc12 = laply(trump_tweets_loc12, function(t) t$getText()) 

feed_trump_loc13 = laply(trump_tweets_loc13, function(t) t$getText()) 
feed_trump_loc14 = laply(trump_tweets_loc14, function(t) t$getText()) 
feed_trump_loc15 = laply(trump_tweets_loc15, function(t) t$getText()) 

feed_trump_loc16 = laply(trump_tweets_loc16, function(t) t$getText()) 
feed_trump_loc17 = laply(trump_tweets_loc17, function(t) t$getText()) 
feed_trump_loc18 = laply(trump_tweets_loc18, function(t) t$getText()) 

feed_trump_loc19 = laply(trump_tweets_loc19, function(t) t$getText()) 
feed_trump_loc20 = laply(trump_tweets_loc20, function(t) t$getText()) 
feed_trump_loc21 = laply(trump_tweets_loc21, function(t) t$getText()) 

feed_trump_loc22 = laply(trump_tweets_loc22, function(t) t$getText()) 
feed_trump_loc23 = laply(trump_tweets_loc23, function(t) t$getText()) 
feed_trump_loc24 = laply(trump_tweets_loc24, function(t) t$getText()) 

feed_trump_loc25 = laply(trump_tweets_loc25, function(t) t$getText()) 
feed_trump_loc26 = laply(trump_tweets_loc26, function(t) t$getText()) 
feed_trump_loc27 = laply(trump_tweets_loc27, function(t) t$getText()) 

feed_trump_loc28 = laply(trump_tweets_loc28, function(t) t$getText()) 
feed_trump_loc29 = laply(trump_tweets_loc29, function(t) t$getText()) 
feed_trump_loc30 = laply(trump_tweets_loc30, function(t) t$getText())

# import words
pos = scan('positive-words.txt', what='character', comment.char=';')
neg = scan('negative-words.txt', what='character', comment.char=';')
ter = scan('terrible-words.txt', what='character', comment.char=';')
won = scan('wonderful-words.txt', what='character', comment.char=';')
pol = scan('policy-words.txt', what='character', comment.char=';')

# function score.sentiment
score.sentiment = function(sentences, pos.words, neg.words, ter.words, won.words, pol.words, .progress='none')
{
  # Parameters
  # sentences: vector of text to score
  # pos.words: vector of words of postive sentiment
  # neg.words: vector of words of negative sentiment
  # ter.words: vector of words of terrible sentiment
  # won.words: vector of words of wonderful sentiment
  # pol.words: vector of words of policy sentiment
  # .progress: passed to laply() to control of progress bar
  # create simple array of scores with laply
  scores = laply(sentences,
                 function(sentence, pos.words, neg.words, ter.words, won.words, pol.words)
                 {
                   # remove punctuation
                   sentence = gsub("[[:punct:]]", "", sentence)
                   # remove control characters
                   sentence = gsub("[[:cntrl:]]", "", sentence)
                   # remove digits?
                   sentence = gsub('\\d+', '', sentence)
                   # define error handling function when trying tolower
                   tryTolower = function(x)
                   {
                     # create missing value
                     y = NA
                     # tryCatch error
                     try_error = tryCatch(tolower(x), error=function(e) e)
                     # if not an error
                     if (!inherits(try_error, "error"))
                       y = tolower(x)
                     # result
                     return(y)
                   }
                   # use tryTolower with sapply
                   sentence = sapply(sentence, tryTolower)
                   # split sentence into words with str_split (stringr package)
                   word.list = str_split(sentence, "\\s+")
                   words = unlist(word.list)
                   # compare words to the dictionaries of positive, negative, terrible, wonderful and policy terms
                   pos.matches = match(words, pos.words)
                   neg.matches = match(words, neg.words)
                   ter.matches = match(words, ter.words)
                   won.matches = match(words, won.words)
                   pol.matches = match(words, pol.words)

                   # get the position of the matched term or NA
                   # we just want a TRUE/FALSE
                   pos.matches = !is.na(pos.matches)
                   neg.matches = !is.na(neg.matches)
                   ter.matches = !is.na(ter.matches)
                   won.matches = !is.na(won.matches)
                   pol.matches = !is.na(pol.matches)
                   
                   # final score
                   score = sum(pos.matches) - sum(neg.matches) - sum(ter.matches)*2 + sum(won.matches)*2 + sum(pol.matches)
                   return(score)
                 }, pos.words, neg.words, ter.words, won.words, pol.words, .progress=.progress )
  # data frame with scores for each sentence
  scores.df = data.frame(text=sentences, score=scores)
  return(scores.df)
}

# Call the function and return a data frame 
feelthatrump_loc1 <- score.sentiment(feed_trump_loc1, pos, neg, ter, won, pol, .progress='text') 
feelthatrump_loc2 <- score.sentiment(feed_trump_loc2, pos, neg, ter, won, pol, .progress='text')
feelthatrump_loc3 <- score.sentiment(feed_trump_loc3, pos, neg, ter, won, pol, .progress='text')

feelthatrump_loc4 <- score.sentiment(feed_trump_loc4, pos, neg, ter, won, pol, .progress='text')
feelthatrump_loc5 <- score.sentiment(feed_trump_loc5, pos, neg, ter, won, pol, .progress='text')
feelthatrump_loc6 <- score.sentiment(feed_trump_loc6, pos, neg, ter, won, pol, .progress='text')

feelthatrump_loc7 <- score.sentiment(feed_trump_loc7, pos, neg, ter, won, pol, .progress='text')
feelthatrump_loc8 <- score.sentiment(feed_trump_loc8, pos, neg, ter, won, pol, .progress='text')
feelthatrump_loc9 <- score.sentiment(feed_trump_loc9, pos, neg, ter, won, pol, .progress='text')

feelthatrump_loc10 <- score.sentiment(feed_trump_loc10, pos, neg, ter, won, pol, .progress='text')
feelthatrump_loc11 <- score.sentiment(feed_trump_loc11, pos, neg, ter, won, pol, .progress='text') 
feelthatrump_loc12 <- score.sentiment(feed_trump_loc12, pos, neg, ter, won, pol, .progress='text')

feelthatrump_loc13 <- score.sentiment(feed_trump_loc13, pos, neg, ter, won, pol, .progress='text')
feelthatrump_loc14 <- score.sentiment(feed_trump_loc14, pos, neg, ter, won, pol, .progress='text')
feelthatrump_loc15 <- score.sentiment(feed_trump_loc15, pos, neg, ter, won, pol, .progress='text')

feelthatrump_loc16 <- score.sentiment(feed_trump_loc16, pos, neg, ter, won, pol, .progress='text')
feelthatrump_loc17 <- score.sentiment(feed_trump_loc17, pos, neg, ter, won, pol, .progress='text')
feelthatrump_loc18 <- score.sentiment(feed_trump_loc18, pos, neg, ter, won, pol, .progress='text')

feelthatrump_loc19 <- score.sentiment(feed_trump_loc19, pos, neg, ter, won, pol, .progress='text')
feelthatrump_loc20 <- score.sentiment(feed_trump_loc20, pos, neg, ter, won, pol, .progress='text')
feelthatrump_loc21 <- score.sentiment(feed_trump_loc21, pos, neg, ter, won, pol, .progress='text') 

feelthatrump_loc22 <- score.sentiment(feed_trump_loc22, pos, neg, ter, won, pol, .progress='text')
feelthatrump_loc23 <- score.sentiment(feed_trump_loc23, pos, neg, ter, won, pol, .progress='text')
feelthatrump_loc24 <- score.sentiment(feed_trump_loc24, pos, neg, ter, won, pol, .progress='text')

feelthatrump_loc25 <- score.sentiment(feed_trump_loc25, pos, neg, ter, won, pol, .progress='text')
feelthatrump_loc26 <- score.sentiment(feed_trump_loc26, pos, neg, ter, won, pol, .progress='text')
feelthatrump_loc27 <- score.sentiment(feed_trump_loc27, pos, neg, ter, won, pol, .progress='text')

feelthatrump_loc28 <- score.sentiment(feed_trump_loc28, pos, neg, ter, won, pol, .progress='text')
feelthatrump_loc29 <- score.sentiment(feed_trump_loc29, pos, neg, ter, won, pol, .progress='text')
feelthatrump_loc30 <- score.sentiment(feed_trump_loc30, pos, neg, ter, won, pol, .progress='text')

write.csv(feelthatrump_loc1, "donaldtrump_score_loc1.csv",row.names = F)
write.csv(feelthatrump_loc2, "donaldtrump_score_loc2.csv",row.names = F)
write.csv(feelthatrump_loc3, "donaldtrump_score_loc3.csv",row.names = F)

write.csv(feelthatrump_loc4, "donaldtrump_score_loc4.csv",row.names = F)
write.csv(feelthatrump_loc5, "donaldtrump_score_loc5.csv",row.names = F)
write.csv(feelthatrump_loc6, "donaldtrump_score_loc6.csv",row.names = F)

write.csv(feelthatrump_loc7, "donaldtrump_score_loc7.csv",row.names = F)
write.csv(feelthatrump_loc8, "donaldtrump_score_loc8.csv",row.names = F)
write.csv(feelthatrump_loc9, "donaldtrump_score_loc9.csv",row.names = F)

write.csv(feelthatrump_loc10, "donaldtrump_score_loc10.csv",row.names = F)
write.csv(feelthatrump_loc11, "donaldtrump_score_loc11.csv",row.names = F)
write.csv(feelthatrump_loc12, "donaldtrump_score_loc12.csv",row.names = F)

write.csv(feelthatrump_loc13, "donaldtrump_score_loc13.csv",row.names = F)
write.csv(feelthatrump_loc14, "donaldtrump_score_loc14.csv",row.names = F)
write.csv(feelthatrump_loc15, "donaldtrump_score_loc15.csv",row.names = F)

write.csv(feelthatrump_loc16, "donaldtrump_score_loc16.csv",row.names = F)
write.csv(feelthatrump_loc17, "donaldtrump_score_loc17.csv",row.names = F)
write.csv(feelthatrump_loc18, "donaldtrump_score_loc18.csv",row.names = F)

write.csv(feelthatrump_loc19, "donaldtrump_score_loc19.csv",row.names = F)
write.csv(feelthatrump_loc20, "donaldtrump_score_loc20.csv",row.names = F)
write.csv(feelthatrump_loc21, "donaldtrump_score_loc21.csv",row.names = F)

write.csv(feelthatrump_loc22, "donaldtrump_score_loc22.csv",row.names = F)
write.csv(feelthatrump_loc23, "donaldtrump_score_loc23.csv",row.names = F)
write.csv(feelthatrump_loc24, "donaldtrump_score_loc24.csv",row.names = F)

write.csv(feelthatrump_loc25, "donaldtrump_score_loc25.csv",row.names = F)
write.csv(feelthatrump_loc26, "donaldtrump_score_loc26.csv",row.names = F)
write.csv(feelthatrump_loc27, "donaldtrump_score_loc27.csv",row.names = F)

write.csv(feelthatrump_loc28, "donaldtrump_score_loc28.csv",row.names = F)
write.csv(feelthatrump_loc29, "donaldtrump_score_loc29.csv",row.names = F)
write.csv(feelthatrump_loc30, "donaldtrump_score_loc30.csv",row.names = F)

trump_tweets_loc1.df <- twListToDF(trump_tweets_loc1)
write.csv(trump_tweets_loc1.df, "donaldtrump_df1.csv",row.names = F)
trump_tweets_loc2.df <- twListToDF(trump_tweets_loc2)
write.csv(trump_tweets_loc2.df, "donaldtrump_df2.csv",row.names = F)
trump_tweets_loc3.df <- twListToDF(trump_tweets_loc3)
write.csv(trump_tweets_loc3.df, "donaldtrump_df3.csv",row.names = F)

trump_tweets_loc4.df <- twListToDF(trump_tweets_loc4)
write.csv(trump_tweets_loc4.df, "donaldtrump_df4.csv",row.names = F)
trump_tweets_loc5.df <- twListToDF(trump_tweets_loc5)
write.csv(trump_tweets_loc5.df, "donaldtrump_df5.csv",row.names = F)
trump_tweets_loc6.df <- twListToDF(trump_tweets_loc6)
write.csv(trump_tweets_loc6.df, "donaldtrump_df6.csv",row.names = F)

trump_tweets_loc7.df <- twListToDF(trump_tweets_loc7)
write.csv(trump_tweets_loc7.df, "donaldtrump_df7.csv",row.names = F)
trump_tweets_loc8.df <- twListToDF(trump_tweets_loc8)
write.csv(trump_tweets_loc8.df, "donaldtrump_df8.csv",row.names = F)
trump_tweets_loc9.df <- twListToDF(trump_tweets_loc9)
write.csv(trump_tweets_loc9.df, "donaldtrump_df9.csv",row.names = F)

trump_tweets_loc10.df <- twListToDF(trump_tweets_loc10)
write.csv(trump_tweets_loc10.df, "donaldtrump_df10.csv",row.names = F)
trump_tweets_loc11.df <- twListToDF(trump_tweets_loc11)
write.csv(trump_tweets_loc11.df, "donaldtrump_df11.csv",row.names = F)
trump_tweets_loc12.df <- twListToDF(trump_tweets_loc12)
write.csv(trump_tweets_loc12.df, "donaldtrump_df12.csv",row.names = F)

trump_tweets_loc13.df <- twListToDF(trump_tweets_loc13)
write.csv(trump_tweets_loc13.df, "donaldtrump_df13.csv",row.names = F)
trump_tweets_loc14.df <- twListToDF(trump_tweets_loc14)
write.csv(trump_tweets_loc14.df, "donaldtrump_df14.csv",row.names = F)
trump_tweets_loc15.df <- twListToDF(trump_tweets_loc15)
write.csv(trump_tweets_loc15.df, "donaldtrump_df15.csv",row.names = F)

trump_tweets_loc16.df <- twListToDF(trump_tweets_loc16)
write.csv(trump_tweets_loc16.df, "donaldtrump_df16.csv",row.names = F)
trump_tweets_loc17.df <- twListToDF(trump_tweets_loc17)
write.csv(trump_tweets_loc17.df, "donaldtrump_df17.csv",row.names = F)
trump_tweets_loc18.df <- twListToDF(trump_tweets_loc18)
write.csv(trump_tweets_loc18.df, "donaldtrump_df18.csv",row.names = F)

trump_tweets_loc19.df <- twListToDF(trump_tweets_loc19)
write.csv(trump_tweets_loc19.df, "donaldtrump_df19.csv",row.names = F)
trump_tweets_loc20.df <- twListToDF(trump_tweets_loc20)
write.csv(trump_tweets_loc20.df, "donaldtrump_df20.csv",row.names = F)
trump_tweets_loc21.df <- twListToDF(trump_tweets_loc21)
write.csv(trump_tweets_loc21.df, "donaldtrump_df21.csv",row.names = F)

trump_tweets_loc22.df <- twListToDF(trump_tweets_loc22)
write.csv(trump_tweets_loc22.df, "donaldtrump_df22.csv",row.names = F)
trump_tweets_loc23.df <- twListToDF(trump_tweets_loc23)
write.csv(trump_tweets_loc23.df, "donaldtrump_df23.csv",row.names = F)
trump_tweets_loc24.df <- twListToDF(trump_tweets_loc24)
write.csv(trump_tweets_loc24.df, "donaldtrump_df24.csv",row.names = F)

trump_tweets_loc25.df <- twListToDF(trump_tweets_loc25)
write.csv(trump_tweets_loc25.df, "donaldtrump_df25.csv",row.names = F)
trump_tweets_loc26.df <- twListToDF(trump_tweets_loc26)
write.csv(trump_tweets_loc26.df, "donaldtrump_df26.csv",row.names = F)
trump_tweets_loc27.df <- twListToDF(trump_tweets_loc27)
write.csv(trump_tweets_loc27.df, "donaldtrump_df27.csv",row.names = F)

trump_tweets_loc28.df <- twListToDF(trump_tweets_loc28)
write.csv(trump_tweets_loc28.df, "donaldtrump_df28.csv",row.names = F)
trump_tweets_loc29.df <- twListToDF(trump_tweets_loc29)
write.csv(trump_tweets_loc29.df, "donaldtrump_df29.csv",row.names = F)
trump_tweets_loc30.df <- twListToDF(trump_tweets_loc30)
write.csv(trump_tweets_loc30.df, "donaldtrump_df30.csv",row.names = F)



