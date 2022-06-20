# Error checking of panoramic drop camera habitat data exported from TransectMeasure ----

# This script is designed to be used interatively to find basic annotation errors that should be made to original EventMeasure (.EMObs) or generic annotation files AND for subsequent data analysis.

# NOTE: ERRORS SHOULD BE FIXED IN THE .TMObs AND THE SCRIPT RE-RAN!

### OBJECTIVES ###
# 1. Import data and run basic error reports
# 2. Run more thorough checks on the data against the metadata and images in the original directory
# 3. Tidy data into broad and detailed point-level and percent-cover data
# 4. Tidy the final data into organised dataframes
# 5. Visualise the final data and visually inspect for data trends and final errors
# 6. Export tidy datasets to a .csv format suitable for use in modelling and statistical testing

# Please forward any updates and improvements to tim.langlois@uwa.edu.au, claude.spencer@uwa.edu.au & brooke.gibbons@uwa.edu.au or raise an issue in the "forward-facing-benthic-composition-annotation" GitHub repository

# Clear memory
rm(list=ls())

## Libraries required
# To connect to GlobalArchive
library(devtools)
install_github("UWAMEGFisheries/GlobalArchive") # Run this once to install the GlobalArchive package
library(GlobalArchive)

# To tidy data
library(tidyr)
library(plyr)
library(dplyr)
library(stringr)
library(readr)

# To visualise data
library(ggplot2)
library(ggbeeswarm)

# Study name 
study <- "2021-05_Abrolhos_BOSS"  # Enter your study name (campaign ID) here for naming of tidy data 

# Set your working directory 
working.dir <- getwd() # Run this line for GitHub projects, or type your working directory manually

# Save these directory names to use later
# We recommend replicating our folder structure, however change directories here if you decide a different folder structure is more suitable for your project
# The recommended folder structure uses a data directory within the main directory, which contains multiple sub-folders for raw data, the original annotation images, errors to check and the final tidy data
data.dir  <- paste(working.dir,"data", sep="/") 
raw.dir   <- paste(data.dir,"raw", sep="/") 
tidy.dir  <- paste(data.dir,"tidy", sep="/")
error.dir <- paste(data.dir,"errors to check", sep="/") 
image.dir <- paste(data.dir, "images/BOSS", sep = "/")
plot.dir  <- paste(working.dir, "plots", sep = "/")

### 1. Import data and run basic error reports ----
# Set the directory to find the raw data
setwd(raw.dir)
dir()

# Read in metadata
metadata  <- read_csv(paste0(study, "_Metadata.csv")) %>% # Read in the file
  ga.clean.names() %>% # Tidy the column names using GlobalArchive function 
  dplyr::select(sample, latitude, longitude, date, site, location, successful.count) %>% # Select only these columns to keep
  # mutate(sample=as.character(sample)) %>% # Turn this line on if you have numerical sample names 
  glimpse() # Preview the data

# Read in the raw habitat data
dir()

points <- read.delim(paste0(study, "_Dot Point Measurements.txt"),header=T,skip=4,stringsAsFactors=FALSE) %>% # Read in the text file
  ga.clean.names() %>% # Tidy the column names using GlobalArchive function
  mutate(sample=str_replace_all(.$filename,c(".png"="",".jpg"="",".JPG"=""))) %>% # Removes image file extensions from sample names
  # mutate(sample=as.character(sample)) %>% # Turn on if you have numerical sample names
  select(sample,image.row,image.col,broad,morphology,type,fieldofview) %>% # Select only these columns to keep
  glimpse() # Preview the data

# Check to see if you have samples with points extra or missing points annotated
num.annotations.habitat <- points %>%
  group_by(sample) %>%
  summarise(points.annotated = n()) # All have 80 points annotated in this example dataset

# If you have samples with missing points, you should rectify this in the original .TMObs file!

# read in the relief gridded annotations
relief <- read.delim(paste0(study, "_Relief_Dot Point Measurements.txt"),header=T,skip=4,stringsAsFactors=FALSE) %>% # Read in the file
  ga.clean.names() %>% # Tidy the column names using GlobalArchive function
  mutate(sample=str_replace_all(.$filename,c(".png"="",".jpg"="",".JPG"=""))) %>% # Removes file extensions from sample names
  # mutate(sample=as.character(sample)) %>% # Turn on if you have numerical sample names
  select(sample,image.row,image.col,broad,morphology,type,fieldofview,relief) %>% # Select only these columns to keep
  glimpse() # Preview the data

