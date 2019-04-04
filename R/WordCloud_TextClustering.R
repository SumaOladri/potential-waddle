# Last modified: 16/04/2017
###### -----------------------------------------------------------------------------------------------------
# Project Problem Statement:
# 		 	Text clustering on Wikipedia portal articles
#        A portal in Wikipedia is a collection of many related articles

# Here is How to get bulk,subject-wise Wikipedia articles??
#   Articles were gathered using facility available on Wiki page:
#     https://en.wikipedia.org/wiki/Special:Export
#      In 'Add' text box, write-> Machine Learning , & then click 'Add' button
#        AND then click 'Export' button to export all articles in one XML file.
#        Split XML file to multiple txt files (breaking on <title>),  with unix command:
#         $ csplit -f psychology -z WikipediaPsychology-20170328042729.xml /\<title\>/ {*}
#          Files less than 4KB were manually discarded being deficient in content
###### ----------------------------######---------------------------######-------------------------------------

## 1.0
# Clean up R environment and release memory 
#   Remove all previous objects (rm()) from computer memory
#    and free memory (gc())
rm(list=ls()) ; gc()

## 2.0 Call libraries 
# Call R's text-mining, modeling and graphics libraries
library(tm)	         #  For DocumentTermMatrix()
library(RTextTools)  #  For removeSparseTerms()
library(SnowballC)   #  snowball stemmer for english text stemming
library(readr)       #  For read_file(). Read complete file as one-string.
library(textclean)   #  For replace_html() to remove html tags
library(tools)       #  For file_path_sans_ext() to remove file extensions 
                     # file names. For example, 'abc.txt' becomes 'abc'


# 3.0
# 3.1 Law files
# 3.2 Set working directory for Wiki articles on law
# setwd("C:/Users/ashokharnal/OneDrive/Documents/sentiment_analysis/wikiclustering/law/")
setwd("/home/sola/Core_learning/datasets/wikiclassification/law")
# 3.3 Get list of all files in the folder in vector format
filelist<-list.files()

# 3.4 Read files from the folder, one by one, using read_file() in lapply()
#      The whole content of each file is read as one string and 
#        deposited in one element. Name of element, by default, is filename (with extension) 
# We, therefore, have as many elements in the list, 'lawfiles', as there are law-files in dir()
lawfiles<-lapply(filelist,read_file)
lawfiles[[1]]     # Show the contents of the first (file) element of the list

# 3.5 In (3.3) above, from each element-value of vector, filelist, remove file extension
#     Use function, file_path_sans_ext() from library(tools)
filenamesWithoutExtension<-file_path_sans_ext(filelist)

# 3.6 Rename column names in list, 'lawfiles', as per filenames (but without extension)
names(lawfiles) <- filenamesWithoutExtension

# 3.7 Convert list to dataframe and transpose
#       We will now have a one column dataframe
#        with each row having the content of one file and rowname is filename
lawfiles<-as.data.frame(lawfiles)
lawfiles<-as.data.frame(t(lawfiles))    # Function t() exchanges columns and rows
lawfiles$filename<-row.names(lawfiles)  # Add a column, 'filename'. Its values are rownames of dataframe
                                        #   So we now have filenames in IInd column of dataframe.
# 3.8
View(lawfiles)


# 4.0
#  Physics files
#     Repeat all opeartions as under 3.0 above
# Set working directory for wiki articles on physics
setwd("/home/sola/Core_learning/datasets/wikiclassification/physics/")
filelist<-list.files()
phyfiles<-lapply(filelist,read_file)
file_names<-file_path_sans_ext(filelist)
names(phyfiles) <- file_names
phyfiles<-as.data.frame(phyfiles)
phyfiles<-as.data.frame(t(phyfiles))
phyfiles$filename<-row.names(phyfiles)
#View(phyfiles)

# 5.0
# Psychology files
#     Repeat all opeartions as under 3.0 above
# Set working directory for wiki articles on physchology
setwd("/home/sola/Core_learning/datasets/wikiclassification/psychology/")
filelist<-list.files()
psyfiles<-lapply(filelist,read_file)
file_names<-file_path_sans_ext(filelist)
names(psyfiles) <- file_names
psyfiles<-as.data.frame(psyfiles)
psyfiles<-as.data.frame(t(psyfiles))
psyfiles$filename<-row.names(psyfiles)
#View(psyfiles)

# 6.0
#  Culture & Arts files
#     Repeat all opeartions as under 3.0 above
# Set working directory for wiki articles on culturearts
setwd("/home/sola/Core_learning/datasets/wikiclassification//culturearts/")
filelist<-list.files()
culfiles<-lapply(filelist,read_file)
file_names<-file_path_sans_ext(filelist)
names(culfiles) <- file_names
culfiles<-as.data.frame(culfiles)
culfiles<-as.data.frame(t(culfiles))
culfiles$filename<-row.names(culfiles)
#View(culfiles)

# 7.0
# Religion files
#     Repeat all opeartions as under 3.0 above
# Set working directory for wiki articles on religion
setwd("/home/sola/Core_learning/datasets/wikiclassification/religion/")
filelist<-list.files()
relfiles<-lapply(filelist,read_file)
file_names<-file_path_sans_ext(filelist)
names(relfiles) <- file_names
relfiles<-as.data.frame(relfiles)
relfiles<-as.data.frame(t(relfiles))
relfiles$filename<-row.names(relfiles)
#View(relfiles)

