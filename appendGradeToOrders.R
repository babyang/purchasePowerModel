library(dplyr)
append<-function(args){
	ordersFilename<-args[1]
	item_cid_gradeFilename<-args[2]
	orderWithPivot<-args[3]
	orders <- read.table(ordersFilename,header=F,sep=" ",as.is=T)
	names(orders) <- c("oid","uid","tradeItemId","created","price","type","cid1")

	item_grad_pid <- read.table(item_cid_gradeFilename,header = T,sep = " ",as.is =T)
	
	my.data <- left_join(orders,item_grad_pid,by = "tradeItemId")
	my.data<-na.omit(my.data)
	write.table(my.data,orderWithPivot,sep = " ",row.names = F )

}
args<-commandArgs(TRUE)
append(args)
