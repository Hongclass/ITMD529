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
install.packages("RJSONIO")

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
library(RJSONIO)


key="RfZSx1YhwImHuDCKoPozuLK5i"
secret="edyh0wrpoLyaCKwia0DJoVm5m41Y33c278LQqZRfFh8R1v3pNH"
download.file(url="http://curl.haxx.se/ca/cacert.pem",destfile="C:/Users/JJ/Documents/text_mining/cacert.pem",method="auto")
authenticate <- OAuthFactory$new(consumerKey=key,consumerSecret=secret,requestURL="https://api.twitter.com/oauth/request_token",accessURL="https://api.twitter.com/oauth/access_token",authURL="https://api.twitter.com/oauth/authorize")
setup_twitter_oauth(key, secret)
save(authenticate, file="twitter authentication.Rdata")

# Run Twitter Search. Format is searchTwitter("Search Terms", n=100, lang="en", geocode="lat,lng", also accepts since and until).
# Trump:11/5
tweets_trump5 <- searchTwitter('@realDonaldTrump', n=500, since="2016-11-05", until="2016-11-06")
feed_trump5 = laply(tweets_trump5, function(t) t$getText()) 
write.csv(feed_trump5, "donaldtrump5.csv",row.names = F) 

# Trump:11/6
tweets_trump6 <- searchTwitter('@realDonaldTrump', n=500, since="2016-11-06", until="2016-11-07")
feed_trump6 = laply(tweets_trump6, function(t) t$getText()) 
write.csv(feed_trump6, "donaldtrump6.csv",row.names = F)

# Trump:11/7
tweets_trump7 <- searchTwitter('@realDonaldTrump', n=500, since="2016-11-07", until="2016-11-08")
feed_trump7 = laply(tweets_trump7, function(t) t$getText()) 
write.csv(feed_trump7, "donaldtrump7.csv",row.names = F)

# Trump:11/8
tweets_trump8 <- searchTwitter('@realDonaldTrump', n=500, since="2016-11-08", until="2016-11-09")
feed_trump8 = laply(tweets_trump8, function(t) t$getText()) 
write.csv(feed_trump8, "donaldtrump8.csv",row.names = F)

# Trump:11/9
tweets_trump9 <- searchTwitter('@realDonaldTrump', n=500, since="2016-11-09", until="2016-11-10")
feed_trump9 = laply(tweets_trump9, function(t) t$getText()) 
write.csv(feed_trump9, "donaldtrump9.csv",row.names = F)

# Trump:11/10
tweets_trump10 <- searchTwitter('@realDonaldTrump', n=500, since="2016-11-10", until="2016-11-11")
feed_trump10 = laply(tweets_trump10, function(t) t$getText()) 
write.csv(feed_trump10, "donaldtrump10.csv",row.names = F) 

# Trump:11/11
tweets_trump11 <- searchTwitter('@realDonaldTrump', n=500, since="2016-11-11", until="2016-11-12")
feed_trump11 = laply(tweets_trump11, function(t) t$getText()) 
write.csv(feed_trump11, "donaldtrump11.csv",row.names = F)

# Clinton:11/5
tweets_clinton5 <- searchTwitter('@HillaryClinton', n=500, since="2016-11-05", until="2016-11-06")
feed_clinton5 = laply(tweets_clinton5, function(t) t$getText()) 
write.csv(feed_clinton5, "hilarlaryclinton5.csv",row.names = F) 

# Clinton:11/6
tweets_clinton6 <- searchTwitter('@HillaryClinton', n=500, since="2016-11-06", until="2016-11-07")
feed_clinton6 = laply(tweets_clinton6, function(t) t$getText()) 
write.csv(feed_clinton6, "hilarlaryclinton6.csv",row.names = F)

# Clinton:11/7
tweets_clinton7 <- searchTwitter('@HillaryClinton', n=500, since="2016-11-07", until="2016-11-08")
feed_clinton7 = laply(tweets_clinton7, function(t) t$getText()) 
write.csv(feed_clinton7, "hilarlaryclinton7.csv",row.names = F)

# Clinton:11/8
tweets_clinton8 <- searchTwitter('@HillaryClinton', n=500, since="2016-11-08", until="2016-11-09")
feed_clinton8 = laply(tweets_clinton8, function(t) t$getText()) 
write.csv(feed_clinton8, "hilarlaryclinton8.csv",row.names = F)

# Clinton:11/9
tweets_clinton9 <- searchTwitter('@HillaryClinton', n=500, since="2016-11-09", until="2016-11-10")
feed_clinton9 = laply(tweets_clinton9, function(t) t$getText()) 
write.csv(feed_clinton9, "hilarlaryclinton9.csv",row.names = F)

# Clinton:11/10
tweets_clinton10 <- searchTwitter('@HillaryClinton', n=500, since="2016-11-10", until="2016-11-11")
feed_clinton10 = laply(tweets_clinton10, function(t) t$getText()) 
write.csv(feed_clinton10, "hilarlaryclinton10.csv",row.names = F) 

