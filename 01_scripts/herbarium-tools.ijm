// Herbarium Specimen Measurement Macro
var specimen_id = "";

// Validate specimen ID
function validateSpecimenID(id) {
    if (id == "") {
        showMessage("Error", "Invalid Specimen ID. Please enter a valid ID.");
        return false;
    }
    return true;
}

macro "Initialize New Specimen [F1]" {
    // Show labeling instructions
    showMessage("Herbarium Macro", "✿ Welcome to herbarium tools! ✿"); 

    // Open font configuration window
    run("Fonts...");
    waitForUser("Font Settings", "Please configure your text settings in the Fonts window,\nthen click OK to continue.");
        
    waitForUser("Labeling", 
        "1. Label the internodes, starting from the most lateral to most medial internode\n" +
        "   using i1, i2, i3, etc.\n\n" +
        "2. Label the leaves, starting from bottom right and moving clockwise\n" +
        "   using L1, L2, L3, etc.\n\n" +
        "Click OK when you're done labeling to continue with measurements.");

    // Get specimen ID
    specimen_id = getString("Enter specimen catalog number", "");
    
    // Validate specimen ID
    while (!validateSpecimenID(specimen_id)) {
        specimen_id = getString("Enter specimen catalog number", "");
    }
    
    // Set scale
    Dialog.create("Set Scale");
    Dialog.addNumber("Known distance:", 1);
    Dialog.addString("Unit:", "cm");
    Dialog.show();
    
    distance = Dialog.getNumber();
    unit = Dialog.getString();
    
    // User draws line for scale
    setTool("line");
    waitForUser("Set Scale", "Draw line of " + distance + " " + unit + " on scale bar\nThen click OK");
    run("Set Scale...", "known=" + distance + " unit=" + unit);
    
    run("Clear Results");
    
    // Create Basic Measurements table
    run("New... ", "name=BasicMeasures width=800 height=400");
    print("[BasicMeasures]", "\\Headings:specimen_id\tplant_height\troot_length\tinternode_1\tinternode_2\tinternode_3");
    print("[BasicMeasures]", specimen_id + "\t\t\t\t\t");
    
    // Create Leaf Measurements table
    run("New... ", "name=LeafMeasures width=800 height=400");
    print("[LeafMeasures]", "\\Headings:leaf_number\tnode_type\tleaf_area\tpetiole_width");
    
    // Create Herbivory table
    run("New... ", "name=HerbivoryMeasures width=800 height=400");
    print("[HerbivoryMeasures]", "\\Headings:leaf_number\tDT_number\tdamage_type\tarea");
}

macro "Record Plant Height [h]" {
    if (nResults < 1) {
        showMessage("Error", "Make a measurement first");
        return;
    }
    value = getResult("Length", nResults-1);
    
    content = getInfo("[BasicMeasures]");
    lines = split(content, "\n");
    if (lines.length < 2) {
        print("[BasicMeasures]", specimen_id + "\t" + value + "\t\t\t\t");
    } else {
        values = split(lines[1], "\t");
        values[1] = value;
        print("[BasicMeasures]", "\\Clear");
        print("[BasicMeasures]", lines[0]);
        print("[BasicMeasures]", String.join(values, "\t"));
    }
    run("Clear Results");
}

macro "Record Root Length [r]" {
    if (nResults < 1) {
        showMessage("Error", "Make a measurement first");
        return;
    }
    value = getResult("Length", nResults-1);
    
    content = getInfo("[BasicMeasures]");
    lines = split(content, "\n");
    if (lines.length < 2) {
        print("[BasicMeasures]", specimen_id + "\t\t" + value + "\t\t\t");
    } else {
        values = split(lines[1], "\t");
        values[2] = value;
        print("[BasicMeasures]", "\\Clear");
        print("[BasicMeasures]", lines[0]);
        print("[BasicMeasures]", String.join(values, "\t"));
    }
    run("Clear Results");
}

