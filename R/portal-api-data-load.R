# Hakai Data Portal API and data loading
## This script needs to be run independently, prior to
## `seagrass-fish-inverts.Rmd` in order to connect to the
## data portal, and save the input data that will be used
## for the package
## NOTE: this script only needs to run once (or when the
##       datasets are updated) for each package version

# To install the hakaiApi package, visit the 
# [hakai-api-client-r](https://github.com/HakaiInstitute/hakai-api-client-r)
# github repository and follow the install instructions in the README.

# load hakaiApi package
library(hakaiApi)

Client$remove_old_credentials()  # cached credentials can sometimes cause problems
client <- hakaiApi::Client$new() # Follow stdout prompts to get an API token

# download fish data from portal
fish <- client$get(sprintf("%s/%s", client$api_root,
                           "eims/views/output/mg_fish?limit=-1")) %T>%
  glimpse()

# download invert data
inverts <- client$get(sprintf("%s/%s", client$api_root,
                              "eims/views/output/mg_inverts?limit=-1")) %T>%
  glimpse()

# download events data - this will be use to QC fish and invert
#   for completeness
events <- client$get(sprintf("%s/%s", client$api_root,
                             "eims/views/output/events?limit=-1")) %>%
  # remove non-seagrass events
  filter(survey %in% c("PRUTH_BAY",
                       "PRUTH BAY",
                       "CHOKED PASS",
                       "CHOKED_PASS",
                       "TRIQUET_NORTH",
                       "TRIQUET_BAY",
                       "GOOSE_SOUTHEAST",
                       "GOOSE_SOUTHWEST",
                       "MCMULLIN_SOUTH",
                       "MCMULLIN_NORTH",
                       "KOEYE_ESTUARY",
                       "KOEYE_ESTUARY ESTUARY",
                       "KOEYE_ESTUARY_ESTUARY")) %T>%
  glimpse()


# Once all data appears correct, save in /raw-data directory
write.csv(fish, "raw-data/seagrass_fish.csv")
write.csv(inverts, "raw-data/seagrass_inverts.csv")
write.csv(events, "raw-data/seagrass_events.csv")
