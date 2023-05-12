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

MUNIBoundary.zip>MUNIBoundary.shp
- Main use would be to clip other datasets to just Marathon County WI

FPPActiveData.zip>FPPActiveData.shp
- FPP_Type = lists out three different tax credit levels. This column will be unimportant for this analysis, unless you want to break out by tax credit type
- FPP_Acres = list out number of acres each Nutrient Management Plan (NMP) covers
- Cont_expir = Farmland Preservation Agreement expiration date. Once a plot signs an agreement, the plot of land is then required to operate in an NMP for 15 years. Thus, we can use it to identify how many acres were under NMP in previous years

CDL_Marathon_2020.TIF
- Crop Data Layer for Marathon County for the year of 2020

Watershed.zip>Watershed.shp
- contains HUC10 shape file for all of Wisconsin, will need to clip it to the municipal boundaries


# Replication Instructions
### Step one is to download repo
### Step two Extract zip folder contents into one folder
### Step three is to adjust file path in each package (Part 1: Qianqian_Water_quality.ipynb & Qianqian_code.R, 2: PartII_CropDataLayer.ipynb & 3: Jingru_part 3.ipynb) to the folder containing all packages
### Step four is to run the part you wish to replicate, outline of what each part contains is listed below

- Water Quality in Marathon County
- Part I Graphing WQ Data and NMP Data
  - 2)	Marathon_WQ data
    - a.	Extract data for just Phosphorus readings
    - b.	Bin phosphorus readings every 3 years
       - i.	2009-2012
       - ii.	2013-2015
       - iii.	2016-2018
       - iv.	2019-2021
     - c.	Generate geographic point data using cords
  - 3)	HUC10 Watershed Data
     - a.	Clip HUC10 watershed shape file to municipal boundaries
  - 4)	FPP Data
     - a.	Calculate the intersection of FPP types with HUC10 watersheds
       - i.	No need to delineate between zone, AEA or both
       - ii.	Identify the accumulated % of land HUC10 watersheds under nutrient management 
  - 5)	Append FPP data/% of land under nutrient management to zonal stats table
    - a.	Spatial Join & group by huc10
  - 6)	Create linear graphs
    - a.	Water quality changes over time by each HUC unit
    - b.	NMP coverage changes over time by each HUC unit
    - c.	Relationship between water quality change and NMP coverage change in HUC unit CW18


- Part II Crop Data Layer (Run PartII_CropDataLayer.ipynb to replicate results)
  - 1)	Import Crop Data Layer and Municipal Boundaries
    - a) Match CRS'
  - 2)	Create a dictionary that identifies pixel color to crop
  - 3)	Apply crop names to each pixel category
  - 4)  Aggregate categories and display percent under each USDA defined category
  - 4)	Disaggregate major land use categories and display top 7 land uses via pie chart in each section
  - 5)	Intersect crop data layer with Farm Land Preservation Zone 
    - a.	Show top 10 crops under NMP
    
- Part III Zonal Stats for PRISM data
  - 1)	Load PRISM data for Marathon County
  - 2)	Create a graph for PRISM data with time as the variable
    -  demonstrate mean precipitation overtime
  - 3)	The precipitation and water quality datasets were merged on the date column, aligning the water quality result values with the    corresponding precipitation data.
  - 4)	Map Generation: Maps were created to visualize the water quality result values at their respective locations, with the size of each point representing the water quality result value, and the color indicating the level of precipitation.
  - 5）Temporal Analysis: To observe temporal patterns, the map visualizations were created for different time periods (2009-2012, 2013-2015, 2016-2018, 2019-2021).