# Clinton:11/11
tweets_clinton11 <- searchTwitter('@HillaryClinton', n=500, since="2016-11-11", until="2016-11-12")
feed_clinton11 = laply(tweets_clinton11, function(t) t$getText()) 
write.csv(feed_clinton11, "hilarlaryclinton11.csv",row.names = F)

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
# 11/5
feelthatrump5 <- score.sentiment(feed_trump5, pos, neg, ter, won, pol, .progress='text') 
feelthaclinton5 <- score.sentiment(feed_clinton5, pos, neg, ter, won, pol, .progress='text')
# 11/6
feelthatrump6 <- score.sentiment(feed_trump6, pos, neg, ter, won, pol, .progress='text') 
feelthaclinton6 <- score.sentiment(feed_clinton6, pos, neg, ter, won, pol, .progress='text')
# 11/7
feelthatrump7 <- score.sentiment(feed_trump7, pos, neg, ter, won, pol, .progress='text') 
feelthaclinton7 <- score.sentiment(feed_clinton7, pos, neg, ter, won, pol, .progress='text')
# 11/8
feelthatrump8 <- score.sentiment(feed_trump8, pos, neg, ter, won, pol, .progress='text') 
feelthaclinton8 <- score.sentiment(feed_clinton8, pos, neg, ter, won, pol, .progress='text')
# 11/9
feelthatrump9 <- score.sentiment(feed_trump9, pos, neg, ter, won, pol, .progress='text') 
feelthaclinton9 <- score.sentiment(feed_clinton9, pos, neg, ter, won, pol, .progress='text')
# 11/10
feelthatrump10 <- score.sentiment(feed_trump10, pos, neg, ter, won, pol, .progress='text') 
feelthaclinton10 <- score.sentiment(feed_clinton10, pos, neg, ter, won, pol, .progress='text')
# 11/11
feelthatrump11 <- score.sentiment(feed_trump11, pos, neg, ter, won, pol, .progress='text') 
feelthaclinton11 <- score.sentiment(feed_clinton11, pos, neg, ter, won, pol, .progress='text')

# Nice little quick plot 
# 11/5
qplot(factor(score), data=feelthatrump5, geom="bar", xlab = "Sentiment Score for Trump -- 11/5") 
qplot(factor(score), data=feelthaclinton5, geom="bar", xlab = "Sentiment Score for Clinton -- 11/5")
# 11/6
qplot(factor(score), data=feelthatrump6, geom="bar", xlab = "Sentiment Score for Trump -- 11/6") 
qplot(factor(score), data=feelthaclinton6, geom="bar", xlab = "Sentiment Score for Clinton -- 11/6")
# 11/7
qplot(factor(score), data=feelthatrump7, geom="bar", xlab = "Sentiment Score for Trump -- 11/7") 
qplot(factor(score), data=feelthaclinton7, geom="bar", xlab = "Sentiment Score for Clinton -- 11/7")
# 11/8
qplot(factor(score), data=feelthatrump8, geom="bar", xlab = "Sentiment Score for Trump -- 11/8") 
qplot(factor(score), data=feelthaclinton8, geom="bar", xlab = "Sentiment Score for Clinton -- 11/8")
# 11/9
qplot(factor(score), data=feelthatrump9, geom="bar", xlab = "Sentiment Score for Trump -- 11/9") 
qplot(factor(score), data=feelthaclinton9, geom="bar", xlab = "Sentiment Score for Clinton -- 11/9")
# 11/10
qplot(factor(score), data=feelthatrump10, geom="bar", xlab = "Sentiment Score for Trump -- 11/10") 
qplot(factor(score), data=feelthaclinton10, geom="bar", xlab = "Sentiment Score for Clinton -- 11/10")
# 11/11
qplot(factor(score), data=feelthatrump11, geom="bar", xlab = "Sentiment Score for Trump -- 11/11") 
qplot(factor(score), data=feelthaclinton11, geom="bar", xlab = "Sentiment Score for Clinton -- 11/11")


# how many tweets of each 
# 11/5
nd5 = c(length(feed_trump5), length(feed_clinton5))
# 11/6
nd6 = c(length(feed_trump6), length(feed_clinton6))
# 11/7
nd7 = c(length(feed_trump7), length(feed_clinton7))
# 11/8
nd8 = c(length(feed_trump8), length(feed_clinton8))
# 11/9
nd9 = c(length(feed_trump9), length(feed_clinton9))
# 11/10
nd10 = c(length(feed_trump10), length(feed_clinton10))
# 11/11
nd11 = c(length(feed_trump11), length(feed_clinton11))

# join texts
# 11/5
candidates5 = c(feed_trump5, feed_clinton5) 
# 11/6
candidates6 = c(feed_trump6, feed_clinton6) 
# 11/7
candidates7 = c(feed_trump7, feed_clinton7) 
# 11/8
candidates8 = c(feed_trump8, feed_clinton8) 
# 11/9
candidates9 = c(feed_trump9, feed_clinton9) 
# 11/10
candidates10 = c(feed_trump10, feed_clinton10) 
# 11/11
candidates11 = c(feed_trump11, feed_clinton11) 


# apply function score.sentiment
# 11/5
scores5 = score.sentiment(candidates5, pos, neg, ter, won, pol, .progress='text')
# 11/6
scores6 = score.sentiment(candidates6, pos, neg, ter, won, pol, .progress='text')
# 11/7
scores7 = score.sentiment(candidates7, pos, neg, ter, won, pol, .progress='text')
# 11/8
scores8 = score.sentiment(candidates8, pos, neg, ter, won, pol, .progress='text')
# 11/9
scores9 = score.sentiment(candidates9, pos, neg, ter, won, pol, .progress='text')
# 11/10
scores10 = score.sentiment(candidates10, pos, neg, ter, won, pol, .progress='text')
# 11/11
scores11 = score.sentiment(candidates11, pos, neg, ter, won, pol, .progress='text')


# add variables to data frame
# 11/5
scores5$candidates5 = factor(rep(c("@realDonaldTrump", "@HillaryClinton"), nd5))
scores5$very.pos5 = as.numeric(scores5$score >= 2)
scores5$very.neg5 = as.numeric(scores5$score <= -2)
scores5$very.mid5 = as.numeric(scores5$score <= 1 & scores5$score >= -1)

