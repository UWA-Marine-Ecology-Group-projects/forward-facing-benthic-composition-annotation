##### FORMATTING AND CHECKING HABITAT DATA FROM TRANSECT MEASURE ##### 



# Clear memory ----
rm(list=ls())

# Libraries required ----
# To connect to GlobalArchive
library(devtools)
# install_github("UWAMEGFisheries/GlobalArchive") # run this once
library(GlobalArchive)

# To tidy data
library(tidyr)
library(plyr)
library(dplyr)
library(stringr)
library(readr)
library(ggplot2)

# Study name ----
study<-"2021-05_Abrolhos_stereo-BRUVs"  # enter your study name here

## Set your working directory ----
working.dir <- getwd() # run this line for github projects, or type your working directory manually

## Save these directory names to use later----
data.dir <- paste(working.dir,"data", sep="/") 
raw.dir <- paste(data.dir,"raw", sep="/") 
tidy.dir <- paste(data.dir,"tidy", sep="/")
error.dir <- paste(data.dir,"errors to check", sep="/") 
image.dir <- paste(data.dir, "images", sep = "/")

# Read in the metadata----
setwd(raw.dir)
dir()

# Read in metadata----
metadata <- read_csv("2021-05_Abrolhos_stereo-BRUVs_Metadata.csv") %>% # read in the file
  ga.clean.names() %>% # tidy the column names using GlobalArchive function 
  dplyr::select(sample, latitude, longitude, date, site, location, successful.count) %>% # select only these columns to keep
  # mutate(sample=as.character(sample)) %>% # turn on if you have numerical sample names
  glimpse() # preview

names(metadata)

# Read in habitat ----
dir()

# read in the benthic composition points annotations ----
points <- read.delim("2021-05_Abrolhos_stereo-BRUVs_Forwards_Dot Point Measurements.txt",header=T,skip=4,stringsAsFactors=FALSE) %>% # read in the file
  ga.clean.names() %>% # tidy the column names using GlobalArchive function
  mutate(sample=str_replace_all(.$filename,c(".png"="",".jpg"="",".JPG"=""))) %>%
  mutate(sample=as.character(sample)) %>% 
  select(sample,image.row,image.col,broad,morphology,type,fieldofview) %>% # select only these columns to keep
  glimpse() # preview

# basic check to manually assess the number of samples ----
length(unique(points$sample)) # 50 samples

# Check to see if you have samples with points extra or missing points annotated ----
num.annotations <- points%>%
  group_by(sample)%>%
  summarise(points.annotated=n()) # all have 20 points annotated

# Check that the image names match the metadata samples -----
missing.metadata.habitat <- anti_join(points,metadata, by = c("sample")) # samples in habitat that don't have a match in the metadata
missing.habitat <- anti_join(metadata,points, by = c("sample")) # samples in the metadata that don't have a match in habitat

# read in the relief gridded annotations ----
relief <- read.delim("2021-05_Abrolhos_stereo-BRUVs_Forwards_Relief_Dot Point Measurements.txt",header=T,skip=4,stringsAsFactors=FALSE) %>% # read in the file
  ga.clean.names() %>% # tidy the column names using GlobalArchive function
  mutate(sample=str_replace_all(.$filename,c(".png"="",".jpg"="",".JPG"=""))) %>%
  mutate(sample=as.character(sample)) %>% 
  select(sample,image.row,image.col,broad,morphology,type,fieldofview,relief) %>% # select only these columns to keep
  glimpse() # preview

# basic check to manually assess the number of samples ----
length(unique(relief$sample)) # 50 samples

# Check to see if you have samples with points extra or missing points annotated ----
num.annotations <- relief%>%
  group_by(sample)%>%
  summarise(relief.annotated=n()) # all have 20 points annotated

# Check that the image names match the metadata samples -----
missing.metadata.relief <- anti_join(relief,metadata, by = c("sample")) # samples in habitat that don't have a match in the metadata
missing.relief <- anti_join(metadata,relief, by = c("sample")) # samples in the metadata that don't have a match in habitat

# Join the habitat and relief annotations
habitat <- bind_rows(points, relief)

##### CHECKING FOR MISSING IMAGE STUFF #####
# Point to images folders ----
forwards.list <- dir(image.dir)%>%
  as.data.frame()%>%
  rename(forwards.image.name=1)%>%
  mutate(sample=str_replace_all(.$forwards.image.name,c(".png"="",".jpg"="",".JPG"="")))

backwards.list <- dir(backwards.dir)%>%as.data.frame()%>%rename(backwards.image.name=1) %>%
  dplyr::filter(!backwards.image.name %in%c("Thumbs.db")) %>%
  mutate(sample=str_replace_all(.$backwards.image.name,c(".png"="",".jpg"="",".JPG"="")))

