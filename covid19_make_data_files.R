zcta_data <- getCensus(name = "acs/acs5",
                       vintage = 2018,
                       vars = c("NAME", "B19013_001E", "B01003_001E", "B02001_001E", "B02001_002E",
                                "B01001_002E", "B01001_026E", "B01002_001E", "B01002_002E",
                                "B01002_003E", "B20017_002E", "B20017_005E"),
                       region = paste0("zip code tabulation area:",nyc_zipcode_string),
                       key=myKey)

bor_data <- getCensus(name = "acs/acs5",
                      vintage = 2018,
                      vars = c("NAME", "B20017_001E", "B01003_001E", "B02001_001E", "B02001_002E",
                               "B01001_002E", "B01001_026E", "B01002_001E", "B01002_002E",
                               "B01002_003E", "B20017_002E", "B20017_005E"),
                      region = "county:005,047,061,081,085",
                      regionin = "state:36",
                      key=myKey)

zcta_college_hh <- getCensus(name = "acs/acs5",
                             vintage = 2018,
                             vars = c("B15003_022E", "B15003_023E", "B15003_024E",
                                      "B15003_025E", "B15003_001E",
                                      "B08201_007E", "B08201_013E", "B08201_019E", "B08201_025E"),
                             region = paste0("zip code tabulation area:",nyc_zipcode_string),
                             key = myKey)

# give variable names
names(zcta_college_hh) = c("zipcode", "Bachelors", "Masters", "Professional", "Doctorate",
                           "TotalPop", "HH1pers", "HH2pers", "HH3pers", "HH4plus")

# create the Bach_plus Other category
zcta_edu_hh <- zcta_college_hh %>%
  mutate(Bach_plus_prop =
           round((Bachelors+Masters+Professional+Doctorate)/TotalPop,3)*100)
# create the average household size variable
zcta_edu_hh <- zcta_edu_hh %>%
  mutate(AvgHH = (HH1pers+2*HH2pers+3*HH3pers+4*HH4plus)/(HH1pers+HH2pers+HH3pers+HH4plus))



filepath <- "Shape_Files/ZIP_CODE_040114.shp"
NYC_zips <- readOGR(filepath, stringsAsFactors = F)
#get zip to borough
zip_bor <- read.csv("data/zip_borough.csv")

#get zipcodes from shape file
shpcodes <- NYC_zips@data$ZIPCODE %>% as.character %>% as.numeric

#now join these zip codes with the other data
dat <- data.frame(MODZCTA = shpcodes)
dat <- dplyr::left_join(dat, na.omit(cases), by="MODZCTA")
zcta_data$zip_code_tabulation_area <- as.numeric(zcta_data$zip_code_tabulation_area)
dat <- dplyr::left_join(dat, zcta_data,
                        by = c("MODZCTA" = "zip_code_tabulation_area"))
dat <- dplyr::left_join(dat, zip_bor, by=c("MODZCTA" = "zip"))
dat$borough[which(dat$MODZCTA==10065)] <- "Manhattan"
dat$borough[which(dat$MODZCTA==10075)] <- "Manhattan"

case_bor <- dat %>%
  group_by(borough) %>%
  summarize(numcases = sum(Positive, na.rm=T), numtests = sum(Total, na.rm=T))

bor_data$Positive <- case_bor$numcases[c(4,2,3,5,1)]
bor_data$Tests <- case_bor$numtests[c(4,2,3,5,1)]

zcta_race_proportion$zipcode <- as.numeric(as.character(zcta_race_proportion$zipcode))
zcta_coll_hh$zipcode <- as.numeric(zcta_coll_hh$zipcode)
tmp2 <- dplyr::left_join(tmp, zcta_race_proportion,
                         by = c("MODZCTA" = "zipcode"))
tmp2 <- dplyr::left_join(tmp2, zcta_coll_hh,
                         by = c("MODZCTA" = "zipcode"))
tmp2 <- tmp2[,-5]

write.csv(tmp2, "data/coronavirus-nyc/zipcode_vars.csv", row.names = F)
zipdata <- read.csv("data/coronavirus-nyc/zipcode_vars.csv")
zipdata2 <- zipdata[!duplicated(shpcodes),]