feelthatrump5$very.pos5 = as.numeric(feelthatrump5$score >= 2)
feelthatrump5$very.neg5 = as.numeric(feelthatrump5$score <= -2)
feelthatrump5$very.mid5 = as.numeric(feelthatrump5$score <= 1 & feelthatrump5$score >= -1)

feelthaclinton5$very.pos5 = as.numeric(feelthaclinton5$score >= 2)
feelthaclinton5$very.neg5 = as.numeric(feelthaclinton5$score <= -2)
feelthaclinton5$very.mid5 = as.numeric(feelthaclinton5$score <= 1 & feelthaclinton5$score >= -1)

# 11/6
scores6$candidates6 = factor(rep(c("@realDonaldTrump", "@HillaryClinton"), nd6))
scores6$very.pos6 = as.numeric(scores6$score >= 2)
scores6$very.neg6 = as.numeric(scores6$score <= -2)
scores6$very.mid6 = as.numeric(scores6$score <= 1 & scores6$score >= -1)

feelthatrump6$very.pos6 = as.numeric(feelthatrump6$score >= 2)
feelthatrump6$very.neg6 = as.numeric(feelthatrump6$score <= -2)
feelthatrump6$very.mid6 = as.numeric(feelthatrump6$score <= 1 & feelthatrump6$score >= -1)

feelthaclinton6$very.pos6 = as.numeric(feelthaclinton6$score >= 2)
feelthaclinton6$very.neg6 = as.numeric(feelthaclinton6$score <= -2)
feelthaclinton6$very.mid6 = as.numeric(feelthaclinton6$score <= 1 & feelthaclinton6$score >= -1)

# 11/7
scores7$candidates7 = factor(rep(c("@realDonaldTrump", "@HillaryClinton"), nd7))
scores7$very.pos7 = as.numeric(scores7$score >= 2)
scores7$very.neg7 = as.numeric(scores7$score <= -2)
scores7$very.mid7 = as.numeric(scores7$score <= 1 & scores7$score >= -1)

feelthatrump7$very.pos7 = as.numeric(feelthatrump7$score >= 2)
feelthatrump7$very.neg7 = as.numeric(feelthatrump7$score <= -2)
feelthatrump7$very.mid7 = as.numeric(feelthatrump7$score <= 1 & feelthatrump7$score >= -1)

feelthaclinton7$very.pos7 = as.numeric(feelthaclinton7$score >= 2)
feelthaclinton7$very.neg7 = as.numeric(feelthaclinton7$score <= -2)
feelthaclinton7$very.mid7 = as.numeric(feelthaclinton7$score <= 1 & feelthaclinton7$score >= -1)

# 11/8
scores8$candidates8 = factor(rep(c("@realDonaldTrump", "@HillaryClinton"), nd8))
scores8$very.pos8 = as.numeric(scores8$score >= 2)
scores8$very.neg8 = as.numeric(scores8$score <= -2)
scores8$very.mid8 = as.numeric(scores8$score <= 1 & scores8$score >= -1)

feelthatrump8$very.pos8 = as.numeric(feelthatrump8$score >= 2)
feelthatrump8$very.neg8 = as.numeric(feelthatrump8$score <= -2)
feelthatrump8$very.mid8 = as.numeric(feelthatrump8$score <= 1 & feelthatrump8$score >= -1)

feelthaclinton8$very.pos8 = as.numeric(feelthaclinton8$score >= 2)
feelthaclinton8$very.neg8 = as.numeric(feelthaclinton8$score <= -2)
feelthaclinton8$very.mid8 = as.numeric(feelthaclinton8$score <= 1 & feelthaclinton8$score >= -1)

# 11/9
scores9$candidates9 = factor(rep(c("@realDonaldTrump", "@HillaryClinton"), nd9))
scores9$very.pos9 = as.numeric(scores9$score >= 2)
scores9$very.neg9 = as.numeric(scores9$score <= -2)
scores9$very.mid9 = as.numeric(scores9$score <= 1 & scores9$score >= -1)

feelthatrump9$very.pos9 = as.numeric(feelthatrump9$score >= 2)
feelthatrump9$very.neg9 = as.numeric(feelthatrump9$score <= -2)
feelthatrump9$very.mid9 = as.numeric(feelthatrump9$score <= 1 & feelthatrump9$score >= -1)

feelthaclinton9$very.pos9 = as.numeric(feelthaclinton9$score >= 2)
feelthaclinton9$very.neg9 = as.numeric(feelthaclinton9$score <= -2)
feelthaclinton9$very.mid9 = as.numeric(feelthaclinton9$score <= 1 & feelthaclinton9$score >= -1)

# 11/10
scores10$candidates10 = factor(rep(c("@realDonaldTrump", "@HillaryClinton"), nd10))
scores10$very.pos10 = as.numeric(scores10$score >= 2)
scores10$very.neg10 = as.numeric(scores10$score <= -2)
scores10$very.mid10 = as.numeric(scores10$score <= 1 & scores10$score >= -1)

feelthatrump10$very.pos10 = as.numeric(feelthatrump10$score >= 2)
feelthatrump10$very.neg10 = as.numeric(feelthatrump10$score <= -2)
feelthatrump10$very.mid10 = as.numeric(feelthatrump10$score <= 1 & feelthatrump10$score >= -1)

feelthaclinton10$very.pos10 = as.numeric(feelthaclinton10$score >= 2)
feelthaclinton10$very.neg10 = as.numeric(feelthaclinton10$score <= -2)
feelthaclinton10$very.mid10 = as.numeric(feelthaclinton10$score <= 1 & feelthaclinton10$score >= -1)

