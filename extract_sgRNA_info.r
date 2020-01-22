# extract the sgRNA, score and off target number.

args = commandArgs(TRUE)
name = args[1]

data=read.table(paste(name,'.txt',sep=""),header=F,sep="\t",skip=27,comment.char="")
L=dim(data)[1]-2
Enhancer=sapply(strsplit(as.vector(data[seq(1,L,2),1])," "),function(x) x[2])
output=NULL
for (i in 0:(length(Enhancer)-1)){
	data=try(read.table(paste(i,'.data',sep=""),header=F,skip=1)) #don't terminate the program if the input file is empty.
	if (!inherits(data, 'try-error')) {  
		temp=t(sapply(strsplit(as.vector(as.matrix(data)),","),rbind))
		order_index=order(temp[,1],decreasing=T)
		sorted_temp=temp[order_index,,drop=FALSE]
		output=rbind(output,cbind(Enhancer[i+1],sorted_temp,seq(1,dim(temp)[1])))
	}
}
write.table(output,paste(name,'_output.txt',sep=""),sep="\t",col.names=F,row.names=F,quote=F)
