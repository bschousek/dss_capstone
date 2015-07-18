#inspired by http://gibrown.com/2013/01/26/unix-bi-grams-tri-grams-and-topic-modeling/
#clean document
echo $1
echo $2
cd $1
cat $2 |
 #sed G | #add newline between paragraphs
  sed 's/\\. /\\n/' | #convert period plus space to newline
   sed 's/^/begintoken /' | #add token to beginning of line
   sed 's/$/ endtoken/' | #add token to end of line
   sed 's/[0-9]+/ numbertoken /' | #add token for numbers
   #tr -d 'begintoken  endtoken' | #now get rid of doubled up tokens
   tr '-' ' ' | #convert hyphens to spaces
    sed 's/[[:punct:]]//g' | #remove punctuation (unicode compliant)
     tr -d '[:digit:]' | #remove all numbers
      tr -s ' ' | #squeeze out multiple spaces
       sed -e 's/^[ \\t]*//' | #remove leading spaces and tabs
        tr '[:upper:]' '[:lower:]' > cleantext.txt # convert all words to lowercase

#remove profanity
#method inspired by stack overflow http://stackoverflow.com/questions/7332732/using-grep-to-filter-out-words-from-a-stopwords-file
sed 's|^|s/\\<|; s|$|\\>/kittens/g;|' google_twunter_lol.txt > words.sed
sed -i -f words.sed cleantext.txt

#create wordlist
cat cleantext.txt |
 tr ' ' '\n' | #split into newlines based on spaces
   sed '/^$/d' | #Remove blank lines for the word count
   sort | uniq -c | sort -rn > wordlist.txt


#create bigrams
cat cleantext.txt |
 tr '[:upper:]' '[:lower:]' |
  tr -d '[:punct:]' |
   sed 's/,//' | sed G |
    tr ' ' '\n' > tmp.txt
tail -n+2 tmp.txt > tmp2.txt
paste -d ',' tmp.txt tmp2.txt |
 grep -v -e "^," |
  grep -v -e ",$" |
   sort |
    uniq -c |
     sort -rn > bigrams.txt

#and trigrams
tail -n+2 tmp2.txt > tmp3.txt
paste -d ',' tmp.txt tmp2.txt tmp3.txt |
 grep -v -e "^," |
  grep -v -e ",$" |
   grep -v -e ",," |
    sort | uniq -c |
     sort -rn > trigrams.txt
#and finally 4grams
tail -n+2 tmp3.txt > tmp4.txt
paste -d ',' tmp.txt tmp2.txt tmp3.txt tmp4.txt|
 grep -v -e "^," |
  grep -v -e ",$" |
   grep -v -e ",,," |
    sort | uniq -c |
     sort -rn > fourgrams.txt

rm tmp.txt
rm tmp2.txt
rm tmp3.txt
rm tmp4.txt