# 11/11
scores11$candidates11 = factor(rep(c("@realDonaldTrump", "@HillaryClinton"), nd11))
scores11$very.pos11 = as.numeric(scores11$score >= 2)
scores11$very.neg11 = as.numeric(scores11$score <= -2)
scores11$very.mid11 = as.numeric(scores11$score <= 1 & scores11$score >= -1)

feelthatrump11$very.pos11 = as.numeric(feelthatrump11$score >= 2)
feelthatrump11$very.neg11 = as.numeric(feelthatrump11$score <= -2)
feelthatrump11$very.mid11 = as.numeric(feelthatrump11$score <= 1 & feelthatrump11$score >= -1)

feelthaclinton11$very.pos11 = as.numeric(feelthaclinton11$score >= 2)
feelthaclinton11$very.neg11 = as.numeric(feelthaclinton11$score <= -2)
feelthaclinton11$very.mid11 = as.numeric(feelthaclinton11$score <= 1 & feelthaclinton11$score >= -1)


# sum the total scores
# 11/5
resTrumpe5 <- c(sum(feelthatrump5$score))
resClinton5 <- c(sum(feelthaclinton5$score))
print(resTrumpe5)
print(resClinton5)
# 11/6
resTrumpe6 <- c(sum(feelthatrump6$score))
resClinton6 <- c(sum(feelthaclinton6$score))
print(resTrumpe6)
print(resClinton6)
# 11/7
resTrumpe7 <- c(sum(feelthatrump7$score))
resClinton7 <- c(sum(feelthaclinton7$score))
print(resTrumpe7)
print(resClinton7)
# 11/8
resTrumpe8 <- c(sum(feelthatrump8$score))
resClinton8 <- c(sum(feelthaclinton8$score))
print(resTrumpe8)
print(resClinton8)
# 11/9
resTrumpe9 <- c(sum(feelthatrump9$score))
resClinton9 <- c(sum(feelthaclinton9$score))
print(resTrumpe9)
print(resClinton9)
# 11/10
resTrumpe10 <- c(sum(feelthatrump10$score))
resClinton10 <- c(sum(feelthaclinton10$score))
print(resTrumpe10)
print(resClinton10)
# 11/11
resTrumpe11 <- c(sum(feelthatrump11$score))
resClinton11 <- c(sum(feelthaclinton11$score))
print(resTrumpe11)
print(resClinton11)

# how many very positives, very negatives and middle point
#Total Scores
# 11/5
numpos5 = sum(scores5$very.pos5)
numneg5 = sum(scores5$very.neg5)
nummid5 = sum(scores5$very.mid5)
print(numpos5)
print(numneg5)
print(nummid5)
# 11/6
numpos6 = sum(scores6$very.pos6)
numneg6 = sum(scores6$very.neg6)
nummid6 = sum(scores6$very.mid6)
print(numpos6)
print(numneg6)
print(nummid6)
# 11/7
numpos7 = sum(scores7$very.pos7)
numneg7 = sum(scores7$very.neg7)
nummid7 = sum(scores7$very.mid7)
print(numpos7)
print(numneg7)
print(nummid7)
# 11/8
numpos8 = sum(scores8$very.pos8)
numneg8 = sum(scores8$very.neg8)
nummid8 = sum(scores8$very.mid8)
print(numpos8)
print(numneg8)
print(nummid8)
# 11/9
numpos9 = sum(scores9$very.pos9)
numneg9 = sum(scores9$very.neg9)
nummid9 = sum(scores9$very.mid9)
print(numpos9)
print(numneg9)
print(nummid9)
# 11/10
numpos10 = sum(scores10$very.pos10)
numneg10 = sum(scores10$very.neg10)
nummid10 = sum(scores10$very.mid10)
print(numpos10)
print(numneg10)
print(nummid10)
# 11/11
numpos11 = sum(scores11$very.pos11)
numneg11 = sum(scores11$very.neg11)
nummid11 = sum(scores11$very.mid11)
print(numpos11)
print(numneg11)
print(nummid11)

#Trump Scores
# 11/5
numtrumppos5 = sum(feelthatrump5$very.pos5)
numtrumpneg5 = sum(feelthatrump5$very.neg5)
numtrumpmid5 = sum(feelthatrump5$very.mid5)
print(numtrumppos5)
print(numtrumpneg5)
print(numtrumpmid5)
# 11/6
numtrumppos6 = sum(feelthatrump6$very.pos6)
numtrumpneg6 = sum(feelthatrump6$very.neg6)
numtrumpmid6 = sum(feelthatrump6$very.mid6)
print(numtrumppos6)
print(numtrumpneg6)
print(numtrumpmid6)
# 11/7
numtrumppos7 = sum(feelthatrump7$very.pos7)
numtrumpneg7 = sum(feelthatrump7$very.neg7)
numtrumpmid7 = sum(feelthatrump7$very.mid7)
print(numtrumppos7)
print(numtrumpneg7)
print(numtrumpmid7)
# 11/8
numtrumppos8 = sum(feelthatrump8$very.pos8)
numtrumpneg8 = sum(feelthatrump8$very.neg8)
numtrumpmid8 = sum(feelthatrump8$very.mid8)
print(numtrumppos8)
print(numtrumpneg8)
print(numtrumpmid8)
# 11/9
numtrumppos9 = sum(feelthatrump9$very.pos9)
numtrumpneg9 = sum(feelthatrump9$very.neg9)
numtrumpmid9 = sum(feelthatrump9$very.mid9)
print(numtrumppos9)
print(numtrumpneg9)
print(numtrumpmid9)
# 11/10
numtrumppos10 = sum(feelthatrump10$very.pos10)
numtrumpneg10 = sum(feelthatrump10$very.neg10)
numtrumpmid10 = sum(feelthatrump10$very.mid10)
print(numtrumppos10)
print(numtrumpneg10)
print(numtrumpmid10)
# 11/11
numtrumppos11 = sum(feelthatrump11$very.pos11)
numtrumpneg11 = sum(feelthatrump11$very.neg11)
numtrumpmid11 = sum(feelthatrump11$very.mid11)
print(numtrumppos11)
print(numtrumpneg11)
print(numtrumpmid11)

