count<-function(args){
	file20 <- args[1]
	file30 <- args[2]
	kluster.no<-as.numeric(args[3])
	cluster_output<-c()
	for(i in 1:kluster.no){
		cluster_output[i]<-args[i+3]	
	}
	dup <- args[4]
	df20 <- read.table(file20,sep=" ",header=T,as.is=T)
	df30 <- read.table(file30,sep=" ",header=T,as.is=T)

	
	count_p20_10<-c()
	count_p20_30<-c()
	count_p20_50<-c()
	count_p20_100<-c()
	count_p20_500<-c()
	count_p20_1000<-c()
		
	len = length(df20$tradeItemId)
	df20$ltr_rank<-1:len
	df30$ltr_rank<-1:len
	cluster.count <- length(cluster_output)
	cluster.list <- list()
	for(i in 1:cluster.count){
		cluster.name<-paste("c",i,sep="")
		index <- order(df20[[cluster.name]],decreasing=T)
		#cluster.list[[i]] <- df20[index,]
		
		cluster <- df20[index,] 
		cluster$rank<-1:len
		cl <- cluster$tradeItemId
		re <- data.frame(itemInfoId=cluster$itemInfoId,tradeItemId=cl)	
		
		write.table(re,cluster_output[i],row.names=F,col.names=F,sep=",")
		tid <- df20$tradeItemId
		count_p20_10[i] <-length(intersect(tid[1:10],cl[1:10]))
		count_p20_30[i] <-length(intersect(tid[1:30],cl[1:30]))
		count_p20_50[i] <-length(intersect(tid[1:50],cl[1:50]))
		count_p20_100[i] <-length(intersect(tid[1:100],cl[1:100]))
		count_p20_500[i] <-length(intersect(tid[1:500],cl[1:500]))
		count_p20_1000[i] <-length(intersect(tid[1:1000],cl[1:1000]))
	
	cluster_badcase<-paste(cluster_output[i],"badcase",sep=".")
	write.table(cluster,cluster_badcase,row.names=F,sep=" ")

	}	
	


	count_p30_10<-c()
	count_p30_30<-c()
	count_p30_50<-c()
	count_p30_100<-c()
	count_p30_500<-c()
	count_p30_1000<-c()
	for(i in 1:cluster.count){
		
		cluster.name<-paste("c",i,sep="")
		index <- order(df30[[cluster.name]],decreasing=T)
		cluster <- df30[index,]
		
		cluster$rank<-1:len
		cl <- cluster$tradeItemId
		re <- data.frame(itemInfoId=cluster$itemInfoId,tradeItemId=cl)	
		
		#write.table(re,cluster_output[i],row.names=F,col.names=F,sep=",")
		tid <- df30$tradeItemId
		count_p30_10[i] <-length(intersect(tid[1:10],cl[1:10]))
		count_p30_30[i] <-length(intersect(tid[1:30],cl[1:30]))
		count_p30_50[i] <-length(intersect(tid[1:50],cl[1:50]))
		count_p30_100[i] <-length(intersect(tid[1:100],cl[1:100]))
		count_p30_500[i] <-length(intersect(tid[1:500],cl[1:500]))
		count_p30_1000[i] <-length(intersect(tid[1:1000],cl[1:1000]))
		
	}	
		
	co <- data.frame(count_p20_10=count_p20_10,
			 count_p20_30=count_p20_30,
			 count_p20_50=count_p20_50,
			 count_p20_100=count_p20_100,
			 count_p20_500=count_p20_500,
			 count_p20_1000=count_p20_1000,
			 count_p30_10=count_p30_10,
			 count_p30_30=count_p30_30,
			 count_p30_50=count_p30_50,
			 count_p30_100=count_p30_100,
			 count_p30_500=count_p30_500,
			 count_p30_1000=count_p30_1000
			)

	write.table(co,dup)
}

args<-commandArgs(TRUE)
count(args)
