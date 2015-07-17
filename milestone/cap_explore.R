#Much from http://onepager.togaware.com/TextMiningO.pdf
#interesting from https://trinkerrstuff.wordpress.com/2014/09/04/spell-checker-for-r-qdapcheck_spelling/
#note check encoding to get rid of â€ in output
library(tm)

if(.Platform$OS.type=="windows") {
  os='windows'
  basedir='c:'
} else {
  os='unix'
  basedir='~'
}
datadir='coursera/data'
en_dir='final/en_US'
ru_dir='final/ru_RU/small'

# english_dir='coursera/data/final/en_US'

fnames=c('smallblog.txt','smallnews.txt','smalltwitter.txt')

cname=file.path(basedir,datadir,en_dir)
dbname=file.path(basedir,datadir,'explore.db')
docs=PCorpus(DirSource(cname),
             dbControl=list(dbName=dbname, dbType='DB1'))
docs=tm_map(docs,content_transformedbnamewer))
docs=tm_map(docs,content_transformer(removeNumbers))
docs=tm_map(docs,content_transformer(removePunctuation))
docs=tm_map(docs,stripWhitespace)

c2name=file.path(basedir,english_dir)
# This took about 80 seconds to load on M4700 work computer
timer=system.time({docs2=Corpus(DirSource(c2name))})
print (timer)

#This took about 90 seconds to load on m4700 work computer
docs3=PCorpus(DirSource(c2name),
                    dbControl=list(dbName="explore.db", dbType="DB1"))

library(SnowballC)

docs=tm_map(docs,stemDocument)

dtm=DocumentTermMatrix(docs)
tdm=TermDocumentMatrix(docs)

freq=colSums(as.matrix(dtm))
ord=order(freq)
