library(sf)
library(tidyverse)
library(ggplot2)
library(raster)
library(here)
library(readxl)
library(measurements)
library(data.table)
library(tmap)

###======== Upload data sets =======###

#----- water quality data ------#
Marathon_WQ <- read_excel(here('Marathon_WQ_Only.xlsx'))

MWQ_var <- Marathon_WQ %>% 
  dplyr::select(resultvalue, latitudemeasure, longitudemeasure, horizontalcoordinatereferencesys, analysisstartdate, phosphorus_sample)

WaterQ <- st_read(here("Phosphorus.shp"))

WaterQ_fig <- ggplot()+
  geom_sf(data = HUC_use)+
  geom_sf(aes(color = resultvalu), data = WaterQ)

WaterQ_fig

WaterQ <-WaterQ %>% mutate(bin_year = case_when(
  year>=2009 & year < 2012 ~ "2009-2012",
  year>=2012 & year < 2015 ~ "2012-2015",
  year>=2015 & year < 2018 ~ "2015-2018",
  year>=2018 & year <= 2021 ~ "2018-2021"
))


WQ_Huc <- st_join(WaterQ, HUC_use) %>% 
  group_by(WSHED_CODE, bin_year) %>% 
  summarise(mean_WQ = mean(resultvalu, na.rm = TRUE))


WQ_Huc_conti <- st_join(WaterQ, HUC_use) %>% 
  group_by(WSHED_CODE, year) %>% 
  summarise(mean_WQ = mean(resultvalu, na.rm = TRUE))

#----- HUC unit data ------#
Huc10 <- st_read(here("Marathon_Watershed_HUC10.shp")) %>% st_transform(4326)

Huc10$WSHED_NAME %>% unique()
view(Huc10)

HUC_use <- dplyr::select(Huc10, "OBJECTID", "WSHED_NAME", "WSHED_CODE", "WATERSHED_", "WATERSHE_1", "TOTAL_STRE","geometry")

HUC_use$area <- st_area(HUC_use)
class(HUC_use$area)
HUC_use$area <- as.numeric(HUC_use$area)


HUC_use$area <- conv_unit(HUC_use$area, "m2", "acre")


###--- Clip HUC10 watershed to municipal boundaries, use for zonal statistics ---###

FPP_data <- st_read(here("FPPActiveData.shp")) %>% 
  mutate(Date = as.Date(Cont_expir)) %>% 
  mutate(year = format(FPP_data$Date, format = "%Y"))

FPP_data$year <- as.numeric(FPP_data$year)

FPP_data <- FPP_data %>% 
  mutate(start_year = year - 15)

FPP_data <- st_transform(FPP_data, crs = st_crs(HUC_use))

#--- Get management percentage area in 2009---#

FPP_data_2009 <- filter(FPP_data, start_year <= 2010)

FPP_Huc_area_2009 <- st_join(HUC_use, FPP_data) %>% 
  group_by(WSHED_CODE) %>% 
  summarise(sum_area = sum(FPP_Acres, na.rm = TRUE)) %>% 
  left_join(., st_drop_geometry(HUC_use), by = "WSHED_CODE") %>% 
  mutate(persentage = (sum_area/area)*100)

####--- Get accumulated management percentage areas ---####

FPP_by_year <- data.frame()

for (i in seq(2009, 2022, by = 3)) {

print(i)
  
FPP_Huc_area <- st_join(HUC_use, FPP_data) %>% 
  filter(start_year <= i) %>% 
  group_by(WSHED_CODE) %>% 
  summarise(sum_area = sum(FPP_Acres, na.rm = TRUE)) %>% 
  st_drop_geometry() %>% 
  mutate(start_year = i)

FPP_by_year <- rbind(FPP_by_year, FPP_Huc_area)
  
}

###---- join the FPP and HUC together ----###

FPP_Huc <- left_join(FPP_by_year, HUC_use, by = "WSHED_CODE") %>% 
  mutate(percent_area = (sum_area/area)*100)
  
FPP_Huc_bin <- FPP_Huc %>% mutate(bin = case_when(
  start_year>=2009 & start_year < 2012 ~ "2009-2012",
  start_year>=2012 & start_year < 2015 ~ "2012-2015",
  start_year>=2015 & start_year < 2018 ~ "2015-2018",
  start_year>=2018 & start_year <= 2021 ~ "2018-2021"
))

see_how_many <- filter(FPP_Huc_bin, sum_area != 0) %>% 
  group_by(WSHED_CODE, start_year)

see_how_many$WSHED_CODE %>% unique()
# Only 8 areas had management plans and it is match with the figures



####============= Linear Graph ==============####

