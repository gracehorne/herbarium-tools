
# required packages
library(tidyverse)
library(purrr)
library(here)

# function to process data
process_specimen_data <- function(folder_path) {
  # get list of files in folder
  files <- list.files(folder_path, full.names = TRUE)
  
  # initialize empty lists
  basic_list <- list()
  leaves_list <- list()
  herbivory_list <- list()
  
  # get unique specimen ids from filenames
  specimen_ids <- files %>%
    basename() %>%
    str_extract("^[^_]+") %>%
    unique()
  
  # process each specimen
  for(id in specimen_ids) {
    # construct file paths
    basic_file <- file.path(folder_path, paste0(id, "_basic.csv"))
    leaves_file <- file.path(folder_path, paste0(id, "_leaves.csv"))
    herbivory_file <- file.path(folder_path, paste0(id, "_herbivory.csv"))
    
    # process basic data
    if(file.exists(basic_file)) {
      basic_data <- read_csv(basic_file) %>%
        group_by(specimen_id) %>%
        summarise(
          plant_height = first(na.omit(plant_height)),
          root_length = first(na.omit(root_length)),
          internode_1 = first(na.omit(internode_1)),
          internode_2 = first(na.omit(internode_2)),
          internode_3 = first(na.omit(internode_3))
        ) %>%
        filter(!is.na(specimen_id))
      
      basic_list[[id]] <- basic_data
    }
    
    # process leaves data
    if(file.exists(leaves_file)) {
      leaves_data <- read_csv(leaves_file) %>%
        group_by(leaf_number, node_type) %>%
        summarise(
          leaf_area = first(na.omit(leaf_area)),
          petiole_width = first(na.omit(petiole_width)),
          .groups = 'drop'
        ) %>%
        filter(!is.na(leaf_number))
      
      leaves_list[[id]] <- leaves_data
    }
    
    # process herbivory data (assuming similar structure)
    if(file.exists(herbivory_file)) {
      herbivory_data <- read_csv(herbivory_file)
      herbivory_list[[id]] <- herbivory_data
    }
  }
  
  # return all lists
  return(list(
    basic = basic_list,
    leaves = leaves_list,
    herbivory = herbivory_list
  ))
}

# assuming your folders are in a parent directory/the project directory
parent_dir <- here::here()
folder_paths <- list.files(parent_dir, full.names = TRUE)

# process all folders
all_results <- map(folder_paths, process_specimen_data) %>%
  # combine results across folders
  reduce(function(x, y) {
    list(
      basic = c(x$basic, y$basic),
      leaves = c(x$leaves, y$leaves),
      herbivory = c(x$herbivory, y$herbivory)
    )
  })

# access results like this:
all_results$basic$AHUC103135  # gets basic data for specimen AHUC103135
all_results$leaves$AHUC103135 # gets leaves data for specimen AHUC103135
all_results$herbivory$AHUC103135 # gets herbivory data for specimen AHUC103135