# Create checking data frame ----
qaqc.points <- metadata %>%
  dplyr::select(sample, date) %>%
  dplyr::left_join(forwards.list)%>%
  dplyr::left_join(forwards.points.no.annotations)%>%
  dplyr::left_join(backwards.list)%>%
  dplyr::left_join(backwards.points.no.annotations)%>%
  glimpse()

# Find samples where images and annotations are missing:
forwards.points.missing.image.not.annotated <- qaqc.points%>%filter(forwards.image.name%in%c("NA",NA))%>%filter(forwards.points.no.annotations%in%c("NA",NA)) # ok because failed deployments
backwards.points.missing.image.not.annotated <- qaqc.points%>%filter(backwards.image.name%in%c("NA",NA))%>%filter(backwards.points.no.annotations%in%c("NA",NA))

# Find samples where image is exported but missing annotations:
forwards.points.missing.annotation <- qaqc.points%>%filter(!forwards.image.name%in%c("NA",NA))%>%filter(forwards.points.no.annotations%in%c("NA",NA))
backwards.points.missing.annotation <- qaqc.points%>%filter(!backwards.image.name%in%c("NA",NA))%>%filter(backwards.points.no.annotations%in%c("NA",NA))

# Find samples annotated but missing images:
forwards.points.missing.image <- qaqc.points%>%filter(forwards.image.name%in%c("NA",NA))%>%filter(!forwards.points.no.annotations%in%c("NA",NA))
backwards.points.missing.image <- qaqc.points%>%filter(backwards.image.name%in%c("NA",NA))%>%filter(!backwards.points.no.annotations%in%c("NA",NA))

setwd(error.dir)
dir()

write.csv(qaqc.points, paste(study,"random-points","images-and-annotations-missing.csv",sep="_"),row.names=FALSE) 

# read in grid annotations ----
setwd(tm.export.dir)
dir()

habitat.forwards.grid <- read.delim("2020-06_south-west_stereo-BRUVs_grid_forwards_Dot Point Measurements.txt",header=T,skip=4,stringsAsFactors=FALSE) %>% # read in the file
  ga.clean.names() %>% # tidy the column names using GlobalArchive function
  mutate(sample=str_replace_all(.$filename,c(".png"="",".jpg"="",".JPG"=""," take 2"=""))) %>%
  mutate(sample=as.character(sample)) %>% # in this example dataset, the samples are numerical
  select(sample,image.row,image.col,broad,morphology,type,fieldofview,relief) %>% # select only these columns to keep
  glimpse() # preview

forwards.grid.no.annotations <- habitat.forwards.grid%>%
  group_by(sample)%>%
  summarise(forwards.grid.no.annotations=n()) # good

habitat.backwards.grid <- read.delim("2020-06_south-west_stereo-BRUVs_grid_backwards_Dot Point Measurements.txt",header=T,skip=4,stringsAsFactors=FALSE) %>% # read in the file
  ga.clean.names() %>% # tidy the column names using GlobalArchive function
  mutate(sample=str_replace_all(.$filename,c(".png"="",".jpg"="",".JPG"="","1.1"="1","2.1"="2","3.1"="3","4.1"="4","5.1"="5","6.1"="6","7.1"="7","8.1"="8","9.1"="9","0.1"="0"))) %>%
  mutate(sample=as.character(sample)) %>% # in this example dataset, the samples are numerical
  select(sample,image.row,image.col,broad,morphology,type,fieldofview,relief) %>% # select only these columns to keep
  mutate(sample=str_pad(sample,width = 2, side = "left", pad = "0")) %>%
  glimpse() # preview

backwards.grid.no.annotations <- habitat.backwards.grid%>%
  group_by(sample)%>%
  summarise(backwards.grid.no.annotations=n()) # good

# Create checking dataframe ----
qaqc.grid <- metadata %>%
  dplyr::select(sample, date) %>%
  dplyr::left_join(forwards.list)%>%
  dplyr::left_join(forwards.grid.no.annotations)%>%
  dplyr::left_join(backwards.list)%>%
  dplyr::left_join(backwards.grid.no.annotations)%>%
  glimpse()

# Find samples where images and annotations are missing:
forwards.grid.missing.image.not.annotated <- qaqc.grid%>%filter(forwards.image.name%in%c("NA",NA))%>%filter(forwards.grid.no.annotations%in%c("NA",NA))
backwards.grid.missing.image.not.annotated <- qaqc.grid%>%filter(backwards.image.name%in%c("NA",NA))%>%filter(backwards.grid.no.annotations%in%c("NA",NA))

