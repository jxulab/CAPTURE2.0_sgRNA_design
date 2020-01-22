#!/bin/bash

FILENAME=$1
FILE_LIST=($(grep "<http://crispr.mit.edu/guides" $FILENAME))
CMD="export https_proxy=proxy.swmed.edu:3128"
eval $CMD
for ((i=0;i<${#FILE_LIST[@]};i++))
do
  subPage=${FILE_LIST[$i]}
  URL=`echo $subPage | sed 's/<//g' | sed 's/>//g' | tr -d '\r'`
  WGET_OPTIONS="wget -O $i.html"
  CMD1="$WGET_OPTIONS $URL"
  CMD2="grep init_state $i.html > $i.json"
  CMD3="php extract.php $i > $i.data"
  eval "$CMD1;$CMD2;$CMD3"
done
