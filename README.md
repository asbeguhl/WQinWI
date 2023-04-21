## How Nutrient Management Plans Affect Water Quality in Wisconsin

# Data Files & Descriptions
Marathon_WQ_Only.xlsx
- Data has already been cleaned and was retrieved via the EPAs water quality portal
- Variables of interest
  - resultvalue = Total Phosphorus in mg/L
  - latitudemeasure
  - longitudemeasure
  - horizontalcoordinatereferencesys
  - analysisstartdate = there are a few dates available in the dataset, just identifying one to standardize
  - phosphorus_sample = dummy variable where it equals 1 if its a Phosphorus sample and 0 otherwise

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

Watershed.shp
- contains HUC10 shape file for all of Wisconsin, will need to clip it to the municipal boundaries


Potential Outline
Water Quality in Marathon County
- Part 1 Graphing WQ Data
 -  2)	Marathon_WQ data
    a.	Extract data for just Phosphorus readings
    b.	Bin phosphorus readings every 2 years
      i.	2009-2010
      ii.	2011-2012
      iii.	2013-2014
      iv.	2015-2016
      v.	2017-2018
      vi.	2019-2020
    c.	Generate geographic point data using cords?
 3)	HUC10 Watershed Data
    a.	Clip HUC10 watershed shape file to municipal boundaries
 4)	FPP Data
    a.	Calculate the intersection of FPP types with HUC10 watersheds
      i.	No need to delineate between zone, AEA or both
      ii.	Identify the % of land HUC10 watersheds under nutrient management 
 5)	Append FPP data/% of land under nutrient management to zonal stats table
   a.	Spatial Join & group by huc10
 6)	Create a dual yaxis linear graph
   a.	Yaxis 1 = mean WQ reading in watershed
   b.	Yaxis 2 = %of land under nutrient management
   c.	Xaxis = binned time periods
i.	Should have data points for the following
1.	2010
2.	2012
3.	2014
4.	2016
5.	2018
6.	2020
d.	Replicate this graph for each HUC10
i.	21 graphs
Part II Crop Data Layer Info for each watershed
1)	Locate Crop Data Layer for Marathon County Wisconsin
2)	Create a dictionary with pixel identification
3)	Clip by watershed inside marathon
4)	Create Summary stats of top 10 crops in marathon county
5)	Intersect crop data layer with Farm Land Preservation Zone 
a.	Show top 10 crops under NMP
Part III Zonal Stats for PRISM data
1)	Load PRISM data for Marathon County
2)	Calculate Zonal Stats for Marathon County
3)	Create an animated graph for PRISM data with time as the variable
a.	Should be a slider, so you can demonstrate mean precipitation overtime
4)	Create a list of rainfall spike events in marathon county/correlate with P reading spikes? 
Spatial join, group by huc10 average instead of zonal stats
Readin daily rainfall data, PRISM
CDL Identify cropped area in watersheds too
