This site hosts the Xu lab's CRISPR sgRNA design analysis.These scripts are primarily used to 1) exclude dnpii sites when selecting target regions for sgRNA design, 2) extract sgRNA information from Feng Zhang's website, 3) choose top scored sgRNA which don't overlap repeat masker region.

Example Usage

1 Rscript exclude_dpnii.r "target_region"

2 # convert bed file to fasta file
N # the number of bed file
for ((i=1; i<N; i++))
do
bedtools getfasta -fi hg19.fasta -bed bed_files/target_region_exclude_dpnii$i.bed -split -name -fo temp.fasta
fold -w 60 temp.fasta > fastq_files/target_region_exclude_dpnii$i.fa
rm temp.fasta
done

3 Submit fasta file to http://crispor.tefor.net/ to get the candidate sgRNA, download the table and save them as Optimized_CRISPR_Design$j.txt.

4 extract the sgRNA information.
N # the number of Optimized_CRISPR_Design$j.txt file.
for ((j=1; j<N; j++))
do
sh extract_wrap.sh "Optimized_CRISPR_Design$j.txt"
Rscript extract_sgRNA_info.r "Optimized_CRISPR_Design$j"
rm *.data *.html *.json
done

5 merge N output tables. 
cat *_output.txt > all_sgRNA_info.txt

6 get the overlapped region between target regions and repeat masker. 
bedtools intersect -loj -a target_region_exclude_dpnii.bed -b merged_RepeatMasker.bed > target_region_exclude_dpnii_olp_RepeatMasker.bed
Rscript target_region_overlap_repeatmasker.r 'target_region_exclude_dpnii_olp_RepeatMasker'

7 get the overlapped sequences between target regions and repeat masker.
bedtools getfasta -tab -fi hg19.fasta -bed target_region_exclude_dpnii_olp_RepeatMasker_output.bed -split -name -fo target_region_exclude_dpnii_olp_RepeatMasker_output_sequence.txt

8 select top scored sgRNA which don't overlap with repeatmasker.
Rscript select_top_scored_sgRNA_not_overlap_reapeatmasker.r 'target_region_exclude_dpnii_olp_RepeatMasker_output_sequence' 'all_sgRNA_info.txt'