macro "Record Internode [i]" {
    if (nResults < 1) {
        showMessage("Error", "Make a measurement first");
        return;
    }
    Dialog.create("Internode Selection");
    Dialog.addChoice("Which internode?", newArray("1", "2", "3"));
    Dialog.show();
    
    choice = Dialog.getChoice();
    value = getResult("Length", nResults-1);
    
    content = getInfo("[BasicMeasures]");
    lines = split(content, "\n");
    if (lines.length < 2) {
        row = specimen_id + "\t\t\t";
        for (i=0; i<3; i++) {
            if (i == (parseInt(choice)-1))
                row = row + value + "\t";
            else
                row = row + "\t";
        }
        print("[BasicMeasures]", row);
    } else {
        values = split(lines[1], "\t");
        values[parseInt(choice)+2] = value;
        print("[BasicMeasures]", "\\Clear");
        print("[BasicMeasures]", lines[0]);
        print("[BasicMeasures]", String.join(values, "\t"));
    }
    run("Clear Results");
}

macro "Record Leaf Measurement [l]" {
    if (nResults < 1) {
        showMessage("Error", "Make a measurement first");
        return;
    }
    
    Dialog.create("Leaf Measurement");
    Dialog.addNumber("Leaf Number (1-5):", 1);
    Dialog.addChoice("Measurement Type:", newArray("leaf_area", "petiole_width"));
    Dialog.addChoice("Node Type:", newArray("terminal", "lateral"));
    Dialog.show();
    
    leaf_num = Dialog.getNumber();
    meas_type = Dialog.getChoice();
    node_type = Dialog.getChoice();
    
    value = getResult("Area", nResults-1);
    if (meas_type == "petiole_width")
        value = getResult("Length", nResults-1);
        
    if (meas_type == "leaf_area")
        print("[LeafMeasures]", leaf_num + "\t" + node_type + "\t" + value + "\t");
    else
        print("[LeafMeasures]", leaf_num + "\t" + node_type + "\t\t" + value);
    
    run("Clear Results");
}

macro "Record Herbivory [v]" {
    if (nResults < 1) {
        showMessage("Error", "Make a measurement first");
        return;
    }
    
    Dialog.create("Herbivory Measurement");
    Dialog.addNumber("Leaf Number (1-5):", 1);
    Dialog.addNumber("DT Number:", 29);
    Dialog.addChoice("Damage Type:", newArray("margin", "hole", "skeleton", "surface"));
    Dialog.show();
    
    leaf_num = Dialog.getNumber();
    dt_number = Dialog.getNumber();
    damage_type = Dialog.getChoice();
    value = getResult("Area", nResults-1);
    
    print("[HerbivoryMeasures]", leaf_num + "\t" + dt_number + "\t" + damage_type + "\t" + value);
    run("Clear Results");
}

macro "Save All Tables [s]" {
    if (specimen_id == "") {
        showMessage("Error", "No specimen ID. Initialize measurement first.");
        return;
    }
    
    // Create directory
    dir = getDirectory("Choose a base directory for saving");
    if (dir == "") return;
    
    folder = dir + specimen_id + "_measurements" + File.separator;
    File.makeDirectory(folder);
    
    // Save Basic Measurements
    selectWindow("BasicMeasures");
    saveAs("Text", folder + specimen_id + "_basic.csv");
    
    // Save Leaf Measurements
    selectWindow("LeafMeasures");
    saveAs("Text", folder + specimen_id + "_leaves.csv");
    
    // Save Herbivory Measurements
    selectWindow("HerbivoryMeasures");
    saveAs("Text", folder + specimen_id + "_herbivory.csv");
    
    // Save the edited image as TIFF with annotations
    if (nImages > 0) {
        // Get the active image title
        title = getTitle();
        // Flatten the image to make annotations permanent
        run("Flatten");
        // Save as TIFF with specimen ID
        saveAs("Tiff", folder + specimen_id + "_annotated.tif");
        // Close the flattened copy
        close();
        // Select the original image again
        selectWindow(title);
    } else {
        showMessage("Warning", "No image open to save!");
    }
    
    showMessage("Success", "All tables and annotated image saved to: " + folder);
}

// Clear all measurements
macro "Clear All [F12]" {
    run("Clear Results");
    print("[BasicMeasures]", "\\Clear");
    print("[LeafMeasures]", "\\Clear");
    print("[HerbivoryMeasures]", "\\Clear");
    print("[BasicMeasures]", "\\Headings:specimen_id\tplant_height\troot_length\tinternode_1\tinternode_2\tinternode_3");
    print("[LeafMeasures]", "\\Headings:leaf_number\tnode_type\tleaf_area\tpetiole_width");
    print("[HerbivoryMeasures]", "\\Headings:leaf_number\tDT_number\tdamage_type\tarea");
    
    if (specimen_id != "")
        print("[BasicMeasures]", specimen_id + "\t\t\t\t\t");
}