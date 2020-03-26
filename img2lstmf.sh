#!/bin/bash
# nohup bash  img2lstmf.sh > img2lstmf.log & 
# psm 13 for single line images
export PYTHONIOENCODING=utf8
ulimit -s 65536
SCRIPTPATH=`pwd`
MODEL=akk
FONTS=akk
GTDIR=gt
fontlist=langdata/$FONTS.fontslist.txt
while IFS= read -r fontname
     do
        prefix=$GTDIR/*${fontname// /_}
        my_files=$(ls $prefix/*.png)
        for my_file in ${my_files}; do
            echo  "${my_file}"
            python3 $SCRIPTPATH/generate_wordstr_box.py -t "${my_file%.*}".gt.txt  -i  "${my_file}" > "${my_file%.*}".box
            OMP_THREAD_LIMIT=1  tesseract "${my_file}" "${my_file%.*}"  --psm 13 --dpi 300  lstm.train    1>/dev/null 2>&1
        done
        ls -1  $prefix/*.lstmf > $SCRIPTPATH/data/all-${fontname// /_}-$MODEL-lstmf
        echo "Done with ${fontname// /_}"
     done < "$fontlist"

echo "All Done"

# ls -1 gt/ckb-Unikurd_Web/*.lstmf > data/all-Unikurd_Web-ckb-lstmf
