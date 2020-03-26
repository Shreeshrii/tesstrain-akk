#!/bin/bash
 text2image --find_fonts \
 --fonts_dir /home/ubuntu/.fonts/bali \
 --text bali.training_text \
 --min_coverage .9  \
 --render_per_font false \
 --outputbase ./bali \
 |& grep raw \
  | sed -e 's/ :.*//g'  > bali.fontslist.txt

 