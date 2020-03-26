# tesstrain-akk

Over 95% accuracy on the evaluation set for Akkadian in Cuneiform script using the finetuned traineddata for tesseract 5 alpha

## Dependencies

* `tesseract` built from [github master](https://github.com/tesseract-ocr/tesseract)
* `linegen` from [kraken](https://github.com/mittagessen/kraken)

## Training Input

* [training text](https://github.com/Shreeshrii/tesstrain-akk/blob/master/langdata/akk.training_text)
* [fonts](https://github.com/Shreeshrii/tesstrain-akk/blob/master/langdata/akk.fontslist.txt)
* [unicharset](https://github.com/Shreeshrii/tesstrain-akk/blob/master/data/akk/akk.unicharset)

## Training Steps

* conda activate kraken
* nohup bash txt2img.sh   > txt2img.log & 

* nohup bash  img2lstmf.sh > img2lstmf.log & 

* nohup bash trainlayer.sh > trainlayer.log & 

* nohup bash checkpointeval.sh > reports/checkpointeval.txt & 

## Traineddata files

* [trained tessdata_best](https://github.com/Shreeshrii/tesstrain-akk/tree/master/data/akk/tessdata_best)
* [trained tessdata_fast](https://github.com/Shreeshrii/tesstrain-akk/tree/master/data/akk/tessdata_fast)
* [other old models](https://github.com/Shreeshrii/tesstrain-akk/tree/master/data)

## Evaluation Results

* [Summary](https://github.com/Shreeshrii/tesstrain-akk/blob/master/reports/checkpointeval-summary.txt)
* [Detail](https://github.com/Shreeshrii/tesstrain-akk/blob/master/reports/checkpointeval.txt)
* [Model Level Detail](https://github.com/Shreeshrii/tesstrain-akk/tree/master/reports)
