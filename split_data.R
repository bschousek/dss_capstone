srcpath='coursera/data/final'
destpath='coursera/data/split'

#If we haven't already created training and test split, do so now
if (!file.exists(file.path(basedir,destpath,'en_US.bulktrain.txt'))) {
  infile=c(readLines(file(file.path(basedir,srcpath,'en_US/en_US.blogs.txt')),encoding = 'UTF-8'),
           readLines(file(file.path(basedir,srcpath,'en_US/en_US.news.txt')),encoding = 'UTF-8'),
           readLines(file(file.path(basedir,srcpath,'en_US/en_US.news.txt')),encoding = 'UTF-8'))
  set.seed(42)
  training_index=as.logical(rbinom(length(infile),1,0.75))
  writeLines(infile[training_index],file(file.path(basedir,destpath,"en_US.bulktrain.txt")))
  test_index=!training_index
  writeLines(infile[test_index],file(file.path(basedir,destpath,"en_US.bulktest.txt")))
  
  #Now sample repeatably from the bulk sets
  # We will create a dataframe consisting of sequential index, and a list of random numbers
  # Then sort on the random numbers and choose the top n samples for subsequent training sets
  tlength=sum(training_index)
  set.seed=(43)
  trainvec=data.frame(index=seq(tlength),rnum=rnorm(tlength))
  trainvec=trainvec[order(trainvec$rnum),]
  trainvec=trainvec$index
  train1=infile[trainvec[1:50000]]
  writeLines(train1,file(file.path(basedir,destpath,"en_US.train1.txt")))
  
}
#Get summaries of all the files in the split directory
fnames=dir(file.path(basedir,destpath),pattern="en_US.*",full.names = T)
ttdf=get_wordcounts(fnames)

