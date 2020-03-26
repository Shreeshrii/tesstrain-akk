#!/bin/bash
# SINGLE line images using text2image -
# nohup bash txt2lstmf.sh xsa > txt2lstmf-xsa.log &

lang=$1
unicodefontdir=/home/ubuntu/.fonts 
mkdir -p gt
traininginput=langdata/$lang.training_text
fontlist=langdata/$lang.fontslist.txt
fontcount=$(wc -l < "$fontlist")
linecount=$(wc -l < "$traininginput")
numlines=1
numfiles=$(( linecount / numlines))
# files created by script during processing
fonttext=/tmp/$lang-file-train.txt
linetext=/tmp/$lang-line-train.txt
 
 while IFS= read -r fontname
     do
        prefix=gt/$lang-${fontname// /_}
        rm -rf ${prefix} 
        mkdir  ${prefix} 
        cp ${traininginput} ${fonttext}
        for cnt in $(seq 1 $numfiles) ; do
            head -$numlines ${fonttext} > ${linetext}
             sed -i  "1,$numlines  d"  ${fonttext}
             last=${cnt: -1}
             case "$last" in
                  1)    let exp=0
                        OMP_THREAD_LIMIT=1 text2image --fonts_dir="$unicodefontdir"  --strip_unrenderable_words  --ptsize=12  --resolution=300  --xsize=2550  --ysize=350  --leading=32 --margin=100 --exposure=$exp  --font="$fontname" --text=$linetext  --outputbase=$prefix/${fontname// /_}.$cnt.exp$exp   --degrade_image=false
                       ;;
                  2)  let exp=-1
                        OMP_THREAD_LIMIT=1 text2image --fonts_dir="$unicodefontdir"  --strip_unrenderable_words  --ptsize=12  --resolution=300  --xsize=2550  --ysize=350  --leading=32 --margin=100 --exposure=$exp  --font="$fontname" --text=$linetext  --outputbase=$prefix/${fontname// /_}.$cnt.exp$exp   --degrade_image=true
                       ;;
                  3)  let exp=0
                        OMP_THREAD_LIMIT=1 text2image --fonts_dir="$unicodefontdir"  --strip_unrenderable_words  --ptsize=12  --resolution=300  --xsize=2550  --ysize=350  --leading=32 --margin=100 --exposure=$exp  --font="$fontname" --text=$linetext  --outputbase=$prefix/${fontname// /_}.$cnt.exp$exp --degrade_image=true  --distort_image     --invert=false   
                       ;;
                  4)  let exp=-1
                        OMP_THREAD_LIMIT=1 text2image --fonts_dir="$unicodefontdir"  --strip_unrenderable_words  --ptsize=12  --resolution=300  --xsize=2550  --ysize=350  --leading=32 --margin=100 --exposure=$exp  --font="$fontname" --text=$linetext  --outputbase=$prefix/${fontname// /_}.$cnt.exp$exp  --degrade_image=true  --distort_image     --invert=false   
                       ;;
                  5)  let exp=0
                        OMP_THREAD_LIMIT=1 text2image --fonts_dir="$unicodefontdir"  --strip_unrenderable_words  --ptsize=12  --resolution=150  --xsize=2550  --ysize=350  --leading=32 --margin=100 --exposure=$exp  --font="$fontname" --text=$linetext  --outputbase=$prefix/${fontname// /_}.$cnt.exp$exp   --degrade_image=true
                       ;;
                  6)  let exp=-1
                        OMP_THREAD_LIMIT=1 text2image --fonts_dir="$unicodefontdir"  --strip_unrenderable_words  --ptsize=12  --resolution=150  --xsize=2550  --ysize=350  --leading=32 --margin=100 --exposure=$exp  --font="$fontname" --text=$linetext  --outputbase=$prefix/${fontname// /_}.$cnt.exp$exp   --degrade_image=true   
                       ;;
                  7)  let exp=0
                        OMP_THREAD_LIMIT=1 text2image --fonts_dir="$unicodefontdir"  --strip_unrenderable_words  --ptsize=12  --resolution=200  --xsize=2550  --ysize=350  --leading=32 --margin=100 --exposure=$exp  --font="$fontname" --text=$linetext  --outputbase=$prefix/${fontname// /_}.$cnt.exp$exp   --degrade_image=false 
                       ;;
                  8)  let exp=-1
                        OMP_THREAD_LIMIT=1 text2image --fonts_dir="$unicodefontdir"  --strip_unrenderable_words  --ptsize=12  --resolution=200  --xsize=2550  --ysize=350  --leading=32 --margin=100 --exposure=$exp  --font="$fontname" --text=$linetext  --outputbase=$prefix/${fontname// /_}.$cnt.exp$exp    --degrade_image=true   
                       ;;
                  9)  let exp=0
                        OMP_THREAD_LIMIT=1 text2image --fonts_dir="$unicodefontdir"  --strip_unrenderable_words  --ptsize=12  --resolution=200  --xsize=2550  --ysize=350  --leading=32 --margin=100 --exposure=$exp  --font="$fontname" --text=$linetext  --outputbase=$prefix/${fontname// /_}.$cnt.exp$exp   --degrade_image=true --distort_image     --invert=false 
                       ;;
                  0)  let exp=-1
                        OMP_THREAD_LIMIT=1 text2image --fonts_dir="$unicodefontdir"  --strip_unrenderable_words  --ptsize=12  --resolution=200  --xsize=2550  --ysize=350  --leading=32 --margin=100 --exposure=$exp  --font="$fontname" --text=$linetext  --outputbase=$prefix/${fontname// /_}.$cnt.exp$exp  --degrade_image=true   --distort_image     --invert=false   
                       ;;
                  *) echo "Signal number $last is not processed"
                     ;;
             esac
             OMP_THREAD_LIMIT=1 tesseract $prefix/"${fontname// /_}.$cnt.exp$exp".tif $prefix/"${fontname// /_}.$cnt.exp$exp"  --psm 13 --dpi 150 lstm.train
             cp $linetext  $prefix/${fontname// /_}.$cnt.exp$exp.gt.txt
         done
        ls -1  $prefix/*${fontname// /_}.*.lstmf > data/all-${fontname// /_}-$lang-lstmf
        echo "Done with ${fontname// /_}"
     done < "$fontlist"
echo "All Done"


