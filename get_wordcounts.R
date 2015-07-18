#copyright 2015 Brian Schousek



count_words<-function(fname) {
  #Create a data frame which contains
  # line, word, character and byte count for a single file (with complete path)
  wc_out=system2('wc',c('-c','-m','-w','-l',fname),stdout=TRUE)
  
  wclist=unlist(strsplit(wc_out,' +'))
  wclist=suppressWarnings(as.numeric(wclist))
  filename=basename(fname)
  chunks=unlist(strsplit(filename,"\\."))
  wcdf=data.frame(filename=filename,
                  language=chunks[1],
                  doctype=chunks[2],
                  lines=wclist[2],
                  words=wclist[3],
                  characters=wclist[4],
                  bytes=wclist[5]
  )
  wcdf$density=wcdf$bytes/wcdf$characters
  return (wcdf)
}

get_wordcounts=function(fnames) {
     wcdf=data.frame()
    for (fname in fnames) {
      wcdf=rbind(wcdf,count_words(fname))
    }
    
  
  return(wcdf)
}  

# en_datadir='coursera/data/final/en_US/small'
# en_datadir='coursera/data/final/en_US'
# ru_datadir='coursera/data/final/ru_RU/small'
# fnames=c(dir(file.path(basedir,en_datadir),full.names=TRUE,"*.txt"),dir(file.path(basedir,ru_datadir),full.names=TRUE))

if(.Platform$OS.type=="windows") {
  load('wordcounts.rdata')
} else {
  basedir='~'
  datadir='coursera/data/final'
  fnames=dir(file.path(basedir,datadir),pattern="*.txt",full.names=TRUE,recursive=TRUE)
  #remove the small sample files generated as part of exploratory analysis for CPU usage
  fnames=fnames[!grepl('small',fnames)]
  #if wordcounts.rdata exists, load it. Otherwise, generate it
  # using the unix command wc for word count, create a dataframe and save it.
  if (file.exists('wordcounts.rdata')) {
    load('wordcounts.rdata')
  } else {
    
  wcdf_blogs=get_wordcounts(fnames[grepl('blog',fnames)])
  wcdf_english=get_wordcounts(fnames[grepl('en_US',fnames)])
  save(wcdf_blogs,wcdf_english,file='wordcounts.rdata')
  }
}


