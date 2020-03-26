#!/bin/sh
# nohup bash checkpointeval.sh > reports/checkpointeval.txt & 

SCRIPTPATH=`pwd`
LANG=akk
HEADCOUNT=5
IMGEXT=png

rm data/$LANG/tessdata_fast/*.traineddata data/$LANG/tessdata_best/*.traineddata
ls -t data/$LANG/checkpoints/*.checkpoint | head -$HEADCOUNT > tmpcheckpoints
CHECKPOINT_FILES=tmpcheckpoints
while IFS= read -r TESTCHECK
do
    make traineddata MODEL_NAME=$LANG  CHECKPOINT_FILES=$TESTCHECK
done < "$CHECKPOINT_FILES"

TRAINEDDATAFILES=data/$LANG/tessdata_fast/*.traineddata
for TRAINEDDATA in $TRAINEDDATAFILES  ; do
     TRAINEDDATAFILE="$(basename -- $TRAINEDDATA)"
      echo -e  "------------------------------------------------------------------- Unassigned "
           for PREFIX in $LANG ; do
			   FONTLIST=$SCRIPTPATH/langdata/$PREFIX.fontslist.txt
               LISTEVAL=$SCRIPTPATH/data/$PREFIX/list.eval
               REPORTSPATH=$SCRIPTPATH/reports/$PREFIX-eval-${TRAINEDDATAFILE%.*}
               rm -rf $REPORTSPATH
               mkdir $REPORTSPATH
               while IFS= read -r FONTNAME
               do
                   echo -e  "------------------------------------------------------------------- Unassigned"  $PREFIX-${FONTNAME// /_}-${TRAINEDDATAFILE%.*}
                    while IFS= read -r LSTMFNAME
                    do
                        ###    echo ${LSTMFNAME%.*}
                        if [[ $LSTMFNAME == *${FONTNAME// /_}* ]]; then
                            OMP_THREAD_LIMIT=1 tesseract ${LSTMFNAME%.*}.$IMGEXT  ${LSTMFNAME%.*}-${TRAINEDDATAFILE%.*} --psm 7 --oem 1  -l  ${TRAINEDDATAFILE%.*}  --tessdata-dir $SCRIPTPATH/data/$LANG/tessdata_fast/  -c page_separator=''   1>/dev/null 2>&1
                            ### cat ${LSTMFNAME%.*}.gt.txt   >>  $REPORTSPATH/gt-$PREFIX-${FONTNAME// /_}.txt
                            for f in ${LSTMFNAME%.*}.gt.txt; do cat "${f}"; echo; done >>  $REPORTSPATH/gt-$PREFIX-${FONTNAME// /_}.txt
                            cat ${LSTMFNAME%.*}-${TRAINEDDATAFILE%.*}.txt   >>  $REPORTSPATH/ocr-${TRAINEDDATAFILE%.*}-$PREFIX-${FONTNAME// /_}.txt
                    fi
                done < $LISTEVAL
                 accuracy $REPORTSPATH/gt-$PREFIX-${FONTNAME// /_}.txt  $REPORTSPATH/ocr-${TRAINEDDATAFILE%.*}-$PREFIX-${FONTNAME// /_}.txt  > $REPORTSPATH/report_${TRAINEDDATAFILE%.*}-$PREFIX-${FONTNAME// /_}.txt
	           java -cp ~/ocrevaluation/ocrevaluation.jar  eu.digitisation.Main  -gt "$REPORTSPATH/gt-$PREFIX-${FONTNAME// /_}.txt"  -ocr "$REPORTSPATH/ocr-${TRAINEDDATAFILE%.*}-$PREFIX-${FONTNAME// /_}.txt"  -e UTF-8   -o "$REPORTSPATH/report_${TRAINEDDATAFILE%.*}-$PREFIX-${FONTNAME// /_}.html"    1>/dev/null 2>&1
                head -26 $REPORTSPATH/report_${TRAINEDDATAFILE%.*}-$PREFIX-${FONTNAME// /_}.txt
                cat $REPORTSPATH/gt-$PREFIX-${FONTNAME// /_}.txt  >> $REPORTSPATH/gt-$PREFIX-ALL.txt 
                cat $REPORTSPATH/ocr-${TRAINEDDATAFILE%.*}-$PREFIX-${FONTNAME// /_}.txt >> $REPORTSPATH/ocr-${TRAINEDDATAFILE%.*}-$PREFIX-ALL.txt 
                echo -e  "-----------------------------------------------------------------------------"  
            done < "$FONTLIST"
             accuracy $REPORTSPATH/gt-$PREFIX-ALL.txt  $REPORTSPATH/ocr-${TRAINEDDATAFILE%.*}-$PREFIX-ALL.txt  > $REPORTSPATH/report_${TRAINEDDATAFILE%.*}-$PREFIX-ALL.txt
            java -cp ~/ocrevaluation/ocrevaluation.jar  eu.digitisation.Main  -gt "$REPORTSPATH/gt-$PREFIX-ALL.txt"  -ocr "$REPORTSPATH/ocr-${TRAINEDDATAFILE%.*}-$PREFIX-ALL.txt"  -e UTF-8   -o "$REPORTSPATH/report_${TRAINEDDATAFILE%.*}-$PREFIX-ALL.html"      1>/dev/null 2>&1
            echo -e  "-----------------------------------------------------------------------------"  
        done 
        echo -e  "*************************************************************************"  
done
rm tmpcheckpoints
for TRAINEDDATA in $TRAINEDDATAFILES  ; do
	echo $TRAINEDDATA
    OMP_THREAD_LIMIT=1   time -p  lstmeval  \
    --model  $TRAINEDDATA \
    --eval_listfile  $SCRIPTPATH/data/$LANG/list.eval \
    --verbosity 0  2>&1 |  egrep 'OCR|Truth' 
done

egrep 'Unassigned|Accuracy$|Digits|Punctuation' reports/checkpointeval.txt > reports/checkpointeval-summary.txt