# Check to see if you have samples with points extra or missing points annotated
num.annotations.relief  <- relief %>%
  group_by(sample) %>%
  summarise(relief.annotated = n()) # All have 80 points annotated in this example dataset

# If you have samples with missing points, you should rectify this in the original .TMObs file!

### 2. Run more thorough checks on the data against the metadata and images in the original directory ----
# Point to images folders
image.list <- dir(image.dir) %>% # Selects the directory where your habitat images are stored
  as.data.frame() %>% # Convert to a dataframe
  rename(image.name=1) %>% # Rename the column that contains image names
  mutate(sample=str_replace_all(.$image.name,c(".png"="",".jpg"="",".JPG"=""))) # Removes file extensions from image names

# Create a data frame to check habitat annotations against using original metadata
qaqc.habitat <- metadata %>%
  dplyr::select(sample, date) %>% # Select only these columns to keep
  dplyr::left_join(image.list) %>% # Joins sample and date from metadata with the list of images
  dplyr::left_join(num.annotations.habitat) %>% # And the number of annotation points per image
  glimpse() # Preview the data

# Habitat point annotation checking
# Find samples where images and annotations are missing
habitat.missing.image.not.annotated <- qaqc.habitat %>%
  filter(image.name %in% c("NA",NA)) %>%
  filter(points.annotated %in% c("NA",NA))

# Find samples where image is exported but missing annotations
habitat.missing.annotation <- qaqc.habitat %>%
  filter(!image.name %in% c("NA",NA))%>%
  filter(points.annotated %in% c("NA",NA))

# Find samples annotated but missing images
habitat.missing.image <- qaqc.habitat %>%
  filter(image.name %in% c("NA",NA)) %>%
  filter(!points.annotated %in% c("NA",NA))

# Find samples missing points, or with extra points annotated
habitat.wrong.points <- num.annotations.habitat %>%
  filter(points.annotated!= 80) # Change here for your number of points

# Relief grid annotation checking
# Create a data frame to check relief annotations against using original metadata
qaqc.relief <- metadata %>%
  dplyr::select(sample, date) %>% # Select only these columns to keep
  dplyr::left_join(image.list)%>% # Joins sample and date from metadata with the list of images
  dplyr::left_join(num.annotations.relief)%>% # And the number of annotation points per image
  glimpse() # Preview the data

# Find samples where images and annotations are missing
relief.missing.image.not.annotated <- qaqc.relief %>%
  filter(image.name%in%c("NA",NA)) %>% 
  filter(relief.annotated %in% c("NA",NA))

# Find samples where image is exported but missing annotations
relief.missing.annotation <- qaqc.relief %>%
  filter(!image.name %in% c("NA",NA))%>%
  filter(relief.annotated %in% c("NA",NA))

# Find samples annotated but missing images
relief.missing.image <- qaqc.relief %>%
  filter(image.name %in% c("NA",NA)) %>%
  filter(!relief.annotated%in%c("NA",NA))

# Find samples missing points, or with extra points annotated
relief.wrong.points <- num.annotations.relief %>%
  filter(relief.annotated!= 80) # Change here for your number of points (20 for single images, 80 for composite imagery)

# Joins metadata with the list of habitat images and the number of relief and habitat annotations
qaqc.all <- metadata %>%
  select(sample, date) %>% # Select only these columns
  left_join(image.list ) %>% # Joins sample and date from metadata with the list of images
  left_join(num.annotations.habitat) %>% # The number of annotation points per habitat image
  left_join(num.annotations.relief) %>% # And the number of annotation points per relief image
  glimpse() # Preview the data

# Find samples that have been annotated for habitat but not for relief 
habitat.no.relief <- qaqc.all %>%
  filter(!points.annotated%in%c("NA",NA)) %>%
  filter(relief.annotated%in%c("NA",NA)) # There are none for this example dataset

# Find samples that have been annotated for relief but not for habitat
relief.no.habitat <- qaqc.all %>%
  filter(points.annotated%in%c("NA",NA))%>%
  filter(!relief.annotated%in%c("NA",NA)) # There are none for this example dataset

# Export errors to check back through and fix in TransectMeasure
setwd(error.dir)

