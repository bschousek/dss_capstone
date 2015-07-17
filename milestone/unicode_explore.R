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

offdir=file.path(basedir,datadir)
cname=file.path(basedir,datadir,en_dir)
fnames=dir(cname,pattern='*.txt',full.names=TRUE)

read_and_strip=function(filename) {
  flines=readLines(file(filename,'rb'),encoding='UTF-8',skipNul = T)
  prefilt=length(flines)
  flines=flines[Encoding(flines)!='UTF-8']
  output=NULL
  output$stripped=1-(length(flines)/prefilt)
  output$len.prefilt=prefilt
  output$len.postfilt=length(flines)
  output$text=flines
#   print(stripped)
#   print(prefilt)
  return(output)
}
system.time({
  blog=read_and_strip(fnames[1])
  news=read_and_strip(fnames[2])
  twitter=read_and_strip(fnames[3])
  
})
nn=100
smallnews=news$text[1:nn]
smallblog=blog$text[1:nn]
smalltwitter=blog$text[1:nn]
news_index=seq(length(news$text))


make_corpus=function(strings,tag) {
  corpus=VCorpus(VectorSource(strings))
  
  #corpus=tm_map(corpus,addMeta,rep(tag,length(strings)))
  meta(corpus,tag='doctype',type='indexed')=rep(tag,length(strings))
  return(corpus)
}
make_corpus=function(strings,tags,dbname) {
  corpus=PCorpus(VectorSource(strings),dbControl=list(dbName=dbname))
  
  #corpus=tm_map(corpus,addMeta,rep(tag,length(strings)))
  # meta(corpus,tag='doctype',type='indexed')=tags
  return(corpus)
}
smallc=make_corpus(c(smallnews,smallblog,smalltwitter),
            tags=c(rep('news',length(smallnews)),rep('blog',length(smallblog)),rep('twitter',length(smalltwitter))),
            dbname=file.path(offdir,'test2'))
dbname=file.path(offdir,'test2')
# system.time({
#   make_corpus(c(news$text,blog$text,twitter$text),
#             tags=c(rep('news',length(news$text)),rep('blog',length(blog$text)),rep('twitter',length(twitter$text))),
#             dbname=file.path(offdir,'bigtest'))
# })

nc=make_corpus(smallnews,'news')
bc=make_corpus(smallblog,'blog')
tc=make_corpus(smalltwitter,'twitter')
allc=PCorpus(nc,dbControl=(list(dbName='test')))