#Cliton Scores
# 11/5
numclitonpos5 = sum(feelthaclinton5$very.pos5)
numclitonneg5 = sum(feelthaclinton5$very.neg5)
numclitonmid5 = sum(feelthaclinton5$very.mid5)
print(numclitonpos5)
print(numclitonneg5)
print(numclitonmid5)
# 11/6
numclitonpos6 = sum(feelthaclinton6$very.pos6)
numclitonneg6 = sum(feelthaclinton6$very.neg6)
numclitonmid6 = sum(feelthaclinton6$very.mid6)
print(numclitonpos6)
print(numclitonneg6)
print(numclitonmid6)
# 11/7
numclitonpos7 = sum(feelthaclinton7$very.pos7)
numclitonneg7 = sum(feelthaclinton7$very.neg7)
numclitonmid7 = sum(feelthaclinton7$very.mid7)
print(numclitonpos7)
print(numclitonneg7)
print(numclitonmid7)
# 11/8
numclitonpos8 = sum(feelthaclinton8$very.pos8)
numclitonneg8 = sum(feelthaclinton8$very.neg8)
numclitonmid8 = sum(feelthaclinton8$very.mid8)
print(numclitonpos8)
print(numclitonneg8)
print(numclitonmid8)
# 11/9
numclitonpos9 = sum(feelthaclinton9$very.pos9)
numclitonneg9 = sum(feelthaclinton9$very.neg9)
numclitonmid9 = sum(feelthaclinton9$very.mid9)
print(numclitonpos9)
print(numclitonneg9)
print(numclitonmid9)
# 11/10
numclitonpos10 = sum(feelthaclinton10$very.pos10)
numclitonneg10 = sum(feelthaclinton10$very.neg10)
numclitonmid10 = sum(feelthaclinton10$very.mid10)
print(numclitonpos10)
print(numclitonneg10)
print(numclitonmid10)
# 11/11
numclitonpos11 = sum(feelthaclinton11$very.pos11)
numclitonneg11 = sum(feelthaclinton11$very.neg11)
numclitonmid11 = sum(feelthaclinton11$very.mid11)
print(numclitonpos11)
print(numclitonneg11)
print(numclitonmid11)


# global score
# 11/5
global_score5 = round( 100 * numpos5 / (numpos5 + numneg5 + nummid5) )
# 11/6
global_score6 = round( 100 * numpos6 / (numpos6 + numneg6 + nummid6) )
# 11/7
global_score7 = round( 100 * numpos7 / (numpos7 + numneg7 + nummid7) )
# 11/8
global_score8 = round( 100 * numpos8 / (numpos8 + numneg8 + nummid8) )
# 11/9
global_score9 = round( 100 * numpos9 / (numpos9 + numneg9 + nummid9) )
# 11/10
global_score10 = round( 100 * numpos10 / (numpos10 + numneg10 + nummid10) )
# 11/11
global_score11 = round( 110 * numpos11 / (numpos11 + numneg11 + nummid11) )


# colors
cols = c("red", "blue")
names(cols) = c("@realDonaldTrump", "@HillaryClinton")

# boxplot
# 11/5
ggplot(scores5, aes(x=candidates5, y=score, group=candidates5)) +
  geom_boxplot(aes(fill=candidates5)) +
  scale_fill_manual(values=cols) +
  geom_jitter(colour="gray40",
              position=position_jitter(width=0.2), alpha=0.3) +
  labs(title = "Boxplot - Presidential Candidates' Sentiment Scores 11/5")
# 11/6
ggplot(scores6, aes(x=candidates6, y=score, group=candidates6)) +
  geom_boxplot(aes(fill=candidates6)) +
  scale_fill_manual(values=cols) +
  geom_jitter(colour="gray40",
              position=position_jitter(width=0.2), alpha=0.3) +
  labs(title = "Boxplot - Presidential Candidates' Sentiment Scores 11/6")
# 11/7
ggplot(scores7, aes(x=candidates7, y=score, group=candidates7)) +
  geom_boxplot(aes(fill=candidates7)) +
  scale_fill_manual(values=cols) +
  geom_jitter(colour="gray40",
              position=position_jitter(width=0.2), alpha=0.3) +
  labs(title = "Boxplot - Presidential Candidates' Sentiment Scores 11/7")
# 11/8
ggplot(scores8, aes(x=candidates8, y=score, group=candidates8)) +
  geom_boxplot(aes(fill=candidates8)) +
  scale_fill_manual(values=cols) +
  geom_jitter(colour="gray40",
              position=position_jitter(width=0.2), alpha=0.3) +
  labs(title = "Boxplot - Presidential Candidates' Sentiment Scores 11/8")
# 11/9
ggplot(scores9, aes(x=candidates9, y=score, group=candidates9)) +
  geom_boxplot(aes(fill=candidates9)) +
  scale_fill_manual(values=cols) +
  geom_jitter(colour="gray40",
              position=position_jitter(width=0.2), alpha=0.3) +
  labs(title = "Boxplot - Presidential Candidates' Sentiment Scores 11/9")
