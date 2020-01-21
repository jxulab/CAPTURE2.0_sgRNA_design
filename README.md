This site hosts the Xu lab's CRISPR screen analysis.These scripts are primarily used to get raw and normalized sgRNA counts from fastq file.

Example Usage
python sgRNA_count.py -b annotation_table.txt -f sgRNA.fastq > sgRNA_count.txt
The are three columns in input annotation_table.txt file. The first colum is sgRNA sequence. The sescond column is description (you can put "NA" if no decription needed). And the third column is sgRNA id. Here are a few lines of the annotation table file:

| CAAGTTCCTGATTTTATCGA | NA | SPil_1 |
| GCCCCCTCCCTTGACATTGC | NA | SPil_1 |
| ACGGTCGTGGGTCAGACGCA | NA | SPil_1 |
There are four columns in the output sgRNA_count.txt file. The first colum is sgRNA sequence. The second column is sgRNA id. The third column is sgRNA raw counts. And the fourth column is normalized sgRNA counts (normalized by total counts). Here are a few lines of output count file.

| CAAGTTCCTGATTTTATCGA | SPil_1 | raw count | normalized count|
| GCCCCCTCCCTTGACATTGC | SPil_1 | raw count | normalized count|
| ACGGTCGTGGGTCAGACGCA | SPil_1 | raw count | normalized count|
