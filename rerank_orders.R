
library(dplyr)

item_scores <- function(args){
	
	scoreFile <- args[1] 
	pidFile <- args[2]
	p70File<- args[3]
	join_result<-args[4]
	item_scores <- read.table(scoreFile,sep = "\t",header =T,as.is = T)
	item_price_pid_cid <- read.table(pidFile,sep = " ",header =F,as.is =T)
	names(item_price_pid_cid) <- c("tradeItemId","price","pid","cid")
	cid_p70 <- read.table(p70File,sep = " ",header=F,as.is = T)
	names(cid_p70) <- c("cid","p70")
	item_scores_cid <- left_join(item_scores,item_price_pid_cid,by = "tradeItemId")
	item_scores_all <- left_join(item_scores_cid,cid_p70,by = "cid")
	write.table(item_scores_all,join_result,row.names = F,sep = " ")

	
} 

args <- commandArgs(TRUE)
item_scores(args)



