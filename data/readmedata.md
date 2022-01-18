This readme files mentions the data sources that we worked with and steps we took to transform the data - 

1. "iati_activity_data.csv" - this is the original aid activity dataset that we downloaded from the website of International Aid Transparency Initiative (IATI) - https://iatistandard.org/en/. Each row of this dataset corresponds to an aid activity (aid disbursed/aid paid back in the case of loans etc) from a donating organisation to a recipient country. This aid activity also mentions the sector and the year corresponding to it. We cleaned/merged/transformed this dataset to arrive at the next dataset.

2. "df_tab_viz.csv" - this is the transformed dataset (transformed steps have been documented in the R script - "data_cleaning.R"). The major idea of the transformed dataset is to work with fewer relevant variables/columns and filter for observations that are non sensical (like year 2050) for whatever reason they might be. 

3. "iati_sectoral_bucketing.csv" - this is a dataset where we have bucketed/aggregated small sub-sectors into major sectors like heathcare, agriculture. 

4. All these datasets can be found here on this google drive link - 
https://drive.google.com/drive/folders/19k4wrwLY5njbSGprqYUohY3Ew5XN3qV7?usp=sharing

5. "country_data.R" - is an R scipt file that using "df_tab_viz.csv" has built the d3 visualization on the website. 

6. "country_projects.csv" - a csv file that outputs the results of the above R script. The dataset documents the # of aid projects received by a recipient country. 

7. "data_cleaning.R" - R script that transforms dataset 1 to dataset 2 as mentioned above. Follow the comments to see the steps followed for transformation.  
