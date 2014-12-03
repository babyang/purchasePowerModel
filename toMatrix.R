library(dplyr) 
matrix<-function(args){
	uid_pidFilename<-args[1]
	matrixFilename<-args[2]
	my.data<-read.table(uid_pidFilename,sep=" ",header=F,as.is=T)
	names(my.data)<-c("uid","pid")
	my.data$count<-1
	my.matrix<-my.data %>%
			group_by(uid) %>%
			filter(sum(count)>2) %>%
			select(pid) %>%
			table()
	write.table(my.matrix,matrixFilename,sep=" ",row.names=T)	
}

args<-commandArgs(TRUE)
matrix(args)

