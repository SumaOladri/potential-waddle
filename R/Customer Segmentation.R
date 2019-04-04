####################################################################3
# Ta Feng Grocery dataset
# Data Source: http://stackoverflow.com/questions/25014904/download-link-for-ta-feng-grocery-dataset
#	Other grocery datasets:
#		https://sites.google.com/a/dlpage.phi-integration.com/pentaho/mondrian/mysql-foodmart-database/foodmart_mysql.tar.gz?attredirects=0
#		http://recsyswiki.com/wiki/Grocery_shopping_datasets
# References on clustering/customer segmentation or on kohonen SOM:
# 		1. https://cran.r-project.org/web/views/Cluster.html
#   	2. http://www.shanelynn.ie/self-organising-maps-for-customer-segmentation-using-r/
#		3. General on kohonen: https://dzone.com/articles/self-organizing-maps
#		4. http://www.slideshare.net/jonsedar/customer-clustering-for-marketing
#		5. Predicting customer behaviour with R: http://www.slideshare.net/mattbagg/baggott-predict-customerinrpart1?next_slideshow=1
#
####################################################################
# Objective: Understand customer behaviour 
# For  every customer (unique customerid)
#	  Record his first purchase date
#	  Record his last purchase date
#		Which customers purchase just one-time
#	  Who are repeat purchasers	
#	  Record every customers total purchases
#	  Record every customers average purchases
#	  Record his number of visits: Same as purchase frequency
#	  Record his basket of purchases: Variety of goods he purchases
#   Per visit/per transaction min. max items purchased and money spent
# For your store:
#	  What is the distribution of customers age-wise?
#	  What is the distribution of res-area-wise
#	  Age wise what is the average purchase basket
#   Is there age preference for a particular product sub-class
# For a product-subclass
#	  Which product-subclass brings most revenue
#   Which productids are most popular
#	Which productIds are most costly
#   And which customers purchase them?--Categorise: Yes/No
# Tests:
#   IS there a relationship between age and product_subclass
#   Is there significant difference in avg spending, age-wise
#   Is there significant difference in avg spending, residence wise

####################################################################


## 1.0
#----------------A.Call libraries, read file & data transform------------------
rm(list=ls()) ; gc()    # Delete objects and garbage clearance
#library(plyr)           # For ddply function
library(dplyr)          # For data manipulation
library(lubridate)			# For date manipulation
library(ggplot2)


## 2.0 
# Read file and observe data
# 2.1 Set the working directory where your data files are
## ****************************************************************
setwd("/home/sola/Core_learning/datasets")
getwd()
dir()
## ****************************************************************

# 2.2 Read file with headers
d12<-read.csv("dall.csv",header=T)		# Read file with headers

# 2.3 Observe data
head(d12, 2)
tail(d12, 2)
str(d12)						# Check data structure and column names
names(d12)          # Column names


## 2,4
# Transform IDs to categorical variables
d12$customerid = as.factor(d12$customerid)    
d12$product_subclass = as.factor(d12$product_subclass)
d12$productid = as.factor(d12$productid)
str(d12)
 
## 3.0
# Q1: How many unique customers, productids and product_subclasses
#   Sol: distinct(): Retain only unique rows from input table
# 3.1    
d12 %>% select (customerid) %>% distinct() %>% summarise(c_count=n()) 
# 3.2   How many products?
d12 %>% select (productid) %>% distinct() %>% count()
# 3.3   How many product categories
d12 %>% distinct (product_subclass) %>%  summarise(pclass_count=n())

## 4.0
# Date manipulation
# 4.1 Transform datetime to POSIXct date format
#  (date from '1970-01-01 00:00.00)
d12$datetime<-ymd(d12$datetime)

# 4.2 Add a new column 'dec_date'. 
#     Convert datetime to numeric for date compairson
#     Try decimal_date(mdy("01-02-2016"))
d12$dec_date<-decimal_date(d12$datetime)

# 4.3
head(d12, 2)

#----------------B.Customer Purchase Behaviour ------------------

## 5.0
# 5.1  Q2: Who are oldest customers? 
#      Sol: Find earliest purchase date of every customer, group by customerid
cid_early<-d12 %>% 
  group_by(customerid) %>% 
  summarise(mdate = min(dec_date)) %>%
  ungroup() %>%
  arrange(mdate)     # Default arrange() is ascending

cid_early$mdate<-date_decimal(cid_early$mdate)
head(cid_early)

# 5.2 Q3: Recency: Find the last purchase date of every customer
#      Group by customerid
cid_last<-d12 %>%
  group_by(customerid) %>%
  summarise(ldate = max(dec_date)) %>%
  ungroup() %>%
  arrange(ldate)

