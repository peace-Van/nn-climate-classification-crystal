# Köppen meets Neural Network: Revision of the Köppen Climate Classification by Neural Networks
Updated methodology and results

![](/plots/xx.png)

This repo is created with MATLAB R2022b and may be compatible with other versions.
The Mapping Toolbox, Statistics and Machine Learning Toolbox and Deep Learning Toolbox are needed.

## Updade on `nn-climate-classification`

- Neural network structure simplified significantly. Check `net.mat` for the details.
- Larger and newer dataset for training. Used climate normals of 1971-2000, 1972-2001, 1973-2002, ..., 1991-2020 and the corresponding land cover of 2001, 2002, 2003, ..., 2021. It's 21x volume of data compared to `nn-climate-classification`. Climate dataset version is updated to CRU TS v4.07 while land cover dataset version is updated to MCD12C1 v6.1.
- Feature extraction: use the activation of the `concat` layer instead of the `prelu` layer (simplified to `relu` in this new version). What the original `prelu` layer outputs is more related to biome instead of climate. The `concat` layer, which is closer to the input climate data, is more suitable here. PCA of the output features shows much less information and only 15 PCA components (428 were used in `nn-climate-classification`) are taken for the clustering. It's reasonable that there are not that many meaningful climate features.
- 5 × 3 × 3 SOM clustering followed by crystal clustering compared to the original 4 × 3 × 2 SOM only. The standard deviations of the first three PCA components of `concat` features follow a ratio of 3 : 2 : 2, but 3 × 2 × 2 SOM gives too broad climate types. Crystal clustering (T = 5.2) on the 45 subtypes gives 26 climate types, which I find optimal. Crystal clustering shows its advantage that it takes care of the spatial distribution of observations by considering system entropy. The well-documented `crystalcluster.m` is a general function that applies to any dataset (given it is not too large; `pdist` is used in the function to calculate pairwise distances between observations, which takes O(N^2) space.)
- A bit code refactorization.

## Explore the world's climate

`interactive_map.m` starts an interactive map for users to query the climate conditions of certain places by clicking on the map or entering in the console (the latter uses `OpenStreetMap` engine to locate input places).
Upon clicking or entering, a climate chart of the place will pop up.

Note that the queried internal dataset is of 0.5° × 0.5° resolution so the query result can be approximate for towns and cities.

## The climate types

|                             | **A** tropical | **C** subtropical | **D** continental | **E** temperate | **F** subarctic | **Gh**/**Gk** arctic |
|-----------------------------|----------------|-------------------|-------------------|-----------------|-----------------|----------------------|
| **f** humid/oceanic         | **Af**         | **Cf**            | /                 | **Efh**/**Efk** | **Ff**          | /                    |
| **m** moderate/semi-oceanic | **Am**         | **Cm**            | /                 | **Emh**/**Emk** | **Fm**          | /                    |
| **s** seasonal              | **As**         | **Cs**            | **Ds**            | **Es**          | **Fsh**/**Fsk** | /                    |
| **W** arid                  | **AW**         | **CW**            | **DW**            | **EW**          | /               | /                    |
| **S** semi-arid             | /              | /                 | **DSh**/**DSk**   | /               | /               | /                    |
| **H** highland              | /              | /                 | **DH**            | **EH**          | /               | /                    |

## Reproduce the work

### Dataset construction
Original global climate dataset [CRU TS](https://crudata.uea.ac.uk/cru/data/hrg/) and land cover dataset [MCD12C1](https://lpdaac.usgs.gov/products/mcd12c1v061/) can be downloaded from the links.

The climate variables are transformed to MATLAB matrices (`tmp.mat`, `pre.mat`, `pet.mat`) by `dat2mat.m`.

`hdf2veg.m` handles MCD12C1 and the transformed land cover data are saved as `veg.mat`.

The following data preparation procedures are packed into `prepare_data.m`.

### Neural network training
Load the untrained network `net.mat` into Deep Network Designer.

Load `datastore_train.mat` and `datastore_valid.mat`. Here validation set is the 1991-2020 climate normals vs land cover conditions of 2021.

In the training options dialog, set the `Solver` as `adam`, `ValidationFrequency` as 5451, `MaxEpochs` as 20, `MiniBatchSize` as 64, `L2Regularization` as 0, `LearnRateSchedule` as `piecewise` and `OutputNetwork` as `best-validation`. You may also explore altering other settings.

Export the trained network as `trainedNet.mat`.

### Feature generation and clustering
Run `net2model.m`.

The model parameters are saved in `clim_model_533_merged_5.2.mat`, including the PCA transform and how crystal clustering merges SOM subtypes.
`get_clim_map.m` gives the climate world map for a given climate dataset (`res`, `ds`) according to the trained network (`net`) and clustering model (`model`).

### Plotting
`bulk_plot.m` generates the plots in `plots` folder. The uploaded plots are based on 1991-2020 climate normals.

`imlegend.m` makes legend beneath the world map.

### Others
`get_clim.m` gives the climate type for a specific monthly series of climate variables (`tmp, pre, pet` in a 3 × 12 matrix).

`koppen.m` and `trewartha.m` figure out the Köppen-Geiger and Köppen-Trewartha types for the climate dataset.

## Copyright and other issues
`kappa.m` from [Giuseppe Cardillo](https://www.mathworks.com/matlabcentral/fileexchange/15365-cohen-s-kappa) calculates the Kappa statistics (a statistical measure of agreement between two schemes, used in Section 4.a.2, 4.b.3 and 4.b.4 of the paper).

`borderdata.mat` and `bordersm.m` are from [Chad Greene](https://www.mathworks.com/matlabcentral/fileexchange/50390-borders). They plot country borders just to make the maps more legible and do not carry any political meanings. Locations of some cities and borders may be inaccurate. Use of this code does not mean the author's acknowledgement of the locations.
