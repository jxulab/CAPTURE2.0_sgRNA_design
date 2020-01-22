# get the overlapped region between selected regions and repeat masker.

args = commandArgs(TRUE)
name = args[1]

data=read.table(paste(name,'.bed',sep=""),header=F,sep="\t")
no_olp_repeat=data[data[,5]=='.',] #not overlap with repeat masker
olp_repeat=data[data[,5]!='.',] #overlap with repeat masker
olp_region=olp_repeat[,1:3]
for (i in 1:dim(olp_region)[1]){
	olp_region[i,2]=max(as.vector(olp_repeat[i,2]),as.vector(olp_repeat[i,6]))
	olp_region[i,3]=min(as.vector(olp_repeat[i,3]),as.vector(olp_repeat[i,7]))
}
olp_region[,4]=paste(olp_repeat[,1],':',olp_repeat[,2],'-',olp_repeat[,3],';',olp_repeat[,4],sep="")
setwd('/project/CRI/Xu_lab/shared/YuannyuZhang/for_Xinliu/sgRNA_design/K562_Super_Enhancer_Capture_sgRNA_design')
write.table(olp_region,paste(name,'_output.bed',sep=""),col.names=F,row.names=F,sep="\t",quote=F)