# 11/10
ggplot(scores10, aes(x=candidates10, y=score, group=candidates10)) +
  geom_boxplot(aes(fill=candidates10)) +
  scale_fill_manual(values=cols) +
  geom_jitter(colour="gray40",
              position=position_jitter(width=0.2), alpha=0.3) +
  labs(title = "Boxplot - Presidential Candidates' Sentiment Scores 11/10")
# 11/11
ggplot(scores11, aes(x=candidates11, y=score, group=candidates11)) +
  geom_boxplot(aes(fill=candidates11)) +
  scale_fill_manual(values=cols) +
  geom_jitter(colour="gray40",
              position=position_jitter(width=0.2), alpha=0.3) +
  labs(title = "Boxplot - Presidential Candidates' Sentiment Scores 11/11")


# barplot of average score
# 11/5
meanscore = tapply(scores5$score, scores5$candidates5, mean)
df = data.frame(candidates5=names(meanscore), meanscore=meanscore)
df$drinks <- reorder(df$candidates5, df$meanscore)
ggplot(df, aes(y=meanscore)) +
  geom_bar(data=df, stat="identity", aes(x=candidates5, fill=candidates5)) +
  scale_fill_manual(values=cols[order(df$meanscore)]) +
  labs(title = "Average Sentiment Score",
       legend.position = "none")
# 11/6
meanscore = tapply(scores6$score, scores6$candidates6, mean)
df = data.frame(candidates6=names(meanscore), meanscore=meanscore)
df$drinks <- reorder(df$candidates6, df$meanscore)
ggplot(df, aes(y=meanscore)) +
  geom_bar(data=df, stat="identity", aes(x=candidates6, fill=candidates6)) +
  scale_fill_manual(values=cols[order(df$meanscore)]) +
  labs(title = "Average Sentiment Score",
       legend.position = "none")
# 11/7
meanscore = tapply(scores7$score, scores7$candidates7, mean)
df = data.frame(candidates7=names(meanscore), meanscore=meanscore)
df$drinks <- reorder(df$candidates7, df$meanscore)
ggplot(df, aes(y=meanscore)) +
  geom_bar(data=df, stat="identity", aes(x=candidates7, fill=candidates7)) +
  scale_fill_manual(values=cols[order(df$meanscore)]) +
  labs(title = "Average Sentiment Score",
       legend.position = "none")
# 11/8
meanscore = tapply(scores8$score, scores8$candidates8, mean)
df = data.frame(candidates8=names(meanscore), meanscore=meanscore)
df$drinks <- reorder(df$candidates8, df$meanscore)
ggplot(df, aes(y=meanscore)) +
  geom_bar(data=df, stat="identity", aes(x=candidates8, fill=candidates8)) +
  scale_fill_manual(values=cols[order(df$meanscore)]) +
  labs(title = "Average Sentiment Score",
       legend.position = "none")
# 11/9
meanscore = tapply(scores9$score, scores9$candidates9, mean)
df = data.frame(candidates9=names(meanscore), meanscore=meanscore)
df$drinks <- reorder(df$candidates9, df$meanscore)
ggplot(df, aes(y=meanscore)) +
  geom_bar(data=df, stat="identity", aes(x=candidates9, fill=candidates9)) +
  scale_fill_manual(values=cols[order(df$meanscore)]) +
  labs(title = "Average Sentiment Score",
       legend.position = "none")
# 11/10
meanscore = tapply(scores10$score, scores10$candidates10, mean)
df = data.frame(candidates10=names(meanscore), meanscore=meanscore)
df$drinks <- reorder(df$candidates10, df$meanscore)
ggplot(df, aes(y=meanscore)) +
  geom_bar(data=df, stat="identity", aes(x=candidates10, fill=candidates10)) +
  scale_fill_manual(values=cols[order(df$meanscore)]) +
  labs(title = "Average Sentiment Score",
       legend.position = "none")
# 11/11
meanscore = tapply(scores11$score, scores11$candidates11, mean)
df = data.frame(candidates11=names(meanscore), meanscore=meanscore)
df$drinks <- reorder(df$candidates11, df$meanscore)
ggplot(df, aes(y=meanscore)) +
  geom_bar(data=df, stat="identity", aes(x=candidates11, fill=candidates11)) +
  scale_fill_manual(values=cols[order(df$meanscore)]) +
  labs(title = "Average Sentiment Score",
       legend.position = "none")


# barplot of average very positive
# 11/5
candidates5_pos = ddply(scores5, .(candidates5), summarise, mean_pos5=mean(very.pos5))
candidates5_pos$candidates5 <- reorder(candidates5_pos$candidates5, candidates5_pos$mean_pos5)
ggplot(candidates5_pos, aes(y=mean_pos5)) +
  geom_bar(data=candidates5_pos, stat="identity", aes(x=candidates5, fill=candidates5)) +
  scale_fill_manual(values=cols[order(candidates5_pos$mean_pos5)]) +
  labs(title = "Average Very Positive Sentiment Score",
       legend.position = "none")
# 11/6
candidates6_pos = ddply(scores6, .(candidates6), summarise, mean_pos6=mean(very.pos6))
candidates6_pos$candidates6 <- reorder(candidates6_pos$candidates6, candidates6_pos$mean_pos6)
ggplot(candidates6_pos, aes(y=mean_pos6)) +
  geom_bar(data=candidates6_pos, stat="identity", aes(x=candidates6, fill=candidates6)) +
  scale_fill_manual(values=cols[order(candidates6_pos$mean_pos6)]) +
  labs(title = "Average Very Positive Sentiment Score",
       legend.position = "none")
