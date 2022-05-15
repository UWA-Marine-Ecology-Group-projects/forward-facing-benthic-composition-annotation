# Error checking of generic habitat data exported from TransectMeasure ----

# This script is designed to be used interatively to find basic annotation errors that should be made to original EventMeasure (.EMObs) or generic annotation files AND for subsequent data analysis.

# NOTE: ERRORS SHOULD BE FIXED IN THE .TMObs AND THE SCRIPT RE-RAN!

### OBJECTIVES ###
# 1. Import data and run BASIC error reports
# 2. Run more thorough checks on the data against the metadata and images in the original directory
# 3. Tidy data into broad and detailed point-level and percent cover dataframes
# 4. Export tidy datasets to a .csv format suitable for use in modelling and statistical testing 

# Please forward any updates and improvements to tim.langlois@uwa.edu.au, claude.spencer@uwa.edu.au & brooke.gibbons@uwa.edu.au or raise an issue in the "forward-facing-benthic-composition-annotation" GitHub repository

# Clear memory
rm(list=ls())

## Libraries required
# To connect to GlobalArchive
library(devtools)
# install_github("UWAMEGFisheries/GlobalArchive") # Run this once to install the GlobalArchive package
library(GlobalArchive)

# To tidy data
library(tidyr)
library(plyr)
library(dplyr)
library(stringr)
library(readr)
library(ggplot2)

# Study name 
study <- "2021-05_Abrolhos_stereo-BRUVs"  # Enter your study name here for saving tidy data later

# Set your working directory 
working.dir <- getwd() # Run this line for github projects, or type your working directory manually

# Save these directory names to use later
# We recommend replicating our folder structure, however change directories here if you decide a different folder structure is more suitable for your project
# The recommended folder structure uses a data directory within the main directory, which contains multiple sub-folders for raw data, the original annotation images, errors to check and the final tidy data
data.dir  <- paste(working.dir,"data", sep="/") 
raw.dir   <- paste(data.dir,"raw", sep="/") 
tidy.dir  <- paste(data.dir,"tidy", sep="/")
error.dir <- paste(data.dir,"errors to check", sep="/") 
image.dir <- paste(data.dir, "images", sep = "/")

### 1. Import data and run BASIC error reports ----
# Read in the metadata
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

# read in the benthic composition points annotations
points <- read.delim(paste0(study, "_Dot Point Measurements.txt"),header=T,skip=4,stringsAsFactors=FALSE) %>% # Read in the file
          ga.clean.names() %>% # Tidy the column names using GlobalArchive function
          mutate(sample=str_replace_all(.$filename,c(".png"="",".jpg"="",".JPG"=""))) %>% # Removes file extensions from sample names
          # mutate(sample=as.character(sample)) %>% # Turn on if you have numerical sample names
          select(sample,image.row,image.col,broad,morphology,type,fieldofview) %>% # s elect only these columns to keep
          glimpse() # preview

# Check to see if you have samples with points extra or missing points annotated
num.annotations.habitat <- points%>%
                           group_by(sample)%>%
                           summarise(points.annotated=n()) # all have 20 points annotated

# read in the relief gridded annotations
relief <- read.delim(paste0(study, "_Relief_Dot Point Measurements.txt"),header=T,skip=4,stringsAsFactors=FALSE) %>% # Read in the file
          ga.clean.names() %>% # Tidy the column names using GlobalArchive function
          mutate(sample=str_replace_all(.$filename,c(".png"="",".jpg"="",".JPG"=""))) %>% # Removes file extensions from sample names
          # mutate(sample=as.character(sample)) %>% # Turn on if you have numerical sample names
          select(sample,image.row,image.col,broad,morphology,type,fieldofview,relief) %>% # Select only these columns to keep
          glimpse() # Preview

# Check to see if you have samples with points extra or missing points annotated
num.annotations.relief  <- relief %>%
                           group_by(sample) %>%
                           summarise(relief.annotated=n()) # All have 20 points annotated

### 2. Run more thorough checks on the data against the metadata and images in the original directory ----
# Point to images folders
image.list <- dir(image.dir)%>% # Selects the directory where your habitat images are stored
              as.data.frame()%>%
              rename(image.name=1)%>% 
              mutate(sample=str_replace_all(.$image.name,c(".png"="",".jpg"="",".JPG"=""))) # Removes file extensions from image names

# Create a data frame to check habitat annotations against using original metadata
qaqc.habitat <- metadata %>%
                dplyr::select(sample, date) %>%
                dplyr::left_join(image.list)%>% # Joins sample and date from metadata with the list of images
                dplyr::left_join(num.annotations.habitat)%>% # And the number of annotations per image
                glimpse()

