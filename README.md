This site hosts the Xu lab's CRISPR sgRNA design batch analysis.These scripts are primarily used to 1) exclude dnpii sites when selecting target regions for sgRNA design, 2) extract sgRNA information from Feng Zhang's website, 3) choose top scored sgRNA which don't overlap repeat masker region.


1 Exclude dnpii sites from target regions.


Example Usage


oligoMatch $work_dir/Dpnii.fa $ref_dir/hg19.fasta $work_dir/dpnii_cut_site.bed

Rscript exclude_dpnii.r "target_region" "dpnii_cut_site"


input: 

target_region.bed   bed file with three columns

hg19.fasta   human reference fasta file. download from https://hgdownload.soe.ucsc.edu/goldenPath/hg19/bigZips/

Dpnii.fa supplied in this site


output:

target_region_exclude_dpnii1.bed

target_region_exclude_dpnii2.bed

...



2 Convert bed file to fasta file.

Example Usage

N # the number of bed file

for ((i=1; i<N; i++))

do

bedtools getfasta -fi hg19.fasta -bed target_region_exclude_dpnii$i.bed -split -name -fo temp.fasta

fold -w 60 temp.fasta > target_region_exclude_dpnii$i.fa

rm temp.fasta

done


input: 


target_region_exclude_dpnii$i.bed from step 1

hg19.fasta human reference fasta file. download from https://hgdownload.soe.ucsc.edu/goldenPath/hg19/bigZips/


output: 

fasta files target_region_exclude_dpnii$i.fa



3 Submit fasta files target_region_exclude_dpnii$i.fa to http://crispor.tefor.net/ to get the candidate sgRNA, save the websites as Optimized_CRISPR_Design$i.txt.



4 Extract the sgRNA information.


Example Usage

N # the number of Optimized_CRISPR_Design$j.txt file.

for ((j=1; j<N; j++))

do

sh extract_wrap.sh "Optimized_CRISPR_Design$j.txt"

Rscript extract_sgRNA_info.r "Optimized_CRISPR_Design$j"

rm *.data *.html *.json

done


input:


Optimized_CRISPR_Design$j.txt from step 3


output:

Optimized_CRISPR_Design${i}_output.txt



5 Merge N output tables. 

Example Usage

cat *_output.txt > all_sgRNA_info.txt



6 Get the overlapped region between target regions and repeat masker.


Example Usage


cat target_region_exclude_dpnii1.bed target_region_exclude_dpnii2.bed ... > target_region_exclude_dpnii.bed

 
bedtools intersect -loj -a target_region_exclude_dpnii.bed -b <(bedtools merge RepeatMasker.bed) > target_region_exclude_dpnii_olp_RepeatMasker.bed

Rscript target_region_overlap_repeatmasker.r 'target_region_exclude_dpnii_olp_RepeatMasker'


input: 

target_region_exclude_dpnii$i.bed from step 1

RepeatMasker.bed  download http://genome.ucsc.edu/cgi-bin/hgTables. 


output:

target_region_exclude_dpnii_olp_RepeatMasker_output.bed




7 Get the overlapped sequences between target regions and repeat masker.

Example Usage

bedtools getfasta -tab -fi hg19.fasta -bed target_region_exclude_dpnii_olp_RepeatMasker_output.bed -split -name -fo target_region_exclude_dpnii_olp_RepeatMasker_output_sequence.txt


input:

hg19.fasta  human reference fasta file.

target_region_exclude_dpnii_olp_RepeatMasker_output.bed from step 6


output:

target_region_exclude_dpnii_olp_RepeatMasker_output_sequence.txt




8 Select top scored sgRNA which don't overlap with repeatmasker.

Example Usage

Rscript select_top_scored_sgRNA_not_overlap_reapeatmasker.r 'target_region_exclude_dpnii_olp_RepeatMasker_output_sequence' 'all_sgRNA_info'


input:

target_region_exclude_dpnii_olp_RepeatMasker_output_sequence.txt from step7

all_sgRNA_info.txt from step 5



output:

useful_sgRNA.txt