# 8.0
#  Machine Learning files
#     Repeat all opeartions as under 3.0 above
# Set working directory for wiki articles on Machine Learning
setwd("/home/sola/Core_learning/datasets/wikiclassification/machineLearning/")
filelist<-list.files()
mlfiles<-lapply(filelist,read_file)
file_names<-file_path_sans_ext(filelist)
names(mlfiles) <- file_names
mlfiles<-as.data.frame(mlfiles)
mlfiles<-as.data.frame(t(mlfiles))
mlfiles$filename<-row.names(mlfiles)
#View(mlfiles)

######## We have finished with reading files and have populated various dataframes ###########

# 9.0 Dataset dimensions
dim(lawfiles)
dim(phyfiles)
dim(psyfiles)
dim(relfiles)
dim(mlfiles)
dim(culfiles)

# 10.0 Now stack (rbind) all datasets, one upon another (except psychology) in dataframe df
df<-rbind(lawfiles,phyfiles,culfiles,relfiles,mlfiles)
dim(df)
View(df)


## 11.0 Cleanup dataframe
#  11.1 Cleanup html tags (example: <title>  </title> etc) from all articles (first column of df)
df[,1]<-sapply(df[,1], replace_html)   # replace_html() is a function

#  11.2 Remove all URL adresses like https://www.rulequest.com/see5-unix.html
# Regular expression to replace URLs in the articles.  
#      Uses gsub(). Complicated!! Copied from Stackoverflow using Google. 
df[,1]<-gsub(" ?(f|ht)tp(s?)://(.*)[.][a-z]+", "", df[,1])
View(df)


# 12
# Create a document-term-matrix object using function from tm package
# Ref: http://stackoverflow.com/questions/38199396/stemming-words-in-r-missing-value

# 12.1 First create VectorSource.
#      Text may come from many sources.
#       Sources abstract input locations, like a directory, a connection to database, 
#        or simply an R vector, in order to acquire content in a uniform way.
#       A vector source interprets each element of the vector x as a document.
#        Sources, therefore, abstract content and lay it in a structured way
#         Another Source is DirSource() which can read file(s) directly from folder
 vc<-VectorSource(df[,1])   
vc$content[1]     # See some document properties
vc$length

# 12.2 Create an object, Corpus of documents, from VectorSource
#       Corpora are collections of documents containing (natural language) text.
#        Document processing functions operate on corpus
cp<-Corpus(vc)

# 12.3 Finally get Doc Term Matrix from Corpus
dtm <- TermDocumentMatrix(cp, 
  control = list(               # 'control' parameter is in list form
    wordLengths = c(3, Inf),    #  Min and Max word lengths 
    stopwords=TRUE,             #  Remove stop words
    removeNumbers=TRUE,         #  Remove numbers
    stemming=TRUE,              #  Stem words
    removePunctuation = TRUE,   #  Remove punctuation symbols
    toLower = TRUE,             #  Change all words to lower case
    stripWhitespace = TRUE      #  Remove excess white space (tab etc)
  )
)

dtm                             # A Sparse matrix object

# 13.0 Remove from dtm those columns which are too sparse
dtm<-removeSparseTerms(dtm, 0.99)  # 99% sparse relative to others
m <- as.matrix(dtm)
v <- sort(rowSums(m),decreasing=TRUE)
d <- data.frame(word = names(v),freq=v)
head(d, 10)

# 13.1 Word Cloud
set.seed(1234)
wordcloud(words = d$word, freq = d$freq, min.freq = 1,
+           max.words=200, random.order=FALSE, rot.per=0.35, 
+           colors=brewer.pal(8, "Dark2"))

# 14.0  
#  Weight a term-document matrix according to a combination of weights
#    specified in SMART notation. The first letter specifies a term frequency schema,
#      the second a document frequency schema, and the third a normalization schema. 
#       See note at the end of this code
dtmModel <- weightSMART(dtm, spec = "ltc")   


# 14.1 Convert dtmModel to matrix format
term_mat = as.matrix(dtmModel)

# Following steps NOT NEEDED as the 'c' part in 14.0 above ('ltc') does it
# 15.0 Define a function to normalize (row-wise)
#l2_norm <- function(m) m/apply(m, MARGIN=1, FUN=function(x) sum(x^2)^.5)
# 15.1 Use norm_eucl function now
#term_mat <- l2_norm(term_mat)

# 15.2
dim(term_mat)
#View(term_mat)

# 15.3 Assign rownames of matrix as per filenames
row.names(term_mat) <- df[,2]

## 16.0
# Use kmeans clustering

# 16.1
# First convert matrix to dataframe
data<-data.frame(term_mat)

# 16.2 Build 5 clusters, one for each subject
km<-kmeans(data,5, nstart=10)

# 16.3 Compare results. Maybe some documents can get classified
#        under two categories (soft demarcation). There is some
#         overlap for ML and physics but in so far as culture,
#          law and religion are concerned demarcation appears to be hard
table(km$cluster,strtrim(df[,2],3))

############################################################################
### NOTE on SMART notation used in this example:
# 'l' => tf=(1+log2(tf)), 't'=> idf, 'c' => cosine norm
#   cosine normalization is same as, row-wise, making sqrt(sum(m^2)) as 1
#     But 'c' normalization is applied only to tf and not to tf-idf
#       To check this, try, as below:
dtmModel <- weightSMART(dtm, spec = "lnc")  # 'n' means idf = 1
term_mat <- as.matrix(dtmModel)
apply(term_mat, MARGIN=1, FUN=function(x) sqrt(sum(x^2)))  # Each row result is 1
############################################################################