# Export errors in the habitat annotation data
write.csv(habitat.missing.image.not.annotated,paste(study,"habitat.missing.image.not.annotated.csv", sep = "."),row.names = FALSE) 
write.csv(habitat.missing.annotation,paste(study,"habitat.missing.annotation.csv", sep = "."),row.names = FALSE) 
write.csv(habitat.missing.image,paste(study,"habitat.missing.image.csv", sep = "."),row.names = FALSE) 
write.csv(habitat.wrong.points,paste(study, "habitat.wrong.points.csv", sep = "."),row.names = FALSE) 
write.csv(relief.no.habitat,paste(study, "relief.no.habitat.csv", sep = "."),row.names = FALSE) 

# Export errors in the relief annotation data
write.csv(relief.missing.image.not.annotated,paste(study, "relief.missing.image.not.annotated.csv", sep = "."),row.names = FALSE) 
write.csv(relief.missing.annotation,paste(study, "relief.missing.annotation.csv", sep = "."),row.names = FALSE) 
write.csv(relief.missing.image,paste(study, "relief.missing.image.csv", sep = "."),row.names = FALSE) 
write.csv(relief.wrong.points,paste(study, "relief.wrong.points.csv", sep = "."),row.names = FALSE) 
write.csv(habitat.no.relief,paste(study, "habitat.no.relief.csv", sep = "."),row.names = FALSE) 

###   STOP     AND    READ      THE     NEXT      PART     ###     

# We strongly encourage you to fix these errors at the source (i.e. TMObs).
# NOW check through the files in your "Errors to check" folder and make corrections to .TMObs / generic files and then re-run this script.

### 3. Tidy data into broad and detailed point-level and percent cover dataframes ----
# Join the habitat and relief annotations
habitat <- bind_rows(points, relief) # Stacks the habitat and relief data 

# Create %fov
fov.points <- habitat %>%
  select(-c(broad,morphology,type,relief)) %>% # Remove these columns
  filter(!fieldofview %in% "") %>% # Removes any blank entries - e.g. 'Open water'
  filter(!is.na(fieldofview)) %>% # Removes any NA entries
  mutate(fieldofview=paste("fov",fieldofview,sep = ".")) %>% # Add .fov onto all entries
  mutate(count=1) %>% # Add a count column to summarise the number of points
  spread(key=fieldofview,value=count, fill=0) %>% # Spreads data into wide format
  select(-c(image.row,image.col)) %>% # Remove image row and image col
  group_by(sample) %>%
  summarise_all(list(sum)) %>% # Add the points per sample across all FOV columns
  mutate(fov.total.points.annotated=rowSums(.[,2:(ncol(.))],na.rm = TRUE )) %>% # Get row sums of all data columns
  ga.clean.names() %>% # Clean names using GlobalArchive function
  glimpse() # Preview the data

fov.percent.cover <- fov.points %>%
  group_by(sample) %>%
  mutate_at(vars(starts_with("fov")),list(~./fov.total.points.annotated*100)) %>% # Create percent cover
  select(-c(fov.total.points.annotated)) %>% # Remove these columns
  glimpse() # Preview the data

# Create broad point annotations
broad.points <- habitat %>%
  select(-c(fieldofview,morphology,type,relief)) %>% # Select only these columns
  filter(!broad%in%c("",NA,"Unknown","Open.Water","Open Water")) %>% # Remove blank, NA, Unknown and Open water data
  mutate(broad=paste("broad",broad,sep = ".")) %>% # Add broad. to all entries
  mutate(count=1) %>% # Add a count column to summarise the number of points
  group_by(sample) %>%
  spread(key=broad,value=count,fill=0) %>% # Spread the data to wide format
  select(-c(image.row,image.col)) %>% # Remove image row and image col
  group_by(sample) %>%
  summarise_all(list(sum)) %>% # Add the points per sample across all broad habitat columns
  mutate(total.points.annotated=rowSums(.[,2:(ncol(.))],na.rm = TRUE )) %>% # Get row sums of all data columns
  ga.clean.names() %>% # Clean names using GlobalArchive function
  glimpse() # Preview the data

# Create broad percent cover
broad.percent.cover <- broad.points %>%
  group_by(sample) %>%
  mutate_at(vars(starts_with("broad")),list(~./total.points.annotated*100)) %>% # Create percent cover
  dplyr::select(-c(total.points.annotated)) %>% # Remove this column
  glimpse() # Preview the data