# 11/7
candidates7_pos = ddply(scores7, .(candidates7), summarise, mean_pos7=mean(very.pos7))
candidates7_pos$candidates7 <- reorder(candidates7_pos$candidates7, candidates7_pos$mean_pos7)
ggplot(candidates7_pos, aes(y=mean_pos7)) +
  geom_bar(data=candidates7_pos, stat="identity", aes(x=candidates7, fill=candidates7)) +
  scale_fill_manual(values=cols[order(candidates7_pos$mean_pos7)]) +
  labs(title = "Average Very Positive Sentiment Score",
       legend.position = "none")
# 11/8
candidates8_pos = ddply(scores8, .(candidates8), summarise, mean_pos8=mean(very.pos8))
candidates8_pos$candidates8 <- reorder(candidates8_pos$candidates8, candidates8_pos$mean_pos8)
ggplot(candidates8_pos, aes(y=mean_pos8)) +
  geom_bar(data=candidates8_pos, stat="identity", aes(x=candidates8, fill=candidates8)) +
  scale_fill_manual(values=cols[order(candidates8_pos$mean_pos8)]) +
  labs(title = "Average Very Positive Sentiment Score",
       legend.position = "none")
# 11/9
candidates9_pos = ddply(scores9, .(candidates9), summarise, mean_pos9=mean(very.pos9))
candidates9_pos$candidates9 <- reorder(candidates9_pos$candidates9, candidates9_pos$mean_pos9)
ggplot(candidates9_pos, aes(y=mean_pos9)) +
  geom_bar(data=candidates9_pos, stat="identity", aes(x=candidates9, fill=candidates9)) +
  scale_fill_manual(values=cols[order(candidates9_pos$mean_pos9)]) +
  labs(title = "Average Very Positive Sentiment Score",
       legend.position = "none")
# 11/10
candidates10_pos = ddply(scores10, .(candidates10), summarise, mean_pos10=mean(very.pos10))
candidates10_pos$candidates10 <- reorder(candidates10_pos$candidates10, candidates10_pos$mean_pos10)
ggplot(candidates10_pos, aes(y=mean_pos10)) +
  geom_bar(data=candidates10_pos, stat="identity", aes(x=candidates10, fill=candidates10)) +
  scale_fill_manual(values=cols[order(candidates10_pos$mean_pos10)]) +
  labs(title = "Average Very Positive Sentiment Score",
       legend.position = "none")
# 11/11
candidates11_pos = ddply(scores11, .(candidates11), summarise, mean_pos11=mean(very.pos11))
candidates11_pos$candidates11 <- reorder(candidates11_pos$candidates11, candidates11_pos$mean_pos11)
ggplot(candidates11_pos, aes(y=mean_pos11)) +
  geom_bar(data=candidates11_pos, stat="identity", aes(x=candidates11, fill=candidates11)) +
  scale_fill_manual(values=cols[order(candidates11_pos$mean_pos11)]) +
  labs(title = "Average Very Positive Sentiment Score",
       legend.position = "none")


# barplot of average very negative
# 11/5
candidates5_neg = ddply(scores5, .(candidates5), summarise, mean_neg5=mean(very.neg5))
candidates5_neg$candidates5 <- reorder(candidates5_neg$candidates5, candidates5_neg$mean_neg5)
ggplot(candidates5_neg, aes(y=mean_neg5)) +
  geom_bar(data=candidates5_neg, stat="identity", aes(x=candidates5, fill=candidates5)) +
  scale_fill_manual(values=cols[order(candidates5_neg$mean_neg5)]) +
  labs(title = "Average Very Negative Sentiment Score",
       legend.position = "none")
# 11/6
candidates6_neg = ddply(scores6, .(candidates6), summarise, mean_neg6=mean(very.neg6))
candidates6_neg$candidates6 <- reorder(candidates6_neg$candidates6, candidates6_neg$mean_neg6)
ggplot(candidates6_neg, aes(y=mean_neg6)) +
  geom_bar(data=candidates6_neg, stat="identity", aes(x=candidates6, fill=candidates6)) +
  scale_fill_manual(values=cols[order(candidates6_neg$mean_neg6)]) +
  labs(title = "Average Very Negative Sentiment Score",
       legend.position = "none")
# 11/7
candidates7_neg = ddply(scores7, .(candidates7), summarise, mean_neg7=mean(very.neg7))
candidates7_neg$candidates7 <- reorder(candidates7_neg$candidates7, candidates7_neg$mean_neg7)
ggplot(candidates7_neg, aes(y=mean_neg7)) +
  geom_bar(data=candidates7_neg, stat="identity", aes(x=candidates7, fill=candidates7)) +
  scale_fill_manual(values=cols[order(candidates7_neg$mean_neg7)]) +
  labs(title = "Average Very Negative Sentiment Score",
       legend.position = "none")
# 11/8
candidates8_neg = ddply(scores8, .(candidates8), summarise, mean_neg8=mean(very.neg8))
candidates8_neg$candidates8 <- reorder(candidates8_neg$candidates8, candidates8_neg$mean_neg8)
ggplot(candidates8_neg, aes(y=mean_neg8)) +
  geom_bar(data=candidates8_neg, stat="identity", aes(x=candidates8, fill=candidates8)) +
  scale_fill_manual(values=cols[order(candidates8_neg$mean_neg8)]) +
  labs(title = "Average Very Negative Sentiment Score",
       legend.position = "none")
# 11/9
candidates9_neg = ddply(scores9, .(candidates9), summarise, mean_neg9=mean(very.neg9))
candidates9_neg$candidates9 <- reorder(candidates9_neg$candidates9, candidates9_neg$mean_neg9)
ggplot(candidates9_neg, aes(y=mean_neg9)) +
  geom_bar(data=candidates9_neg, stat="identity", aes(x=candidates9, fill=candidates9)) +
  scale_fill_manual(values=cols[order(candidates9_neg$mean_neg9)]) +
  labs(title = "Average Very Negative Sentiment Score",
       legend.position = "none")
