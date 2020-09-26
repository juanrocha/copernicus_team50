# Team 50 kettlebell

This repo contains the data cleaning steps for the Copernicus Hackathon: cloud and snow detection challenge. First we downloaded data from the Swedish Meteorological centre (SMHI) on [hourly clouds observations](https://www.smhi.se/data/utforskaren-oppna-data/se-acmf-meteorologiska-observationer-total-molnmangd-timvarde) and [snow depth](https://www.smhi.se/data/meteorologi/ladda-ner-meteorologiska-observationer#param=snowDepth,stations=all,stationid=172770). 

Then with the datetime stamps from the satellite imagery, we triangulate with ground measuremets to obtain annotated datasets indicating whether there was snow or clouds when the Sentinel 2 took the image. Data is accessible from SMHI website and their API.
