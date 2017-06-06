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

tweets_trump <- searchTwitter('@realDonaldTrump', n=2000)
tweets_clinton <- searchTwitter('@HillaryClinton', n=2000)

feed_trump = laply(tweets_trump, function(t) t$getText()) 
feed_clinton= laply(tweets_clinton, function(t) t$getText())

write.csv(feed_trump, "donaldtrump.csv",row.names = F) 
write.csv(feed_clinton, "hilarlaryclinton.csv",row.names = F)

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
feelthatrump <- score.sentiment(feed_trump, pos, neg, ter, won, pol, .progress='text') 
feelthaclinton <- score.sentiment(feed_clinton, pos, neg, ter, won, pol, .progress='text')

# sum the total scores
resTrumpe <- c(sum(feelthatrump$score))
resClinton <- c(sum(feelthaclinton$score))
print(resTrumpe)
print(resClinton)

# Nice little quick plot 
qplot(factor(score), data=feelthatrump, geom="bar", xlab = "Sentiment Score for Trump") 
qplot(factor(score), data=feelthaclinton, geom="bar", xlab = "Sentiment Score for Clinton")


# how many tweets of each 
nd = c(length(feed_trump), length(feed_clinton))

# join texts
candidates = c(feed_trump, feed_clinton) 

# apply function score.sentiment
scores = score.sentiment(candidates, pos, neg, ter, won, pol, .progress='text')

# add variables to data frame
scores$candidates = factor(rep(c("@realDonaldTrump", "@HillaryClinton"), nd))
scores$very.pos = as.numeric(scores$score >= 2)
scores$very.neg = as.numeric(scores$score <= -2)

# how many very positives and very negatives
numpos = sum(scores$very.pos)
numneg = sum(scores$very.neg)

# global score
global_score = round( 100 * numpos / (numpos + numneg) )

# colors
cols = c("red", "blue")
names(cols) = c("@realDonaldTrump", "@HillaryClinton")

# boxplot
ggplot(scores, aes(x=candidates, y=score, group=candidates)) +
  geom_boxplot(aes(fill=candidates)) +
  scale_fill_manual(values=cols) +
  geom_jitter(colour="gray40",
              position=position_jitter(width=0.2), alpha=0.3) +
  labs(title = "Boxplot - Presidential Candidates' Sentiment Scores")