# Habitat point annotation checking
# Find samples where images and annotations are missing
habitat.missing.image.not.annotated <- qaqc.habitat %>%
                                       filter(image.name%in%c("NA",NA)) %>%
                                       filter(points.annotated %in% c("NA",NA))

# Find samples where image is exported but missing annotations
habitat.missing.annotation <- qaqc.habitat %>%
                              filter(!image.name %in% c("NA",NA))%>%
                              filter(points.annotated %in% c("NA",NA))

# Find samples annotated but missing images
habitat.missing.image <- qaqc.habitat %>%
                         filter(image.name %in% c("NA",NA)) %>%
                         filter(!points.annotated%in%c("NA",NA))

# Find samples missing points, or with extra points annotated
habitat.wrong.points <- num.annotations.habitat %>%
                        filter(points.annotated!= 20) # Change here for your number of points

# Relief grid annotation checking
# Create a data frame to check relief annotations against using original metadata
qaqc.relief <- metadata %>%
               dplyr::select(sample, date) %>%
               dplyr::left_join(image.list)%>%
               dplyr::left_join(num.annotations.relief)%>%
               glimpse()

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
                       filter(relief.annotated!= 20) # Change here for your number of points

# Compare grids and random-points
# Joins metadata with the list of habitat images and the number of relief and habitat annotations
qaqc.all <- metadata %>%
            select(sample, date) %>%
            left_join(image.list)%>%
            left_join(num.annotations.habitat)%>%
            left_join(num.annotations.relief)%>%
            glimpse()

# Find samples that have been annotated for habitat but not for relief 
habitat.no.relief <- qaqc.all %>%
                     filter(!points.annotated%in%c("NA",NA))%>%
                     filter(relief.annotated%in%c("NA",NA)) # NONE = good

# Find samples that have been annotated for relief but not for habitat
relief.no.habitat <- qaqc.all %>%
                     filter(points.annotated%in%c("NA",NA))%>%
                     filter(!relief.annotated%in%c("NA",NA)) # NONE = good

# Export errors to check back through and fix in 
setwd(error.dir)

# Save out habitat errors
write.csv(habitat.missing.image.not.annotated,"habitat.missing.image.not.annotated.csv",row.names = FALSE) 
write.csv(habitat.missing.annotation,"habitat.missing.annotation.csv",row.names = FALSE) 
write.csv(habitat.missing.image,"habitat.missing.image.csv",row.names = FALSE) 
write.csv(habitat.wrong.points,"habitat.wrong.points.csv",row.names = FALSE) 
write.csv(relief.no.habitat,"relief.no.habitat.csv",row.names = FALSE) 

# Save out relief errors
write.csv(relief.missing.image.not.annotated,"relief.missing.image.not.annotated.csv",row.names = FALSE) 
write.csv(relief.missing.annotation,"relief.missing.annotation.csv",row.names = FALSE) 
write.csv(relief.missing.image,"relief.missing.image.csv",row.names = FALSE) 
write.csv(relief.wrong.points,"relief.wrong.points.csv",row.names = FALSE) 
write.csv(habitat.no.relief,"habitat.no.relief.csv",row.names = FALSE) 

###   STOP     AND    READ      THE     NEXT      PART     ###     

# We strongly encourage you to fix these errors at the source (i.e. TMObs).
# NOW check through the files in your "Errors to check" folder and make corrections to .TMObs / generic files and then re-run this script.

### 3. Tidy data into broad and detailed point-level and percent cover dataframes ----
# Join the habitat and relief annotations
habitat <- bind_rows(points, relief)

# Create %fov
fov.points <- habitat %>%
              select(-c(broad,morphology,type,relief))%>%
              filter(!fieldofview=="")%>%
              filter(!is.na(fieldofview))%>%
              mutate(fieldofview=paste("fov",fieldofview,sep = "."))%>%
              mutate(count=1)%>%
              spread(key=fieldofview,value=count, fill=0)%>%
              select(-c(image.row,image.col))%>%
              group_by(sample)%>%
              summarise_all(list(sum))%>%
              mutate(fov.total.points.annotated=rowSums(.[,2:(ncol(.))],na.rm = TRUE ))%>%
              ga.clean.names()

fov.percent.cover <- fov.points %>%
                     group_by(sample)%>%
                     mutate_at(vars(starts_with("fov")),funs(./fov.total.points.annotated*100))%>%
                     select(-c(fov.total.points.annotated))%>%
                     glimpse()

# Create broad point annotations
broad.points <- habitat%>%
                select(-c(fieldofview,morphology,type,relief))%>%
                filter(!broad%in%c("",NA,"Unknown","Open.Water","Open Water"))%>%
                mutate(broad=paste("broad",broad,sep = "."))%>%
                mutate(count=1)%>%
                group_by(sample)%>%
                spread(key=broad,value=count,fill=0)%>%
                select(-c(image.row,image.col))%>%
                group_by(sample)%>%
                summarise_all(funs(sum))%>%
                mutate(broad.total.points.annotated=rowSums(.[,2:(ncol(.))],na.rm = TRUE ))%>%
                ga.clean.names()%>%
                glimpse()