# Create  detailed point annotations
detailed.points <- habitat %>%
  select(-c(fieldofview, relief)) %>% # Remove these columns
  filter(!morphology %in% c("",NA,"Unknown")) %>% # Remove blank, NA and Unknown entries from morphology
  filter(!broad%in%c("",NA,"Unknown","Open Water","Open.Water")) %>% # Remove blank, NA, Unknown and Open water entries from broad
  mutate(morphology=paste("detailed",broad,morphology,type,sep = ".")) %>% # Paste broad morphology and type and add detailed.
  mutate(morphology=str_replace_all(.$morphology, c(".NA"="","[^[:alnum:] ]"="."," "="","10mm.."="10mm."))) %>% # Tidy some entries in morphology
  select(-c(broad,type)) %>% # Remove these columns
  mutate(count=1) %>% # Add a count column to summarise the number of points
  group_by(sample) %>%
  spread(key=morphology,value=count,fill=0) %>% # Spread the data to wide format
  select(-c(image.row,image.col)) %>% # Remove these columns
  group_by(sample) %>%
  summarise_all(list(sum)) %>% # Add the points per sample across all detailed habitat columns
  mutate(total.points.annotated=rowSums(.[,2:(ncol(.))],na.rm = TRUE )) %>% # Get row sums of all data columns
  ga.clean.names() %>% # Clean names using GlobalArchive function
  glimpse() # Preview the data

# Create detailed percent cover
detailed.percent.cover <- detailed.points %>%
  group_by(sample) %>%
  mutate_at(vars(starts_with("detailed")),list(~./total.points.annotated*100)) %>% # Create percent cover
  select(-c(total.points.annotated)) %>% # Remove this columns
  glimpse() # Preview the data

# Create relief
relief.grid <- habitat %>%
  filter(!broad%in%c("Open Water","Unknown")) %>% # Remove Open water and Unknown entries from broad
  filter(!relief%in%c("",NA)) %>% # Remove blank and NA entries from relief
  select(-c(broad,morphology,type,fieldofview,image.row,image.col)) %>% # Remove these columns
  mutate(relief.rank=ifelse(relief==".0. Flat substrate, sandy, rubble with few features. ~0 substrate slope.",0, # Create numerical relief ranks
                            ifelse(relief==".1. Some relief features amongst mostly flat substrate/sand/rubble. <45 degree substrate slope.",1,
                                   ifelse(relief==".2. Mostly relief features amongst some flat substrate or rubble. ~45 substrate slope.",2,
                                          ifelse(relief==".3. Good relief structure with some overhangs. >45 substrate slope.",3,
                                                 ifelse(relief==".4. High structural complexity, fissures and caves. Vertical wall. ~90 substrate slope.",4,
                                                        ifelse(relief==".5. Exceptional structural complexity, numerous large holes and caves. Vertical wall. ~90 substrate slope.",5,relief)))))))%>%
  select(-c(relief))%>% # Remove the original relief scores
  mutate(relief.rank=as.numeric(relief.rank)) %>% # Mutate the relief ranks as a numerical columns
  group_by(sample) %>%
  summarise(mean.relief= mean (relief.rank), sd.relief= sd (relief.rank))%>% # Create mean and standard deviation relief
  ungroup() %>% # Ungroup
  glimpse() # Preview the data

### 4. Tidy the final data into organised dataframes ----

habitat.broad.points <- metadata %>%
  left_join(fov.points, by = "sample") %>% # Joins metadata with FOV
  left_join(broad.points, by = "sample") %>% # Habitat data
  left_join(relief.grid) # And relief

habitat.detailed.points <- metadata %>%
  left_join(fov.points, by = "sample") %>% # Joins metadata with FOV
  left_join(detailed.points, by = "sample") %>% # Habitat data
  left_join(relief.grid) # And relief

habitat.broad.percent <- metadata %>%
  left_join(fov.percent.cover, by = "sample") %>% # Joins metadata with FOV
  left_join(broad.percent.cover, by = "sample") %>% # Habitat data
  left_join(relief.grid) # And relief

habitat.detailed.percent <- metadata %>%
  left_join(fov.percent.cover, by = "sample") %>% # Joins metadata with FOV
  left_join(detailed.percent.cover, by = "sample") %>% # Habitat data
  left_join(relief.grid) # And relief

### 5. Visualise the final data and visually inspect for any final errors ----
# Typical errors found could include samples where the wrong class has been assigned (ie. 20 point of octocoral instead of 20 points of sand)
# Or high cover of uncommon or rare classes

