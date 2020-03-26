# tesstrain-akk

## Dependencies

* `tesseract` built from [github master](https://github.com/tesseract-ocr/tesseract)
* `linegen` from [kraken] (https://github.com/mittagessen/kraken)

## Training Steps

* conda activate kraken
* nohup bash txt2img.sh   > txt2img.log & 

* nohup bash  img2lstmf.sh > img2lstmf.log & 

* nohup bash trainlayer.sh > trainlayer.log & 

* nohup bash checkpointeval.sh > reports/checkpointeval.txt & 


