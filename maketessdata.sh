#!/bin/bash
PREFIX=xsanew
lstmtraining \
 	--stop_training \
 	--continue_from data/${PREFIX}/checkpoints/${PREFIX}Layer_checkpoint \
  --traineddata data/${PREFIX}/${PREFIX}.traineddata \
 	--model_output data/${PREFIX}Layer.traineddata