# Find samples where image is exported but missing annotations:
forwards.grid.missing.annotation <- qaqc.grid%>%filter(!forwards.image.name%in%c("NA",NA))%>%filter(forwards.grid.no.annotations%in%c("NA",NA))
backwards.grid.missing.annotation <- qaqc.grid%>%filter(!backwards.image.name%in%c("NA",NA))%>%filter(backwards.grid.no.annotations%in%c("NA",NA))

# Find samples annotated but missing images:
forwards.grid.missing.image <- qaqc.grid%>%filter(forwards.image.name%in%c("NA",NA))%>%filter(!forwards.grid.no.annotations%in%c("NA",NA))
backwards.grid.missing.image <- qaqc.grid%>%filter(backwards.image.name%in%c("NA",NA))%>%filter(!backwards.grid.no.annotations%in%c("NA",NA))

setwd(error.dir)
dir()

write.csv(qaqc.grid, paste(study,"grid","images-and-annotations-missing.csv",sep="_"),row.names=FALSE)  

# Compare grids and random-points
qaqc.all <- metadata %>%
  dplyr::select(sample, date) %>%
  dplyr::left_join(forwards.list)%>%
  dplyr::left_join(forwards.points.no.annotations)%>%
  dplyr::left_join(forwards.grid.no.annotations)%>%
  dplyr::left_join(backwards.list)%>%
  dplyr::left_join(backwards.points.no.annotations)%>%
  dplyr::left_join(backwards.grid.no.annotations)%>%
  glimpse()

forwards.points.not.grid <- qaqc.all %>%
  filter(!forwards.points.no.annotations%in%c("NA",NA))%>%
  filter(forwards.grid.no.annotations%in%c("NA",NA)) # NONE = good

backwards.points.not.grid <- qaqc.all %>%
  filter(!backwards.points.no.annotations%in%c("NA",NA))%>%
  filter(backwards.grid.no.annotations%in%c("NA",NA)) # NONE = good

forwards.grid.not.points <- qaqc.all %>%
  filter(forwards.points.no.annotations%in%c("NA",NA))%>%
  filter(!forwards.grid.no.annotations%in%c("NA",NA)) # 2 = not good

backwards.grid.not.points <- qaqc.all %>%
  filter(backwards.points.no.annotations%in%c("NA",NA))%>%
  filter(!backwards.grid.no.annotations%in%c("NA",NA)) # 3 = not good


### USE THIS ONLY ONCE ###
setwd("C:/GitHub/SWC gits/mac-swc/data/raw/habitat checking")

dir()

labsheet <- read.csv("MEG_Labsheets_2021 - 2020-10_south-west_BOSS.csv")

names(qaqc)

annotated <- qaqc%>%
  
  dplyr::rename(forwards.habitat.forwards.exported = forwards.image.name)%>%
  dplyr::rename(forwards.habitat.backwards.exported = backwards.image.name)%>%
  
  dplyr::rename(forwards.habitat.forwards.annotated = forwards.points.annotated)%>%
  dplyr::rename(forwards.habitat.backwards.annotated = backwards.points.annotated)%>%
  
  dplyr::select(-c(date))%>%
  
  dplyr::mutate(forwards.habitat.forwards.exported = ifelse(!forwards.habitat.forwards.exported%in%c(NA),"Yes",NA)) %>%
  dplyr::mutate(forwards.habitat.backwards.exported = ifelse(!forwards.habitat.backwards.exported%in%c(NA),"Yes",NA)) %>%
  
  dplyr::mutate(forwards.habitat.forwards.annotated = ifelse(!forwards.habitat.forwards.annotated%in%c(NA),"Yes",NA)) %>%
  dplyr::mutate(forwards.habitat.backwards.annotated = ifelse(!forwards.habitat.backwards.annotated%in%c(NA),"Yes",NA)) %>%
  
  dplyr::rename(Sample = sample) %>%
  
  glimpse()


join <- left_join(labsheet,annotated)  

write.csv(join,"new-labsheet.csv",row.names = FALSE)


# Create %fov----
fov.points <- habitat%>%
  dplyr::select(-c(broad,morphology,type,relief))%>%
  dplyr::filter(!fieldofview=="")%>%
  dplyr::filter(!is.na(fieldofview))%>%
  dplyr::mutate(fieldofview=paste("fov",fieldofview,sep = "."))%>%
  dplyr::mutate(count=1)%>%
  spread(key=fieldofview,value=count, fill=0)%>%
  dplyr::select(-c(image.row,image.col))%>%
  dplyr::group_by(sample)%>%
  dplyr::summarise_all(list(sum))%>%
  dplyr::mutate(fov.total.points.annotated=rowSums(.[,2:(ncol(.))],na.rm = TRUE ))%>%
  ga.clean.names()

