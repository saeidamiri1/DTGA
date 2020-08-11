trans<-function(x,k,ql,q0){
l<-k
if (k==2) {
    if(x<0) x0<- "l"
    else  x0<- "u"
    return(x0)
} else {
            if(x<=q0[1]) x0<- letters[1]
        for (l2 in 2:ql){
            if(q0[l2-1]<x & x<=q0[l2])
            x0<- letters[l2]
        }
            if(q0[ql]<x) x0<- letters[ql+1]
            return(x0)
}
}

catgo<-function(z,l){
z0<-z
q_l<-q_u<-NULL
z_l<-z[z<0]
z_u<-z[!z<0]
    p1<-1/l
    for (i1 in 1:(l-1)){
    q_l[i1]<-quantile(z_l,i1*p1) 
    q_u[i1]<-quantile(z_u,i1*p1)
    }
    q0<-c(q_l,0,q_u)
    ql<-length(q0)

for(j in 1:ncol(z)){
  for (i in 1:nrow(z)) {
    z0[i,j] = trans(z[i,j],l,ql,q0)
  }
}

z2<-NULL
for(j in 1:ncol(z0)){
z2[j]<-paste0(z0[,j], collapse = "")
}
z2
}



dist_dtga<-function(zz,k){
z3<-catgo(zz,k)
z30<-matrix(,ncol=length(z3),nrow =length(z3))
for(j in 1:length(z3)){
  for (i in 1:length(z3)) {
    aa<-pairwiseAlignment(pattern = z3[i], subject = z3[j])
    z30[i,j] = score(aa)
  }
}

z4<-z30+t(z30)
z5<-max(z4/2)-z4/2
m1B<-as.dist(z5)
m1B<-m1B/max(m1B)
return(m1B)
}




change_dist<-function(dis1,k){
cdk<-cutree(hclust(dis1),k)

`%notin%` <- Negate(`%in%`)
l1<-dim(as.matrix(dis1))[1]
xlab<-xdis<-NULL
xlab1<-xlab2<-xlab3<-xlab4<-NULL
xlabb<-matrix(,ncol=k,nrow=length(dis1))
ij<-0
for (i in 1:(l1-1)){
  for (j in (i+1):l1){
        ij<-ij+1
        xdis[ij]<-dis1[ij]
        for (i0 in 1:k){
        if (i %in% which(cdk==i0) & j %in% which(cdk==i0))  {
        xlabb[ij,i0]=1 
        } else if (i %in% which(cdk==i0) & j %notin% which(cdk==i0))  {
        xlabb[ij,i0]=0
        } else if (i %notin% which(cdk==i0) & j %in% which(cdk==i0)) {
        xlabb[ij,i0]=0
        } else {
        xlabb[ij,i0]=NA
        }
        }
  }
}
x_dist<-data.frame(xlabb,xdis)
return(x_dist)
}


accuracy_HD<-function(x_dist) {
  dx<-dim(x_dist)[2]
xd_s<-xd_s2<-NULL
for (i in 1:(dx-1)){
ia1<-which(x_dist[,i]==1)
ia2<-which(x_dist[,i]==0)
x_dist_m_1<-mean(x_dist[ia1,dx])
x_dist_m_2<-mean(x_dist[ia2,dx])
xd_s[i]<-x_dist_m_1/x_dist_m_2
}
return(mean(xd_s,na.rm=TRUE))
}