waterQ_change_by_area <- ggplot()+
  geom_line(data = filter(WQ_Huc_conti, WSHED_CODE != "WR07"), aes(x = year, y = mean_WQ))+
  facet_wrap( ~ WSHED_CODE, ncol=3, scales="free")+
  ylab("Total Phosphorus in mg/L")+
  theme_bw()

waterQ_change_by_area


percent_change_by_area <- ggplot(data = filter(FPP_Huc_bin, is.na(percent_area) == FALSE))+
  geom_line(aes(x = start_year, y = percent_area))+
  facet_wrap( ~ WSHED_CODE, ncol=4, scales="free")+
  ylab("Number of Acres Each Nutrient Management Plan Covers")+
  xlab("Year")+
  theme_bw()

percent_change_by_area

##----Put them together to see the trend ----##

FPP_Huc_bin_year <- FPP_Huc_bin %>% 
  rename(year = start_year) %>% 
  left_join(., WQ_Huc_conti, by = c("year", "WSHED_CODE"))

all_fig <- ggplot()+
  geom_line(aes(x = year, y = mean_WQ, color = "Water Quality"), data = filter(WQ_Huc_conti, WSHED_CODE == "CW18"), size = 1.2)+
  geom_line(aes(x = year, y = percent_area/10, color = "NMP coverage"), data = filter(FPP_Huc_bin_year, WSHED_CODE == "CW18"), size = 1.2)+
  scale_y_continuous(name = "Total Phosphorus in mg/L",
                   sec.axis = sec_axis(~.*10, name = "percentage of management area"))+
  theme_bw()

all_fig

##---- it doesn't work for the other huc units ----##

all_fig_CW14 <- ggplot()+
  geom_line(aes(x = year, y = mean_WQ, color = "Water Quality"), data = filter(WQ_Huc_conti, WSHED_CODE == "CW14"))+
  geom_line(aes(x = year, y = percent_area/10, color = "NMP coverage"), data = filter(FPP_Huc_bin_year, WSHED_CODE == "CW14"))+
  scale_y_continuous(name = "Total Phosphorus in mg/L",
                     sec.axis = sec_axis(~.*10, name = "percentage of management area"))+
  theme_bw()


all_fig_CW14
# There's a problem with this data set, due to the corss-sectional data


####=================== Figures =================####

###--- create figure for the Huc and municipal boundaries ---###

Huc_municipal <- ggplot()+
  geom_sf(data = municipal, alpha = 0.5)+
  geom_sf(data = Huc10, aes(fill=WATERSHED_), alpha = 0.8)+
  scale_fill_gradient(low = "#56B1F7", high = "#132B43")+
  theme_bw()

Huc_municipal

###--- create figure for the  % of land HUC10 watersheds under nutrient management ---###
FPP_Huc_percent <- ggplot(data = filter(FPP_Huc_bin, start_year == "2009-2012"))+
  geom_sf(aes(fill = persent_area))+
  scale_fill_gradient(low = "#56B1F7", high = "#132B43")+
  theme_bw()

FPP_Huc_area_2009_fig <- ggplot(FPP_Huc_area_2009)+
  geom_sf(aes(fill = persentage))+
  scale_fill_gradient(low = "#56B1F7", high = "#132B43")+
  theme_bw()

FPP_Huc_area_2009_fig


FPP_Huc_percent

###---- create figures for the water quality ----###

WaterQ_2012 <- ggplot()+
  geom_sf(data = HUC_use)+
  geom_sf(data = filter(WaterQ, bin_year == "2009-2012"), aes(color = resultvalu))+
  theme_bw()

WaterQ_2012

WaterQ_2015 <- ggplot()+
  geom_sf(data = HUC_use)+
  geom_sf(data = filter(WaterQ, bin_year == "2012-2015"), aes(color = resultvalu))+
  theme_bw()

WaterQ_2015

WaterQ_2018 <- ggplot()+
  geom_sf(data = HUC_use)+
  geom_sf(data = filter(WaterQ, bin_year == "2015-2018"), aes(color = resultvalu))+
  theme_bw()

WaterQ_2018

WaterQ_2021 <- ggplot()+
  geom_sf(data = HUC_use)+
  geom_sf(data = filter(WaterQ, bin_year == "2018-2021"), aes(color = resultvalu))+
  theme_bw()

WaterQ_2021

#---- plot CW18 -----#
CW18 <- filter(HUC_use, WSHED_CODE == "CW18")

CW_18_fig <- tm_shape(CW18) +
  tm_polygons() +
  tm_layout(frame = FALSE)

CW_18_fig <- ggplot(data = CW18)+
  geom_sf(fill = "#134270")+
  theme_bw()

CW_18_fig
