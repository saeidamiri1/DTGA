# DTGA: Discretized time series global Alignment
The distance dissimilarity measure in time series is an increasingly popular research topic due to its applicability in machine learning tasks, because a lot of data have a temporal nature. [Amiri et al. (2020)]() proposed a dissimilarity technique that provide accurate method for dissimilarity. The proposed method is fully nonparametric, we implemented the methods discussed [Amiri et al. (2020)]() in `R` and uploaded in Github.

## Contents
- [DTGA](#dtga)
  - [Data set](#dataset)
  - [Compute  DTGA ](#compute-dtga )
  - [Estimate of K](#estimate-of-k)
- [References](#references)

# DTGA
To load the codes in R, run the following script.
```
library(ggplot2)
library(Biostrings)
library(RCurl)
script <- getURL("https://raw.githubusercontent.com/saeidamiri1/DTGA/master/Rcode/need_dtga.R", ssl.verifypeer = FALSE)
eval(parse(text = script))
 ```
The ```dist_dtga()``` provides the dissimiliary matrix
```
dist_dtga(z,k=2)
```

The arguments are: ```z``` is the sequential difference, use the R's data frame for your data, and ```k``` is number of categories.

## Data set
To show how run the code on data set, we generated simulated data using different designs, the datasets are 'xm_design1_2015-01-01.csv','xm_design2_2015-01-01.csv','xm_design3_2015-01-01.csv', 'xm_design1_2015-06-24.csv', 'xm_design2_2015-06-24.csv', and 'xm_design1_2015-06-24.csv', see [Amiri et al. (2020)]() for the details of generating these datasets.  Each data has 12 variables and 76 observations. 

```
xm<-read.csv2('https://raw.githubusercontent.com/saeidamiri1/DTGA/master/data/xm_design1_2015-01-01.csv')
xm<-xm[,-1]
```

## Compute  DTGA
Calculate the sequential difference
```
z<-apply(xm,2,diff)
```

Once the data and the codes are loaded in R, for a given k, the size of categories, the dissimiarity matrix can be obtained using the following script, 
```
dist0<-dist_dtga(z,2)
```

The dendrogram can be also plotted,
```
plot(hclust(dist0))
```


## Estimate of K
Our studies show that in most cases, the size of category k=2 is sufficient to pick up the underlying pattern. However, you can use the HD statistic to find the estimate of k, the following codes plot HD vs. k for a cluster of size 4, the k that gives the smallest values of HD is our estimate of the optimal size of categories.
```
nclus<-4
acc<-NULL
i0<-0
for (k0 in seq(2,10,2)){
i0<-i0+1
dist0<-dist_dtga(z,k0)
aa<-change_dist(dist0,nclus)
acc[i0]<-accuracy_HD(aa)
}

data_acc<- data.frame(acc=acc, k=seq(2,10,2))

ggplot(data_acc, aes(x =k, y = acc)) + 
  geom_line(aes())+
  scale_x_continuous(limits = c(1, 10), breaks = seq(2,10,2))+
  geom_point()+
  labs(title = "Day 2015-01-01",x = "Number of categories",y='HD')+
  theme( legend.position = c(.9, .2),legend.background=element_rect(), panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
         panel.background = element_blank(), axis.line = element_line(colour = "black"))+
  scale_color_brewer(palette="Dark2")
```

# References
Amiri, S. et al. (2020). Dissimilarity of time series using Discretized time series global Alignment; with application of transportation data. ([pdf](), [journal]())

## License
Copyright (c) 2020 Saeid Amiri
**[⬆ back to top](#contents)**
