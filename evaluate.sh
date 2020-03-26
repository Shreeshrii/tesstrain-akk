#!/bin/sh
# from https://ub-backup.bib.uni-mannheim.de/~stweil/ocrd-train/evaluate.sh
Model1=
Model2=

echo Evaluate all training results from $Model1 against $Model2

date

for model in data/$Model1/tessdata_*/*.traineddata; do
  name="$(basename "$model" .traineddata)"
  logfile=$(dirname "$model")/lstmeval-$name.log
  lstmeval --eval_listfile $Model2/list.eval --model "$model" \
    --verbosity 1 2>&1 | grep -v ^Loaded >"$logfile"
  echo "$name - $(tail -n 1 "$logfile" | sed s/.*Eval.//)"
done

date