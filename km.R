my.kmeans <- function(args){
	file <- args[1]
	km_cluster <- args[2]
	km_center <- args[3]
	km.data <- args[4]
	k <- as.numeric(args[5])
	iter.max <- as.numeric(args[6])
	nstart <- as.numeric(args[7])
	data <- read.table(file)
	print("km begin")
	km<-kmeans(data,k,iter.max = 140,nstart = 40)
	print("km done")
	sink(km.data)
	print(km)
	sink()
	
	print("sink done")
	 write.table(km$cluster,km_cluster)
        print("cluster done")
        write.table(km$centers,km_center)

}
args <- commandArgs(TRUE)
my.kmeans(args)
