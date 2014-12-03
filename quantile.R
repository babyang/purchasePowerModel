library(dplyr)
qu.f <- function(price.list){
	grade.qu <- quantile(price.list,c(0.9,0.8,0.7,0.6,0.5))
	return(grade.qu)
}

quant<-function(args){
	cid2parentFileName<-args[1]
	item_cid_priceFileName<-args[2]
	item_cid_gradeFileName<-args[3]	
	cid2parent <- read.table(cid2parentFileName,header = F,sep= " ",as.is =T)
	names(cid2parent) = c("cid","pid")
	item_cid_price <- read.table(item_cid_priceFileName,header=F,sep= " ",as.is = T)
	names(item_cid_price) <- c("tradeItemId","cid","price.ori")

	grade.qus <- aggregate(item_cid_price$price.ori,list(item_cid_price$cid),qu.f)
	names(grade.qus) <- c("cid","percent")
	p <- grade.qus$percent
	g.qus <- data.frame(cid = grade.qus$cid,p90=p[,1],p80=p[,2],p70 = p[,3],p60 = p[,4],p50=p[,5])
	item.gra <- left_join(item_cid_price,g.qus)
	item.gra<-na.omit(item.gra)
	item.grad <- left_join(item.gra,cid2parent)
	item.grad<-na.omit(item.grad)
	write.table(item.grad,item_cid_gradeFileName,row.names=F,sep=" ")
}

args<-commandArgs(T)
quant(args)