# Create broad percent cover
broad.percent.cover <- broad.points %>%
                       group_by(sample)%>%
                       mutate_at(vars(starts_with("broad")),funs(./broad.total.points.annotated*100))%>%
                       dplyr::select(-c(broad.total.points.annotated))%>%
                       glimpse()

# Create  detailed point annotations
detailed.points <- habitat%>%
                   select(-c(fieldofview, relief))%>%
                   filter(!morphology%in%c("",NA,"Unknown"))%>%
                   filter(!broad%in%c("",NA,"Unknown","Open.Water"))%>%
                   mutate(morphology=paste("detailed",broad,morphology,type,sep = "."))%>%
                   mutate(morphology=str_replace_all(.$morphology, c(".NA"="","[^[:alnum:] ]"="."," "="","10mm.."="10mm.")))%>%
                   select(-c(broad,type))%>%
                   mutate(count=1)%>%
                   group_by(sample)%>%
                   spread(key=morphology,value=count,fill=0)%>%
                   select(-c(image.row,image.col))%>%
                   group_by(sample)%>%
                   summarise_all(funs(sum))%>%
                   mutate(detailed.total.points.annotated=rowSums(.[,2:(ncol(.))],na.rm = TRUE ))%>%
                   ga.clean.names()%>%
                   glimpse()

# Create detailed percent cover
detailed.percent.cover <- detailed.points %>%
                          group_by(sample)%>%
                          mutate_at(vars(starts_with("detailed")),funs(./detailed.total.points.annotated*100))%>%
                          select(-c(detailed.total.points.annotated))%>%
                          glimpse()

# Create relief
relief.grid <- habitat%>%
               filter(!broad%in%c("Open Water","Unknown"))%>%
               filter(!relief%in%c("",NA))%>%
               select(-c(broad,morphology,type,fieldofview,image.row,image.col))%>%
               mutate(relief.rank=ifelse(relief==".0. Flat substrate, sandy, rubble with few features. ~0 substrate slope.",0,
                  ifelse(relief==".1. Some relief features amongst mostly flat substrate/sand/rubble. <45 degree substrate slope.",1,
                  ifelse(relief==".2. Mostly relief features amongst some flat substrate or rubble. ~45 substrate slope.",2,
                  ifelse(relief==".3. Good relief structure with some overhangs. >45 substrate slope.",3,
                  ifelse(relief==".4. High structural complexity, fissures and caves. Vertical wall. ~90 substrate slope.",4,
                  ifelse(relief==".5. Exceptional structural complexity, numerous large holes and caves. Vertical wall. ~90 substrate slope.",5,relief)))))))%>%
               select(-c(relief))%>%
               mutate(relief.rank=as.numeric(relief.rank))%>%
               group_by(sample)%>%
               summarise(mean.relief= mean (relief.rank), sd.relief= sd (relief.rank))%>%
               ungroup()%>%
               glimpse()

### 4. Export tidy datasets to a .csv format suitable for use in modelling and statistical testing ----
# Write final habitat data
setwd(tidy.dir)
dir()

habitat.broad.points <- metadata%>%
                        left_join(fov.points, by = "sample")%>%
                        left_join(broad.points, by = "sample")%>%
                        left_join(relief.grid)

habitat.detailed.points <- metadata%>%
                           left_join(fov.points, by = "sample")%>%
                           left_join(detailed.points, by = "sample")%>%
                           left_join(relief.grid)

habitat.broad.percent <- metadata%>%
                         left_join(fov.percent.cover, by = "sample")%>%
                         left_join(broad.percent.cover, by = "sample")%>%
                         left_join(relief.grid)

habitat.detailed.percent <- metadata%>%
                            left_join(fov.percent.cover, by = "sample")%>%
                            left_join(detailed.percent.cover, by = "sample")%>%
                            left_join(relief.grid)

# Export point-annotations
write.csv(habitat.broad.points,file=paste(study,"random-points_broad.habitat.csv",sep = "_"), row.names=FALSE)
write.csv(habitat.detailed.points,file=paste(study,"random-points_detailed.habitat.csv",sep = "_"), row.names=FALSE)

# Export percent cover annotations
write.csv(habitat.broad.percent,file=paste(study,"random-points_percent-cover_broad.habitat.csv",sep = "_"), row.names=FALSE)
write.csv(habitat.detailed.percent,file=paste(study,"random-points_percent-cover_detailed.habitat.csv",sep = "_"), row.names=FALSE)