fov.percent.cover<-fov.points %>%
  group_by(sample)%>%
  mutate_at(vars(starts_with("fov")),funs(./fov.total.points.annotated*100))%>%
  dplyr::select(-c(fov.total.points.annotated))%>%
  glimpse()


# Create broad point annotations ----
broad.points <- habitat%>%
  dplyr::select(-c(fieldofview,morphology,type,relief))%>%
  filter(!broad%in%c("",NA,"Unknown","Open.Water","Open Water"))%>%
  dplyr::mutate(broad=paste("broad",broad,sep = "."))%>%
  dplyr::mutate(count=1)%>%
  dplyr::group_by(sample)%>%
  tidyr::spread(key=broad,value=count,fill=0)%>%
  dplyr::select(-c(image.row,image.col))%>%
  dplyr::group_by(sample)%>%
  dplyr::summarise_all(funs(sum))%>%
  dplyr::mutate(broad.total.points.annotated=rowSums(.[,2:(ncol(.))],na.rm = TRUE ))%>%
  ga.clean.names()%>%
  glimpse

# Create broad percent cover ----
broad.percent.cover<-broad.points %>%
  group_by(sample)%>%
  mutate_at(vars(starts_with("broad")),funs(./broad.total.points.annotated*100))%>%
  dplyr::select(-c(broad.total.points.annotated))%>%
  glimpse()


# Create  detailed point annotations ----
detailed.points <- habitat%>%
  dplyr::select(-c(fieldofview, relief))%>%
  dplyr::filter(!morphology%in%c("",NA,"Unknown"))%>%
  dplyr::filter(!broad%in%c("",NA,"Unknown","Open.Water"))%>%
  dplyr::mutate(morphology=paste("detailed",broad,morphology,type,sep = "."))%>%
  dplyr::mutate(morphology=str_replace_all(.$morphology, c(".NA"="","[^[:alnum:] ]"="."," "="","10mm.."="10mm.")))%>%
  dplyr::select(-c(broad,type))%>%
  dplyr::mutate(count=1)%>%
  dplyr::group_by(sample)%>%
  spread(key=morphology,value=count,fill=0)%>%
  dplyr::select(-c(image.row,image.col))%>%
  dplyr::group_by(sample)%>%
  dplyr::summarise_all(funs(sum))%>%
  dplyr::mutate(detailed.total.points.annotated=rowSums(.[,2:(ncol(.))],na.rm = TRUE ))%>%
  ga.clean.names()%>%
  glimpse()

# Create detailed percent cover ----
detailed.percent.cover<-detailed.points %>%
  group_by(sample)%>%
  mutate_at(vars(starts_with("detailed")),funs(./detailed.total.points.annotated*100))%>%
  dplyr::select(-c(detailed.total.points.annotated))%>%
  glimpse()

# Create relief----
relief.grid<-habitat%>%
  dplyr::filter(!broad%in%c("Open Water","Unknown"))%>%
  dplyr::filter(!relief%in%c("",NA))%>%
  dplyr::select(-c(broad,morphology,type,fieldofview,image.row,image.col))%>%
  dplyr::mutate(relief.rank=ifelse(relief==".0. Flat substrate, sandy, rubble with few features. ~0 substrate slope.",0,
                                   ifelse(relief==".1. Some relief features amongst mostly flat substrate/sand/rubble. <45 degree substrate slope.",1,
                                          ifelse(relief==".2. Mostly relief features amongst some flat substrate or rubble. ~45 substrate slope.",2,
                                                 ifelse(relief==".3. Good relief structure with some overhangs. >45 substrate slope.",3,
                                                        ifelse(relief==".4. High structural complexity, fissures and caves. Vertical wall. ~90 substrate slope.",4,
                                                               ifelse(relief==".5. Exceptional structural complexity, numerous large holes and caves. Vertical wall. ~90 substrate slope.",5,relief)))))))%>%
  dplyr::select(-c(relief))%>%
  dplyr::mutate(relief.rank=as.numeric(relief.rank))%>%
  dplyr::group_by(sample)%>%
  dplyr::summarise(mean.relief= mean (relief.rank), sd.relief= sd (relief.rank))%>%
  dplyr::ungroup()%>%
  glimpse()


# Write final habitat data----
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

write.csv(habitat.broad.points,file=paste(study,"random-points_broad.habitat.csv",sep = "_"), row.names=FALSE)
write.csv(habitat.detailed.points,file=paste(study,"random-points_detailed.habitat.csv",sep = "_"), row.names=FALSE)


write.csv(habitat.broad.percent,file=paste(study,"random-points_percent-cover_broad.habitat.csv",sep = "_"), row.names=FALSE)
write.csv(habitat.detailed.percent,file=paste(study,"random-points_percent-cover_detailed.habitat.csv",sep = "_"), row.names=FALSE)