# 5.2.1
cid_last$ldate<-date_decimal(cid_last$ldate)
head(cid_last)
tail(cid_last)

## 6. Q4: Repeat customers: Find repeat customers 
##     Many ways to find repeat-customers
# 6.1  Step 1: Join two tables on customerid
cid<-inner_join(cid_last,cid_early)   

# 6.2 Step2: Which all customers have first and last dates different
not_onetime_cust=cid[cid$ldate != cid$mdate,]
head(not_onetime_cust)
nrow(cid)
nrow(not_onetime_cust)

# 6.3 Q5: What is frequency of purchase. 
#     Step 1: For each customer, count number of transactions per day
data_trans<-d12 %>% group_by(customerid,dec_date) %>%
  summarise(trans_numb=n()) %>%
  ungroup()

head(data_trans)

# 6.3.1 Step 2: In above data, count how many times customerid has repeated itself
#       That will be data of transactions on different dates
data_visit<-data_trans %>% group_by(customerid) %>%
  summarise(visit_freq=n()) %>% ungroup()

data_visit

# 6.3.2 Step3: And which one of the above have visit_freq > 1
data_visit %>% filter(visit_freq > 1) %>% arrange(desc(visit_freq))


## 7.0
# 7.1 Q6: What are total purchases per customer
data <- d12 %>% group_by(customerid) %>%
  summarise(tp=sum(quantity * salesprice)) %>%
  ungroup() %>% 
  arrange(desc(tp))

head(data)

# 7.2 Q7: What are total purchases per-customer, per visit
data <- d12 %>% group_by(customerid,dec_date) %>%
  summarise(tp=sum(quantity * salesprice)) %>% 
  ungroup() %>% 
  arrange(desc(tp))

head(data)

# 7.3 Q8: What are average purchases per customer
data <- d12 %>% group_by(customerid) %>%
  summarise(tp=mean(quantity * salesprice)) %>% 
  ungroup() %>%
  arrange(desc(tp))

head(data)

# 7.4 Q9: What are Avg purchases per-customer, date-wise
#     Step 1: Avg over transactions of same date per-customer
cust_data <- d12 %>% group_by(customerid,dec_date) %>%
  summarise(p_amt=mean(quantity * salesprice)) %>%
  ungroup()

nrow(cust_data)  

# 7.4.1 (contd. above)
# Step 2: Covert dec_date to date proper to get date-wise data
cust_data$date<-date_decimal(cust_data$dec_date)
head(cust_data)

# 7.4.2 (contd.)
# Step 3: Arrange above in descending order of purchase amt
cust_data<-cust_data %>% arrange(desc(p_amt))
head(cust_data)

# 7.4.3 Not needed
# Plot line graph for each customer. Exclude first row with very heavy amount 
# ggplot(cust_data[-1,],aes(x=date, y= p_amt, group=customerid )) + geom_line()

# 7.4.4
# Step 5: Average purchases per visit per customer
avg_cust_pur_pervisit <- cust_data %>%
  group_by(customerid) %>% 
  summarise(m=mean(p_amt)) %>%
  ungroup()

head(avg_cust_pur_pervisit)

# 7.4.5
# Step 6: Arrange purchase data in order of increasing date
cust_data<-cust_data %>% arrange(date)

# 7.4.6 Needs plyr conflicts with dplyr
# look at days between purchases
# purchaseFreq <- ddply(cust_data, .(customerid), summarize, daysBetween = as.numeric(diff(date)))
# ggplot(purchaseFreq,aes(x=daysBetween))+  geom_histogram(fill="orange")+ xlab("Time between purchases (days)")
  

## 8. Q10 
# 8.1 Determine customer-wise product_subclass preference? 
#     Step 1: Most preferred product (depends on how preference is defined)
items_most <- d12 %>%
  group_by(customerid,product_subclass ) %>%
  summarise(tp=n()) %>%         # No of times purchased
  ungroup() %>%
  arrange(desc(tp))

head(items_most)

# .keep_all = TRUE, keeps all variables in .data. 
#   Step2: If a combination of variables (customerid and product_subclass) is
#     not distinct, this keeps the first row of values (ie one with max values).
# 8.1.1
items_most %>% group_by(customerid) %>%
  distinct(customerid,.keep_all=TRUE) %>%
  ungroup()

# 8.2 Q11: Basket of purchases: Variety of purchases per customer, Productid wise
# Step 1
data_v<-d12 %>% group_by(customerid,productid) %>%
  summarise(items=n()) %>%
  ungroup()

# Step 2
data<-data_v %>% group_by(customerid) %>%
  summarise(items=n())  %>%
  ungroup() %>%
  arrange(desc(items))

head(data)

