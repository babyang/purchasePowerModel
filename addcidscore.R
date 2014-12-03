library(dplyr)


add<-function(args){
	center<-args[1]
	item_scores_cid<- args[2]
	item_all <- args[3]
	centers <- read.table(center,sep=" ",header=T,as.is=T)
	data<- read.table(item_scores_cid,sep=" ",header=T,as.is=T)
	tc <- as.data.frame(t(centers))
	tc$pcid <- names(centers)
	df<-left_join(data,tc,by = "pcid")
	score.list <- df$score
	score.max <-max(score.list)
	#print("max")
	#print(score.max)
	#print("min")
	
	score.min <-min(score.list)
	#print(score.min)
	pl <- (score.list-score.min)/(score.max-score.min)
	#print(pl)
	df$score_scaled <- pl
	df[is.na(df)]<-0
	write.table(df,item_all,row.names =F,sep = " ")

}
args<-commandArgs(T)
add(args)

