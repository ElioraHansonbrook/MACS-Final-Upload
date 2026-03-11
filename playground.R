library(ggplot2)
library(shadowtext) #found this on Stack Overflow as a solution for making text that pops!
library(stringi) #Right-to-left text management :( BOO GGPlot!!!
library(sf)
library(quarto)
library(tidyverse)
library(dplyr)
library(ggthemes)
library(viridis)
library(scales)

iran_admin <- read_sf("shapefiles/ir_shp/ir.shp")
iran_places <- read_sf("shapefiles/iran-places/iran_places.shp")
iran_location <- read_sf("shapefiles/iran-location/iran_location.shp")
iran_misery <- read.csv("datafiles/ir_misery_index_per_prov_2023.csv")
iran_misery <- iran_misery %>%
  mutate(name = province)
ir_misery_map <- left_join(x = iran_admin, y = iran_misery, by = c("name"))
par(mar = c(0, 0, 0, 0))
#plot(st_geometry(iran_admin), col = "#f2f2f2", bg = "skyblue", lwd = 0.25, border = 0)
#plot(st_geometry(ir_misery_map["Misery.Index...2023"]), col = sf.colors(12), bg = "#fff", lwd = 0.25, border = 0)

international_states <- read.csv("datafiles/NMC-60-wsupplementary.csv")
states_map <- read_sf("shapefiles/states_map/geoBoundariesCGAZ_ADM0.shp")
states_map <- states_map %>%
  mutate(statenme = shapeName)
state_capabilities <- left_join(x = states_map, y = international_states, by = c("statenme"))
me_capabilities <- state_capabilities[state_capabilities$ccode >= 630 & state_capabilities$ccode <= 700 & state_capabilities$year == 2016,]

#plot(st_geometry(states_map), col = sf.colors(12), bg = "#fff", lwd = 0.25, border = 0)
ggplot(data = me_capabilities) +
  geom_sf(mapping = aes(fill = tpop)) +
  theme_void() +
  labs(
    title = "Population of Middle Eastern Countries",
    fill = "Thousands of People"
  ) +
  annotate("text", x=50, y=50, label= "Iran") +
  scale_fill_viridis_c(direction = 1, labels = scales::unit_format(unit = "T")) +
  theme(panel.background = element_rect(color = "#f9f5f5", fill = "#f9f5f5"),
        legend.background = element_rect(color = "#f9f5f5", fill = "#f9f5f5"),
        plot.background = element_rect(color = "#f9f5f5", fill = "#f9f5f5"),
        text=element_text(size=16,
                          family="Hoefler Text"))

#me_capabilities_time_analysis <- read.csv("posts/test-post/datafiles/World_Bank_Data.csv")
#ggplot(data = me_capabilities_time_analysis, aes(x = Year, y = NY.GDP.MKTP.KD)) +
#  geom_area() +
#  scale_y_continuous(labels = label_number(scale = 1e-9, suffix ="$B")) +
#  labs(
#    title = "Iranian GDP (Constant USD Equivalent)",
#  )+
#  ylab("Iranian GDP") +
#  geom_vline(xintercept=1979,
#             color = "red") +
#  geom_vline(xintercept=2017,
#           color = "red")

#plot(st_geometry(states_map), col = sf.colors(12), bg = "#fff", lwd = 0.25, border = 0)
#ggplot(data = me_capabilities) +
#  geom_sf(mapping = aes(fill = tpop)) +
#  theme_void() +
#  labs(
#    title = "Population of Middle Eastern Countries",
#    fill = "Thousands of People"
#  ) +
#  scale_fill_viridis_c(direction = 1)

#cow_trade <- read.csv("posts/test-post/datafiles/Dyadic_COW_4.0.csv")
#cow_trade <- cow_trade[cow_trade$year == 2014, ] %>%
#  mutate(statenme = importer1)
#state_internal_trade <- left_join(x = states_map, y = cow_trade, by = c("statenme"))
#me_internal_trade <- state_internal_trade[state_internal_trade$ccode1 >= 630 & state_internal_trade$ccode1 <= 700 & state_internal_trade$ccode2 >= 630 & state_internal_trade$ccode2 <= 700, ]
#me_internal_trade <- me_internal_trade %>%
#  group_by(importer1) %>%
#  mutate(total_me_trade = sum(flow1, na.rm = TRUE)) %>%
#  ungroup()
#me_internal_trade <- me_internal_trade[me_internal_trade$ccode2 == 700, ]

#ggplot(data = me_internal_trade) +
#  geom_sf(mapping = aes(fill = total_me_trade)) +
#  theme_void() +
#  labs(
#    title = "Total Imports from Other Middle Eastern Countries",
#    fill = "Millions of Dollars"
#  ) +
#  scale_fill_viridis_c(direction = 1)