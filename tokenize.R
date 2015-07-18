pathname='~/coursera/data/split'
filename='en_US.train1.txt'
wd=getwd()
setwd(pathname)
if (!file.exists('wordlist.txt')) {
  print('wow')
  system2(file.path(wd,'proctext.sh'),paste(pathname,filename,sep=" "))
}
  #fix proctest for spaces
wordlist=read.table('wordlist.txt',header=F,colClasses = c('integer','character'))
wordlist=wordlist[-which(wordlist$V2=='begintoken'),]
wordlist=wordlist[-which(wordlist$V2=='endtoken'),]
bigrams=read.table('bigrams.txt',header=F,colClasses = c('integer','character'))
trigrams=read.table('trigrams.txt',header=F,colClasses = c('integer','character'))
fourgrams=read.table('fourgrams.txt',header=F,colClasses = c('integer','character'))
setwd(wd)
