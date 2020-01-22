#select top scored sgRNA which don't overlap with repeatmasker.

args = commandArgs(TRUE)
input_1 = args[1]
input_2 = args[2]

olp_regon_seq=read.table(paste(input_1,'.txt',sep=""),header=F,sep="\t")
sgRNA=read.table(paste(input_2,'.txt',sep=""),header=F,sep="\t")
uni_region=unique(as.vector(sgRNA[,1]))
useful_sgRNA=NULL
n=1
for (i in 1:length(uni_region)){
	sgRNA_temp=sgRNA[sgRNA[,1]==uni_region[i],]
	index=olp_region_seq[,1]%in%uni_region[i]
	if (sum(index)==0){  # the selected region is not overlapped with repeat masker.
		useful_sgRNA_temp=as.matrix(sgRNA_temp[1:n,])
		useful_sgRNA_temp[,1]=uni_region[i]
	}else{
		olp_region_seq_temp=olp_region_seq[olp_region_seq[,1]==uni_region[i],,drop=FALSE]
		if (dim(olp_region_seq_temp)[1]==1){ 
			repeat_seq=as.vector(olp_region_seq_temp[1,2])
			sgRNA_olp_repeat_flag=NULL
			for (j in 1:dim(sgRNA_temp)[1]){
				key_seq=substr(as.vector(sgRNA_temp[j,3]),14,20)
				temp=grep(key_seq,toupper(repeat_seq))				
				key_seq_rev_comp=reverseComplement(DNAStringSet(key_seq))
				temp2=grep(key_seq_rev_comp,toupper(repeat_seq))
				if ((length(temp)==0)&(length(temp2)==0)){sgRNA_olp_repeat_flag[j]=0}else{sgRNA_olp_repeat_flag[j]=1}
				# If the last 7 bases of the sgRNA or its reverse complement overlapped with repeatmasker, then remove this sgRNA				
			}
			if (sum(sgRNA_olp_repeat_flag==0)>0){
				no_olp_repeat_sgRNA=sgRNA_temp[sgRNA_olp_repeat_flag==0,]
				useful_sgRNA_temp=as.matrix(no_olp_repeat_sgRNA[1:n,])
				useful_sgRNA_temp[,1]=uni_region[i]
			}else{
				useful_sgRNA_temp=as.matrix(sgRNA_temp[1:n,]) 
				useful_sgRNA_temp[,1]=uni_region[i]
			}
		}else{
			sgRNA_olp_repeat_flag=matrix(NA,dim(sgRNA_temp)[1],dim(olp_region_seq_temp)[1])
			for (k in 1:dim(olp_region_seq_temp)[1]){
				repeat_seq=as.vector(olp_region_seq_temp[k,2])
				for (j in 1:dim(sgRNA_temp)[1]){
					key_seq=substr(as.vector(sgRNA_temp[j,3]),14,20)
					temp=grep(key_seq,toupper(repeat_seq))
					key_seq_rev_comp=reverseComplement(DNAStringSet(key_seq))
					temp2=grep(key_seq_rev_comp,toupper(repeat_seq))
					if ((length(temp)==0)&(length(temp2)==0)){sgRNA_olp_repeat_flag[j,k]=0}else{sgRNA_olp_repeat_flag[j,k]=1}
					# If the last 7 bases of the sgRNA or its reverse complement overlapped with repeatmasker, then remove this sgRNA				
				}
			}
			if (sum(rowSums(sgRNA_olp_repeat_flag)==0)>0){			
				no_olp_repeat_sgRNA=sgRNA_temp[rowSums(sgRNA_olp_repeat_flag)==0,]
				useful_sgRNA_temp=as.matrix(no_olp_repeat_sgRNA[1:n,])
				useful_sgRNA_temp[,1]=uni_region[i]
			}else{
				useful_sgRNA_temp=as.matrix(sgRNA_temp[1:n,])
				useful_sgRNA_temp[,1]=uni_region[i]
			}
		}
	}
	useful_sgRNA=rbind(useful_sgRNA,useful_sgRNA_temp)
}
write.table(useful_sgRNA,'useful_sgRNA.txt',row.names=F,col.names=F,sep="\t",quote=F)
# The criterion to select top scored sgRNA: If the last 7 bases of the sgRNA or its reverse complement overlapped with repeatmasker, then remove this sgRNA	and
# move to the next most scored sgRNA.