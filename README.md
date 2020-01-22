This site hosts the Xu lab's CRISPR sgRNA design analysis.These scripts are primarily used to 1) exclude dnpii sites when selecting target regions for sgRNA design, 2) extract sgRNA information from Feng Zhang's website, 3) choose top scored sgRNA which don't overlap repeat masker region.

Example Usage

1 Rscript exclude_dpnii.r "target_region"


2 bedtools getfasta -fi $ref_dir/ucsc.hg19.fasta -bed target_region_exclude_dpnii.bed -split -name -fo target_region_exlude_dpnii.fasta

3 


4 Rscript extract_sgRNA_info.r "Optimized_CRISPR_Design$j"

The are three columns in input annotation_table.txt file. The first colum is sgRNA sequence. The sescond column is description (you can put "NA" if no decription needed). And the third column is sgRNA id. Here are a few lines of the annotation table file:

| CAAGTTCCTGATTTTATCGA | NA | SPil_1 |
| GCCCCCTCCCTTGACATTGC | NA | SPil_1 |
| ACGGTCGTGGGTCAGACGCA | NA | SPil_1 |