# 8.3 Step 3: Which of the customers purchase more than 50 variety 
#     Use data from above
data_vm<-data %>% filter (items >= 50)
head(data_vm)
tail(data_vm)


## 9.
# 9.1 Q12: Which product_class brings most revenue
data<-d12 %>% group_by(product_subclass) %>%
  summarise(revenue=sum(quantity * salesprice)) %>%
  ungroup() %>%
  arrange(desc(revenue))

# 9.2 Q13: Which product_class most customers buy?
# Step 1
data_most<-d12 %>% group_by(product_subclass,customerid) %>%
  summarise(freq=n()) %>% 
  ungroup()

head(data_most)

# Step 2
data<-data_most %>% group_by(product_subclass)  %>%
  summarise(popularity=n()) %>%
  ungroup() %>%
  arrange(desc(popularity))

head(data)

## 10
# 10.1 Q14: Age wise purchases. Which age group max purchases
d12 %>% group_by(age) %>%
  summarise(tp=sum(quantity * salesprice)) %>%
  ungroup() %>%
  arrange(desc(tp))

# 10.2 Q15: Residence area wise purchasing capacity
d12 %>% group_by(residence_area) %>%
  summarise(tp=sum(quantity * salesprice)) %>%
  ungroup() %>%
  arrange(desc(tp))

# 11
# 11.1 Q16: Distribuiton of age groups with residence_area
d12 %>% group_by(age,residence_area) %>%
  summarise (count=n()) %>%
  ungroup() %>%
  arrange(desc(count))


#################### Relationships ########################
## 12
# 12.1 Relationship1: Is there relationship between age and product_subclass
#      NULL Hypothesis is no relationship
chisq.test(d12$age,d12$product_subclass)

# 12.2 Relationship2: Is there relationship between residence_area and product_subclass
#      NULL Hypothesis is no relationship
chisq.test(d12$residence_area,d12$product_subclass)

# 12.3 Relationship 3: IS there any significant difference in avg spending age-wise
#   Steps: 
#        1. Create a column spending: spending=quantity * salesprice
#        2. Sum up spending age and dec_date wise
#        3. Find aov. Is result surprising in the first case
# Step 1
d12<-d12 %>% mutate (spending = quantity * salesprice)
# Step 2
data<-d12 %>% group_by(age,dec_date) %>% summarise(tp=sum(spending)) %>% ungroup()

# Step 3
# 12.3.1 First case with all data
# Find aov. The result is not significant
model<-aov(data$tp ~ data$age)
summary(model)

# 12.3.2 Examine boxplot of data for outliers
ggplot(data, aes(x = age, y = tp)) +
  geom_boxplot(fill = "grey80", colour = "blue") +
  scale_x_discrete() + xlab("Age-Group") +
  ylab("Total spending day wise")

# Step 3 Alternate
# 12.3.3 Second case without outliers
#        There are outliers. We will remove them first
data %>% arrange(desc(tp))  
data %>% filter(tp < 10000000 ) %>% arrange(desc(tp)) ->data

# 12.3.4 Examine box-plot of data again
ggplot(data, aes(x = age, y = tp)) +
  geom_boxplot(fill = "grey80", colour = "blue") +
  scale_x_discrete() + xlab("Age-Group") +
  ylab("Total spending day wise")

# 12.3.5 Find aov again. This time results are significant
model<-aov(data$tp ~ data$age)
summary(model)

# 12.4 What about residence wise
data<-d12 %>% group_by(residence_area,dec_date) %>%
  summarise(tp=sum(spending)) %>%
  ungroup()

# 12.4.1 First case with all data
model<-aov(data$tp ~ data$residence_area)
summary(model)

# 12.4.2 Examine box-plot of data
ggplot(data, aes(x = residence_area, y = tp)) +
  geom_boxplot(fill = "grey80", colour = "blue") +
  scale_x_discrete() + xlab("Residence-Group") +
  ylab("Total spending day wise")

# 12.4.3 Second case with outliers removed
# Arrange and filter data
data %>% arrange(desc(tp))

# 12.4.4 Remove outliers
data %>% filter(tp < 30000000 ) %>% arrange(desc(tp)) ->data

# 12.4.5 Have a look at relationships again. This time it is significant
model<-aov(data$tp ~ data$residence_area)
summary(model)


# Some experiments with date
library(lubridate)
# Create a character vector of dates
f<-c("19970123","19970212","19910303")
class(f)
# Convert f to date format
f<-ymd(f)
class(f)
# Extract month
m<-month(f)
month(f)
# Extract week day
wday(f)
weekdays(f)
# Extract year
year(f)
# Extract day of month
day(f)
# Convert it to number
decimal_date(f)

