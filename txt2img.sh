#!/bin/bash
# SINGLE line images using kraken
# conda activate kraken
# nohup bash txt2img.sh   > txt2img.log & 
MODEL=akk
GTDIR=gt
unicodefontdir=/home/ubuntu/.fonts/$MODEL
traininginput=langdata/$MODEL.training_text
fontlist=langdata/$MODEL.fontslist.txt
fontcount=$(wc -l < "$fontlist")
linecount=$(wc -l < "$traininginput")
perfontcount=$(( linecount / fontcount))
trainingtext=/tmp/$MODEL-train.txt
fonttext=/tmp/$MODEL-kraken-train
python shuffle.py <  ${traininginput}  > ${trainingtext} 
mkdir -p $GTDIR
 while IFS= read -r fontname
     do
        echo "$fontname"
        head -$perfontcount ${trainingtext} > ${fonttext}
        sed -i  "1,$perfontcount d"  ${trainingtext}
        split -n l/2  -d ${fonttext} ${fonttext}
        ketos linegen  -u NFC  --disable-degradation -f "${fontname}" -o $GTDIR/$MODEL-"${fontname// /_}" ${fonttext}00
        ketos linegen  -u NFC  -f "${fontname}" -o $GTDIR/"${fontname// /_}" ${fonttext}01
    done < "$fontlist"
