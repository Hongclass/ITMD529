sent <- data.frame(words = c("just right size", "love this quality", 
                             "good quality", "very good quality", "i hate this notebook",
                             "great improvement", "notebook is not good"), user = c(1,2,3,4,5,6,7),
                   stringsAsFactors=F)

posWords <- c("great","improvement","love","great improvement","very good","good","right","very")
negWords <- c("hate","bad","not good","horrible")

wordsDF<- data.frame(words = posWords, value = 1,stringsAsFactors=F)
wordsDF<- rbind(wordsDF,data.frame(words = negWords, value = -1))
wordsDF$lengths<-unlist(lapply(wordsDF$words, nchar))
wordsDF<-wordsDF[ order(-wordsDF[,3]),]


scoreSentence <- function(sentence){
  score<-0
  for(x in 1:nrow(wordsDF)){
    count<-length(grep(wordsDF[x,1],sentence))
    if(count){
      score<-score + (count * wordsDF[x,2])
      sentence<-sub(wordsDF[x,1],'',sentence)
    }
  }
  score
}

SentimentScore<- unlist(lapply(sent$words, scoreSentence))
cbind(sent, SentimentScore)