# Transform the data in a format suitable for use in ggplot 
# Broad habitat
broad.hab.plot <- habitat.broad.points %>%
  pivot_longer(cols = starts_with("broad"),names_to = "biota", values_to = "num.points") # Pivots dataframes into long format to plot

# Detailed habitat
detailed.hab.plot <- habitat.detailed.points %>%
  pivot_longer(cols = starts_with("detailed"),names_to = "biota", values_to = "num.points") # Pivots dataframes into long format to plot

# Relief
broad.rel.plot <- relief %>%
  mutate(relief.rank=ifelse(relief==".0. Flat substrate, sandy, rubble with few features. ~0 substrate slope.",0, # Transforms raw relief classes into relief ranks
                            ifelse(relief==".1. Some relief features amongst mostly flat substrate/sand/rubble. <45 degree substrate slope.",1,
                                   ifelse(relief==".2. Mostly relief features amongst some flat substrate or rubble. ~45 substrate slope.",2,
                                          ifelse(relief==".3. Good relief structure with some overhangs. >45 substrate slope.",3,
                                                 ifelse(relief==".4. High structural complexity, fissures and caves. Vertical wall. ~90 substrate slope.",4,
                                                        ifelse(relief==".5. Exceptional structural complexity, numerous large holes and caves. Vertical wall. ~90 substrate slope.",5,relief))))))) %>%
  dplyr::filter(!relief.rank%in%"") %>% # Removes blank annotations (e.g. 'Open water')
  dplyr::mutate(num.points = 1) %>% # Adds a count to summarise the relief at each rank and sample
  dplyr::group_by(sample, relief.rank) %>%
  dplyr::summarise(num.points = sum(num.points)) %>% # Sums the relief scores by sample and relief rank
  glimpse() # Preview the data

# Plot and visualise the broad habitat dataset
gg.broad.hab <- ggplot() +
  geom_quasirandom(data = broad.hab.plot, # Create a dotplot - each point represents a sample
                   aes(x = num.points, y = biota), groupOnX = F, method = "quasirandom",
                   alpha = 0.25, size = 1.8, width = 0.2) +
  labs(x = "Number of points", y = "") +
  theme_classic()
gg.broad.hab

# Plot and visualise the detailed habitat dataset
gg.detailed.hab <- ggplot() +
  geom_quasirandom(data = detailed.hab.plot, # Create a dotplot - each point represents a sample
                   aes(x = num.points, y = biota), groupOnX = F, method = "quasirandom",
                   alpha = 0.5, size = 1.8) +
  labs(x = "Number of points", y = "") +
  theme_classic()
gg.detailed.hab

# Plot and visualise the relief dataset
gg.relief <- ggplot() +
  geom_quasirandom(data = broad.rel.plot, # Create a dotplot - each point represents a sample
                   aes(x = num.points, y = relief.rank), groupOnX = F, method = "quasirandom",
                   alpha = 0.25, size = 1.8, width = 0.2) +
  labs(x = "Number of points", y = "Relief (0-5)") + 
  theme_classic()
gg.relief

# Save the plots to refer to later
setwd(plot.dir)

ggsave(paste(study, "broad.habitat.png", sep = "."),gg.broad.hab,dpi=600,width=6.0, height = 6.0)
ggsave(paste(study, "detailed.habitat.png", sep = "."),gg.detailed.hab,dpi=600,width=8.0, height = 6.0)
ggsave(paste(study, "relief.png", sep = "."),gg.relief,dpi=600,width=6.0, height = 6.0)

### 6. Export tidy datasets to a .csv format suitable for use in modelling and statistical testing ----
setwd(tidy.dir)
dir()

# Export point annotations
write.csv(habitat.broad.points,file=paste(study,"random-points_broad.habitat.csv",sep = "_"), row.names=FALSE)
write.csv(habitat.detailed.points,file=paste(study,"random-points_detailed.habitat.csv",sep = "_"), row.names=FALSE)

# Export percent cover annotations
write.csv(habitat.broad.percent,file=paste(study,"random-points_percent-cover_broad.habitat.csv",sep = "_"), row.names=FALSE)
write.csv(habitat.detailed.percent,file=paste(study,"random-points_percent-cover_detailed.habitat.csv",sep = "_"), row.names=FALSE)


setwd(working.dir) # Set working directory back to your main directory
