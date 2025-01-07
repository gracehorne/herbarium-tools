# herbarium-tools

Herbarium tools for ImageJ/Fiji. This readme file was generated on
2025-01-07 by Grace Horne.

### Initial Setup

1.  Copy the macro file to the Fiji toolsets folder:

```{bash}
/Applications/Fiji.app/macros/toolsets/herbarium-tools.ijm
```

2.  Launch Fiji/ImageJ
3.  To load the toolset for your session:
    -   Click on the "\>\>" symbol in the ImageJ toolbar

    -   Select "herbarium-tools" from the dropdown menu

### Using the Tool Step 1: Initialize New Specimen (`F1`)

1.  Press F1 or click "Initialize New Specimen" to start
2.  Configure your font settings in the popup window
3.  Follow the labeling instructions for internodes and leaves:
    -   Label internodes from lateral to medial using i1, i2, i3

    -   Label leaves starting from bottom right, clockwise using L1, L2,
        L3
4.  Enter the specimen catalog number when prompted
5.  Set the scale:
    -   Enter the known distance (default is 10mm)

    -   Draw a line on the scale bar in the image

    -   Click OK to set the scale

### Step 2: Taking Measurements

Use these keyboard shortcuts to record different measurements:

-   `h` - Record plant height

-   `r` - Record root length

-   `i` - Record internode length

    -   Select which internode (1-3) from the dropdown menu

-   `l` - Record leaf measurements

    -   Enter leaf number (1-5)

    -   Choose measurement type (leaf area or petiole width)

    -   Select node type (terminal or lateral)

-   `v` - Record herbivory damage

    -   Enter leaf number (1-5)

    -   Enter DT (damage type) number

    -   Select damage type (margin, hole, skeleton, or surface)

### Step 4: Saving Your Work (`s`)

1.  Press `s` or click "Save All Tables"
2.  Choose a base directory for saving
3.  The tool will create a new folder named `[specimen_id]_measurements`
    containing:
    -   `[specimen_id]_basic.csv` (basic measurements)

    -   `[specimen_id]_leaves.csv` (leaf measurements)

    -   `[specimen_id]_herbivory.csv` (herbivory measurements)

    -   `[specimen_id]_annotated.tif` (annotated image)

### Step 5: Processing Data with R

1.  Save the R script as `herbarium-tools_process-data.R` in your
    project directory

2.  Ensure you have the required R packages installed:

    ``` r
    install.packages(c("tidyverse", "purrr", "here"))
    ```

3.  Organize your measurement folders:

    -   Ensure all specimen measurement folders (e.g.,
        `AHUC103135_measurements/`) are in a single parent directory
    -   Each folder should contain the CSV files generated in Step 4

4.  Run the R script to process the data:

    -   The script will read and combine data from all specimen folders

    -   Access the processed data using the specimen ID:

        ``` r
        # Example for specimen AHUC103135
        all_results$basic$AHUC103135    # basic measurements
        all_results$leaves$AHUC103135   # leaf measurements
        all_results$herbivory$AHUC103135 # herbivory measurements
        ```

The script will:

-   Combine measurements across all specimens

-   Handle missing values

-   Group and summarize measurements by specimen

-   Create a nested list structure for easy data access

-   Process all three measurement types (basic, leaves, and herbivory)

### Additional Features

-   Press F12 to clear all measurements and start over

-   All measurements are stored in three separate tables:

    -   Basic Measures: plant height, root length, and internodes

    -   Leaf Measures: leaf areas and petiole widths

    -   Herbivory Measures: damage types and areas

------------------------------------------------------------------------

### General Information

Author/Principal Investigator Information

Name: Grace Horne

ORCID: 0000-0001-9836-7123

Institution: University of California, Davis

Address: 458 Hutchison Hall, Department of Entomology and Nematology,
University of California, Davis, Davis, California, USA

Email: gmhorne\@ucdavis.edu

Information about funding sources that supported the collection of the
data: None

### Sharing/Access Information

Recommended citation: NA

### Data & File Overview

File List:

-   01_scripts \> herbarium-tools.ijm - macro for ImageJ/Fiji

-   01_scripts \> herbarium-tools_process-data.R - data wrangling

-   02_example-specimens - folder with example specimen images

Relationship between files, if important: NA

### Methodological Information

Instrument- or software-specific information needed to interpret the
data:

-   Software - R version 4.4.0
-   Libraries - tidyverse, purrr, here

### Data-Specific Information for Resulting Spreadsheets

**Name:** `[specimen_id]_basic.csv` (basic measurements)

**Variable List:**

`specimen_id` - catalog number

`plant_height` - total height of plant in mm

`root_length` - length of root system in mm

`internode_1` - length of first internode in mm

`internode_2` - length of second internode in mm

`internode_3` - length of third internode in mm

**Name:** `[specimen_id]_leaves.csv` (leaf measurements)

**Variable List:**

`leaf_number` - identifier for leaf (1-5)

`node_type` - position of leaf node ("terminal" or "lateral")

`leaf_area` - total area of leaf in mm²

`petiole_width` - width of leaf petiole in mm

**Name:** `[specimen_id]_herbivory.csv` (herbivory measurements)

**Variable List:**

`leaf_number` - identifier for leaf with damage (1-5)

`DT_number` - damage type classification number

`damage_type` - category of damage ("margin", "hole", "skeleton", or
"surface")

`area` - area of damage in mm²

Missing data codes: `NA`

Specialized formats or other abbreviations used: None
