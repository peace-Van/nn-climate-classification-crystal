# Köppen meets Neural Network: Revision of the Köppen Climate Classification by Neural Networks
Supplementary materials for the paper

![](/plots/core/x.png)

This repo is created with MATLAB R2021b and may be compatible with other versions.
The Mapping Toolbox, Statistics and Machine Learning Toolbox and Deep Learning Toolbox are needed.

## Explore the world's climate

`interactive_map.m` starts an interactive map for users to query the climate conditions of certain places by clicking on the map or entering in the console (the latter uses `OpenStreetMap` engine to locate input places).
Upon clicking or entering, a climate chart of the place will pop up.

Note that the queried internal dataset is of 0.5° × 0.5° resolution so the query result can be approximate for towns and cities.

## Reproduce the work

### Dataset construction
Original global climate dataset [CRU TS](https://crudata.uea.ac.uk/cru/data/hrg/) and land cover dataset [MCD12C1](https://lpdaac.usgs.gov/products/mcd12c1v006/) can be downloaded from the links.

The climate variables are transformed to MATLAB matrices (`tmp.mat`, `pre.mat`, `pet.mat`) by `dat2mat.m`.

Note that the code worked on the 1901-2020 CRU TS dataset; you may need to modify it for the newly available 1901-2021 dataset.

`hdf2veg.m` handles MCD12C1 and the transformed land cover data are saved as `veg.mat`.

They are packed into `dataset.mat` by `audit.m`.

`res2datastore.m` generates `datastore.mat` from `dataset.mat` for neural network training.

### Neural network training
Load the untrained network `net.mat` into Deep Network Designer.

Load the datastore as both training set and validation set.

In the training options dialog, set the `Solver` as `adam`, `LearnRateSchedule` as `piecewise` and `OutputNetwork` as `best-validation`. You may also explore altering other settings.

Export the trained network as `trainedNet.mat`.

### Feature generation and clustering
Run `net2features.m` and subsequently `features2clim.m`.

Save the output parameters of `features2clim.m` as `clim.mat`, `centroids.mat` and `trainedRes.mat`.

### Plotting
`bulk_plot.m` generates the plots in `plots` folder.

`imlegend.m` makes legend beneath the world map.

### Others
`get_clim.m` gives the climate type for a specific monthly series of climate variables (`tmp, pre, pet` in a 3 × 12 matrix).

`stat.xlsx` provides comparison with the Köppen-Geiger scheme and the land cover from another perspective (Section 4.b.3 and 4.b.4 of the paper).

`koppen.m` and `trewartha.m` figure out the Köppen-Geiger and Köppen-Trewartha types for the climate dataset.

## Copyright and other issues
`kappa.m` from [Giuseppe Cardillo](https://www.mathworks.com/matlabcentral/fileexchange/15365-cohen-s-kappa) calculates the Kappa statistics (a statistical measure of agreement between two schemes, used in Section 4.a.2, 4.b.3 and 4.b.4 of the paper).

`borderdata.mat` and `bordersm.m` are from [Chad Greene](https://www.mathworks.com/matlabcentral/fileexchange/50390-borders). They plot country borders just to make the maps more legible and do not carry any political meanings. Locations of some cities and borders may be inaccurate. Use of this code does not mean the author's acknowledgement of the locations.
