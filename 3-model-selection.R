# model selection ####

# suppose we have data from an experiment like this:
# mean RT correct = 250ms
# mean RT incorrect = 246ms
# accuracy = 0.80

# try to fit this data with both models by adjusting the parameters of the model
# HINT: you can speed up your parameter search by using a small number of samples
# initially, and then increasing the samples as you get closer to a viable set
# of parameters.
# 2nd HINT: Don't adjust the sdrw parameter of the random.walk.model or the criterion
# paramter of the accumulator model.

# You don't need to get a perfect match. Just get in the ballpark. 

set.seed(12604) # to ensure that you see the same results that I did!

rw.model.result <- random.walk.model(1000, drift=0.012, sdrw=0.3, criterion = 4.8)
rw.model.result %>% group_by(correct) %>% summarize(mean.rt = mean(rt))
mean(rw.model.result$correct)

acc.model.result <- accumulator.model(1000, rate.1 = 85, rate.2 = 91, criterion=3)
acc.model.result %>% group_by(correct) %>% summarize(mean.rt = mean(rt))
mean(acc.model.result$correct)


# Can both models do a reasonable job of accounting for the mean RT and accuracy? Report the
# results of your efforts:

# For the random walk model, parameters of drift=0.012 and criterion=4.8 produce mean RTs 
# of 255 and 256 for the incorrect and correct conditions, respectively. The overall accuracy
# is 77.2%. 

# For the accumulator model, parameters of rate.1 = 85 and rate.2 = 91 produce mean RTs
# of 259 and 251 for the incorrect and correct conditions, respectively. The overall accuracy
# is 76.8%.

# In short: both models seem equally capable of fitting these means and accuracy numbers. It's
# likely that further optimization of the parameters could improve the fit even more, but there's
# no evidence to suggest that one model is doing a substantially better job than the other at
# fitting the summary statistics.


# Using the parameters that you found above, plot histograms of the distribution of RTs
# predicted by each model. Based on these distributions, what kind of information could
# we use to evaluate which model is a better descriptor of the data for the experiment?
# Describe briefly how you might make this evaluation.


layout(matrix(1:4, nrow=2, byrow=T))
hist((rw.model.result %>% filter(correct==TRUE))$rt, breaks=seq(0,2000,100), main="RW Model, correct", xlab="RT")
hist((rw.model.result %>% filter(correct==FALSE))$rt, breaks=seq(0,2000,100), main="RW Model, incorrect", xlab="RT")
hist((acc.model.result %>% filter(correct==TRUE))$rt, breaks=seq(0,2000,10), main="ACC Model, correct", xlab="RT")
hist((acc.model.result %>% filter(correct==FALSE))$rt, breaks=seq(0,2000,10), main="ACC Model, incorrect", xlab="RT")

# From these histograms, two substantial differences in the model predictions jump out at me
# 1. The RW model predicts a very skewed distribution of RTs. The ACC model predicts 
#    a relatively symmmetrical distribution.
# 2. The variability is WAY higher in the RW model.

# The histograms are so different that it would probably be fine to simply visually compare
# the histogram of real RT data to these histograms and select the model that better fits the
# data. 

# More formally, we could look at the variance or standard deviation of RTs predicted by the 
# model and compare this to the variance or standard deviation in the real data:
rw.model.result %>% group_by(correct) %>% summarize(sd.rt = sd(rt))
acc.model.result %>% group_by(correct) %>% summarize(sd.rt = sd(rt))

# The RW model predicts SDs around 220. The ACC model predicts SDs around 13. That's a big enough
# difference to make a qualitative judgment in model fit.