# barplot of average very negative
# 11/10
candidates10_neg = ddply(scores10, .(candidates10), summarise, mean_neg10=mean(very.neg10))
candidates10_neg$candidates10 <- reorder(candidates10_neg$candidates10, candidates10_neg$mean_neg10)
ggplot(candidates10_neg, aes(y=mean_neg10)) +
  geom_bar(data=candidates10_neg, stat="identity", aes(x=candidates10, fill=candidates10)) +
  scale_fill_manual(values=cols[order(candidates10_neg$mean_neg10)]) +
  labs(title = "Average Very Negative Sentiment Score",
       legend.position = "none")
# 11/11
candidates11_neg = ddply(scores11, .(candidates11), summarise, mean_neg11=mean(very.neg11))
candidates11_neg$candidates11 <- reorder(candidates11_neg$candidates11, candidates11_neg$mean_neg11)
ggplot(candidates11_neg, aes(y=mean_neg11)) +
  geom_bar(data=candidates11_neg, stat="identity", aes(x=candidates11, fill=candidates11)) +
  scale_fill_manual(values=cols[order(candidates11_neg$mean_neg11)]) +
  labs(title = "Average Very Negative Sentiment Score",
       legend.position = "none")


# barplot of average middle
# 11/5
candidates5_mid = ddply(scores5, .(candidates5), summarise, mean_mid5=mean(very.mid5))
candidates5_mid$candidates5 <- reorder(candidates5_mid$candidates5, candidates5_mid$mean_mid5)
ggplot(candidates5_mid, aes(y=mean_mid5)) +
  geom_bar(data=candidates5_mid, stat="identity", aes(x=candidates5, fill=candidates5)) +
  scale_fill_manual(values=cols[order(candidates5_mid$mean_mid5)]) +
  labs(title = "Average Middle Sentiment Score",
       legend.position = "none")
# 11/6
candidates6_mid = ddply(scores6, .(candidates6), summarise, mean_mid6=mean(very.mid6))
candidates6_mid$candidates6 <- reorder(candidates6_mid$candidates6, candidates6_mid$mean_mid6)
ggplot(candidates6_mid, aes(y=mean_mid6)) +
  geom_bar(data=candidates6_mid, stat="identity", aes(x=candidates6, fill=candidates6)) +
  scale_fill_manual(values=cols[order(candidates6_mid$mean_mid6)]) +
  labs(title = "Average Middle Sentiment Score",
       legend.position = "none")
# 11/7
candidates7_mid = ddply(scores7, .(candidates7), summarise, mean_mid7=mean(very.mid7))
candidates7_mid$candidates7 <- reorder(candidates7_mid$candidates7, candidates7_mid$mean_mid7)
ggplot(candidates7_mid, aes(y=mean_mid7)) +
  geom_bar(data=candidates7_mid, stat="identity", aes(x=candidates7, fill=candidates7)) +
  scale_fill_manual(values=cols[order(candidates7_mid$mean_mid7)]) +
  labs(title = "Average Middle Sentiment Score",
       legend.position = "none")
# 11/8
candidates8_mid = ddply(scores8, .(candidates8), summarise, mean_mid8=mean(very.mid8))
candidates8_mid$candidates8 <- reorder(candidates8_mid$candidates8, candidates8_mid$mean_mid8)
ggplot(candidates8_mid, aes(y=mean_mid8)) +
  geom_bar(data=candidates8_mid, stat="identity", aes(x=candidates8, fill=candidates8)) +
  scale_fill_manual(values=cols[order(candidates8_mid$mean_mid8)]) +
  labs(title = "Average Middle Sentiment Score",
       legend.position = "none")
# 11/9
candidates9_mid = ddply(scores9, .(candidates9), summarise, mean_mid9=mean(very.mid9))
candidates9_mid$candidates9 <- reorder(candidates9_mid$candidates9, candidates9_mid$mean_mid9)
ggplot(candidates9_mid, aes(y=mean_mid9)) +
  geom_bar(data=candidates9_mid, stat="identity", aes(x=candidates9, fill=candidates9)) +
  scale_fill_manual(values=cols[order(candidates9_mid$mean_mid9)]) +
  labs(title = "Average Middle Sentiment Score",
       legend.position = "none")
# 11/10
candidates10_mid = ddply(scores10, .(candidates10), summarise, mean_mid10=mean(very.mid10))
candidates10_mid$candidates10 <- reorder(candidates10_mid$candidates10, candidates10_mid$mean_mid10)
ggplot(candidates10_mid, aes(y=mean_mid10)) +
  geom_bar(data=candidates10_mid, stat="identity", aes(x=candidates10, fill=candidates10)) +
  scale_fill_manual(values=cols[order(candidates10_mid$mean_mid10)]) +
  labs(title = "Average Middle Sentiment Score",
       legend.position = "none")
# 11/11
candidates11_mid = ddply(scores11, .(candidates11), summarise, mean_mid11=mean(very.mid11))
candidates11_mid$candidates11 <- reorder(candidates11_mid$candidates11, candidates11_mid$mean_mid11)
ggplot(candidates11_mid, aes(y=mean_mid11)) +
  geom_bar(data=candidates11_mid, stat="identity", aes(x=candidates11, fill=candidates11)) +
  scale_fill_manual(values=cols[order(candidates11_mid$mean_mid11)]) +
  labs(title = "Average Middle Sentiment Score",
       legend.position = "none")

