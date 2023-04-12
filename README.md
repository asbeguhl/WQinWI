## How Nutrient Management Plans Affect Water Quality in Wisconsin

#Data Files & Descriptions
Marathon_WQ_Only.xlsx
- Data has already been cleaned and was retrieved via the EPAs water quality portal
- Variables of interest
-   resultvalue = Total Phosphorus in mg/L
-   latitudemeasure
-   longitudemeasure
-   horizontalcoordinatereferencesys
-   analysisstartdate = there are a few dates available in the dataset, just identifying one to standardize
-   phosphorus_sample = dummy variable where it equals 1 if its a Phosphorus sample and 0 otherwise
PRISM_ppt_tmin_tmean_tmax_tdmean_vpdmin_vpdmax_stable_4km_20090101_20201201_44.8983_-89.7591.csv
- ppt (inches) = precipitation in inches, it should already be clipped to just marathon county
MUNIBoundary.shp
- Main use would be to clip other datasets to just Marathon County WI
FPPActiveData.shp
- FPP_Type = lists out three different tax credit levels. This column will be unimportant for this analysis, unless you want to break out by tax credit type
- FPP_Acres = list out number of acres each Nutrient Management Plan (NMP) covers
- Cont_expir = Farmland Preservation Agreement expiration date. Once a plot signs an agreement, the plot of land is then required to operate in an NMP for 15 years. Thus, we can use it to identify how many acres were under NMP in previous years
CDL_Marathon_2020.TIF
- Crop Data Layer for Marathon County for the year of 2020
