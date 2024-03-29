### -*- Mode: Julia -*-

### SOPHYSM - SOlid tumors PHYlogenetic Spatial Modeller.
### SOPHYSM.jl
### Julia GUI for Histological Analysis and Cancer Simulation

module SOPHYSM

### Packages
using Gtk
using JHistint
using J_Space

### Exported Functions
export start_GUI

function start_GUI()
    ### Data from SOPHYSM.glade
    filepath_glade = joinpath(@__DIR__, "..", "src", "SOPHYSM.glade")
    SOPHYSM_app = GtkBuilder(filename = filepath_glade)
    mainWindow = SOPHYSM_app["mainWindow"]
    thresholdDialog = SOPHYSM_app["thresholdDialog"]
    newProjectDialog = SOPHYSM_app["newProjectDialog"]
    projectAlreadyExistMessage = SOPHYSM_app["projectAlreadyExistMessage"]
    invalidNameProjectMessage = SOPHYSM_app["invalidNameProjectMessage"]
    slideAlreadyExistMessage = SOPHYSM_app["slideAlreadyExistMessage"]
    thresholdErrorMessage = SOPHYSM_app["thresholdErrorMessage"]
    chooseCollectionDialog = SOPHYSM_app["chooseCollectionDialog"]
    jspaceOutputDialog = SOPHYSM_app["jspaceOutputDialog"]
    ## menuBar
    newProjectMenuItem = SOPHYSM_app["newProjectMenuItem"]
    loadProjectMenuItem = SOPHYSM_app["loadProjectMenuItem"]
    closeProjectMenuItem = SOPHYSM_app["closeProjectMenuItem"]
    quitMenuItem = SOPHYSM_app["quitMenuItem"]
    loadImageMenuItem = SOPHYSM_app["loadImageMenuItem"]
    workspaceMenuItem = SOPHYSM_app["workspaceMenuItem"]
    downloadSingleCollectionMenuItem = SOPHYSM_app["downloadSingleCollectionMenuItem"]
    downloadAllCollectionMenuItem = SOPHYSM_app["downloadAllCollectionMenuItem"]
    ## ProjectBox
    workspacePositionLabel = SOPHYSM_app["workspacePositionLabel"]
    descriptionLabel = SOPHYSM_app["descriptionLabel"]
    segmentationButton = SOPHYSM_app["segmentationButton"]
    tessellationButton = SOPHYSM_app["tessellationButton"]
    simulationButton = SOPHYSM_app["simulationButton"]
    loadButton = SOPHYSM_app["loadButton"]
    ## ResultBox
    selectedImage = SOPHYSM_app["selectedImage"]
    segmentedImage = SOPHYSM_app["segmentedImage"]
    graphVertexImage = SOPHYSM_app["graphVertexImage"]
    graphEdgesImage = SOPHYSM_app["graphEdgesImage"]
    tessCellImage = SOPHYSM_app["tessCellImage"]
    tessTotalImage = SOPHYSM_app["tessTotalImage"]
    thresholdGreyscaleValueLabel = SOPHYSM_app["thresholdGreyscaleValueLabel"]
    thresholdMarkersValueLabel = SOPHYSM_app["thresholdMarkersValueLabel"]
    thresholdMinValueLabel = SOPHYSM_app["thresholdMinValueLabel"]
    thresholdMaxValueLabel = SOPHYSM_app["thresholdMaxValueLabel"]
    ## thresholdDialog
    thresholdOkButton = SOPHYSM_app["thresholdOkButton"]
    thresholdCancelButton = SOPHYSM_app["thresholdCancelButton"]
    defaultSettingsButton = SOPHYSM_app["defaultSettingsButton"]
    thresholdGreyscaleEntry = SOPHYSM_app["thresholdGreyscaleEntry"]
    thresholdMarkersEntry = SOPHYSM_app["thresholdMarkersEntry"]
    thresholdMinEntry = SOPHYSM_app["thresholdMinEntry"]
    thresholdMaxEntry = SOPHYSM_app["thresholdMaxEntry"]
    # invalidThresholdMessage
    thresholdErrorCancelButton = SOPHYSM_app["thresholdErrorCancelButton"]
    ## newProjectDialog
    newProjectOkButton = SOPHYSM_app["newProjectOkButton"]
    newProjectCancelButton = SOPHYSM_app["newProjectCancelButton"]
    projectNameLabel = SOPHYSM_app["projectNameLabel"]
    projectNameEntry = SOPHYSM_app["projectNameEntry"]
    # projectAlreadyExistMessage
    errorNameCancelButton = SOPHYSM_app["errorNameCancelButton"]
    # invalidNameMessage
    invalidNameProjectButton = SOPHYSM_app["invalidNameProjectButton"]
    # slideAlreadyExistMessage
    errorSlideOkButton = SOPHYSM_app["errorSlideOkButton"]
    errorSlideCancelButton = SOPHYSM_app["errorSlideCancelButton"]
    ## chooseCollectionDialog
    collectionOkButton = SOPHYSM_app["collectionOkButton"]
    collectionCancelButton = SOPHYSM_app["collectionCancelButton"]
    nameCollectionEntry = SOPHYSM_app["nameCollectionEntry"]
    ## jspaceOutputDialog
    conf10PlotButton = SOPHYSM_app["conf10PlotButton"]
    conf20PlotButton = SOPHYSM_app["conf20PlotButton"]
    confFinalPlotButton = SOPHYSM_app["confFinalPlotButton"]
    driverTreeButton = SOPHYSM_app["driverTreeButton"]
    phyloTreeButton = SOPHYSM_app["phyloTreeButton"]
    outputPlotImage = SOPHYSM_app["outputPlotImage"]
    infoPlotLabel = SOPHYSM_app["infoPlotLabel"]
    jspaceOutputCloseButton = SOPHYSM_app["jspaceOutputCloseButton"]
    ## Variables
    path_project_folder = ""
    path_slide_folder = ""
    filepath_slide_to_segment = ""
    filepath_slide = ""
    project_name = ""
    slide_name = ""
    threshold_gray = ""
    threshold_marker = ""
    threshold_min = ""
    threshold_max = ""
    collection_name = ""
    path_download_dataset = ""

    # Variables Output J-Space
    filepath_file_JSPACE = ""
    filepath_plot_JSPACE = ""
    filepath_reference_JSPACE = ""
    filepath_matrix = ""
    filepath_dataframe_labels = ""
    filepath_dataframe_edges = ""

    ###  LISTENER
    ## menuBar elements
    signal_connect(newProjectMenuItem, "button-press-event") do widget, event
        run(newProjectDialog)
    end

    signal_connect(loadProjectMenuItem, "button-press-event") do widget, event
         path_project_folder =
            open_dialog("SOPHYSM - Select Project Folder",
                        action=GtkFileChooserAction.SELECT_FOLDER)
        if path_project_folder != ""
            if Sys.iswindows()
                res = split(path_project_folder, "\\")
            elseif Sys.isunix()
                res = split(path_project_folder, "/")
            end
            data = []
            for i in res
                push!(data, i)
            end
             project_name = data[end]
            set_gtk_property!(descriptionLabel, :label,
                            "Project Name : " * project_name)
            set_gtk_property!(loadButton, :sensitive, true)
            set_gtk_property!(loadImageMenuItem, :sensitive, true)
            set_gtk_property!(segmentationButton, :sensitive, false)
            set_gtk_property!(tessellationButton, :sensitive, false)
            set_gtk_property!(simulationButton, :sensitive, false)
            set_gtk_property!(selectedImage, :icon_name, "image-x-generic-symbolic")
            set_gtk_property!(selectedImage, :icon_size, 6)
            set_gtk_property!(segmentedImage, :icon_name, "image-x-generic-symbolic")
            set_gtk_property!(segmentedImage, :icon_size, 6)
            set_gtk_property!(graphVertexImage, :icon_name, "image-x-generic-symbolic")
            set_gtk_property!(graphVertexImage, :icon_size, 6)
            set_gtk_property!(graphEdgesImage, :icon_name, "image-x-generic-symbolic")
            set_gtk_property!(graphEdgesImage, :icon_size, 6)
            set_gtk_property!(tessCellImage, :icon_name, "image-x-generic-symbolic")
            set_gtk_property!(tessCellImage, :icon_size, 6)
            set_gtk_property!(tessTotalImage, :icon_name, "image-x-generic-symbolic")
            set_gtk_property!(tessTotalImage, :icon_size, 6)
            set_gtk_property!(thresholdGreyscaleValueLabel, :label,
                            "Selected Greyscale Filter's Threshold : _____")
            set_gtk_property!(thresholdMarkersValueLabel, :label,
                            "Selected Marker's Distance Threshold : _____")
            set_gtk_property!(thresholdMinValueLabel, :label,
                            "Selected Minimum Threshold for Segmentation Area Detection : _______")
            set_gtk_property!(thresholdMaxValueLabel, :label,
                            "Selected Maximum Threshold for Segmentation Area Detection : _______")
        end
    end

    signal_connect(closeProjectMenuItem, "button-press-event") do widget, event
        set_gtk_property!(loadButton, :sensitive, false)
        set_gtk_property!(loadImageMenuItem, :sensitive, false)
        set_gtk_property!(segmentationButton, :sensitive, false)
        set_gtk_property!(tessellationButton, :sensitive, false)
        set_gtk_property!(simulationButton, :sensitive, false)
        set_gtk_property!(descriptionLabel, :label,
                        "Project Name : ______________________")
        set_gtk_property!(selectedImage, :icon_name, "image-x-generic-symbolic")
        set_gtk_property!(selectedImage, :icon_size, 6)
        set_gtk_property!(segmentedImage, :icon_name, "image-x-generic-symbolic")
        set_gtk_property!(segmentedImage, :icon_size, 6)
        set_gtk_property!(graphVertexImage, :icon_name, "image-x-generic-symbolic")
        set_gtk_property!(graphVertexImage, :icon_size, 6)
        set_gtk_property!(graphEdgesImage, :icon_name, "image-x-generic-symbolic")
        set_gtk_property!(graphEdgesImage, :icon_size, 6)
        set_gtk_property!(tessCellImage, :icon_name, "image-x-generic-symbolic")
        set_gtk_property!(tessCellImage, :icon_size, 6)
        set_gtk_property!(tessTotalImage, :icon_name, "image-x-generic-symbolic")
        set_gtk_property!(tessTotalImage, :icon_size, 6)
        set_gtk_property!(thresholdGreyscaleValueLabel, :label,
                        "Selected Greyscale Filter's Threshold : _____")
        set_gtk_property!(thresholdMarkersValueLabel, :label,
                        "Selected Marker's Distance Threshold : _____")
        set_gtk_property!(thresholdMinValueLabel, :label,
                        "Selected Minimum Threshold for Segmentation Area Detection : _______")
        set_gtk_property!(thresholdMaxValueLabel, :label,
                        "Selected Maximum Threshold for Segmentation Area Detection : _______")
    end

    signal_connect(quitMenuItem, "button-press-event") do widget, event
        hide(mainWindow)
        hide(thresholdDialog)
        hide(newProjectDialog)
        hide(projectAlreadyExistMessage)
        hide(invalidNameProjectMessage)
        hide(slideAlreadyExistMessage)
        hide(thresholdErrorMessage)
        hide(chooseCollectionDialog)
    end

    signal_connect(loadImageMenuItem, "button-press-event") do widget, event
         filepath_slide =
            open_dialog("SOPHYSM - Select Histological Image",
                        GtkNullContainer(),
                        ("*.tif",
                         "*.png",
                         "*.jpg",
                         GtkFileFilter("*.tif, *.png, *.jpg",
                                       name = "All supported formats")))
       if filepath_slide != ""
           set_gtk_property!(selectedImage, :file, filepath_slide)
           set_gtk_property!(segmentedImage, :icon_name, "image-x-generic-symbolic")
           set_gtk_property!(segmentedImage, :icon_size, 6)
           set_gtk_property!(graphVertexImage, :icon_name, "image-x-generic-symbolic")
           set_gtk_property!(graphVertexImage, :icon_size, 6)
           set_gtk_property!(graphEdgesImage, :icon_name, "image-x-generic-symbolic")
           set_gtk_property!(graphEdgesImage, :icon_size, 6)
           set_gtk_property!(tessCellImage, :icon_name, "image-x-generic-symbolic")
           set_gtk_property!(tessCellImage, :icon_size, 6)
           set_gtk_property!(tessTotalImage, :icon_name, "image-x-generic-symbolic")
           set_gtk_property!(tessTotalImage, :icon_size, 6)
           set_gtk_property!(segmentationButton, :sensitive, true)
           set_gtk_property!(tessellationButton, :sensitive, true)
           set_gtk_property!(simulationButton, :sensitive, false)
           set_gtk_property!(thresholdGreyscaleValueLabel, :label,
                           "Selected Greyscale Filter's Threshold : _____")
           set_gtk_property!(thresholdMarkersValueLabel, :label,
                           "Selected Marker's Distance Threshold : _____")
           set_gtk_property!(thresholdMinValueLabel, :label,
                           "Selected Minimum Threshold for Segmentation Area Detection : _______")
           set_gtk_property!(thresholdMaxValueLabel, :label,
                           "Selected Maximum Threshold for Segmentation Area Detection : _______")
           # Build directory for loaded image
           if Sys.iswindows()
               res = split(filepath_slide, "\\")
           elseif Sys.isunix()
               res = split(filepath_slide, "/")
           end
           data = []
           for i in res
               push!(data, i)
           end
            slide_name = data[end]
           if Sys.iswindows()
                path_slide_folder = path_project_folder * "\\" * slide_name
           elseif Sys.isunix()
                path_slide_folder = path_project_folder * "/" * slide_name
           end
            path_slide_folder = replace(path_slide_folder, r"....$" => "")
           if isdir(path_slide_folder)
               run(slideAlreadyExistMessage)
           else
               mkdir(path_slide_folder)
               if Sys.iswindows()
                    filepath_slide_to_segment = path_slide_folder * "\\" * slide_name
               elseif Sys.isunix()
                    filepath_slide_to_segment = path_slide_folder * "/" * slide_name
               end
               cp(filepath_slide, filepath_slide_to_segment)
           end
       end
    end

    signal_connect(workspaceMenuItem, "button-press-event") do widget, event
         workspace_path = open_dialog("SOPHYSM - Select Workspace Folder",
                       action= GtkFileChooserAction.SELECT_FOLDER)
        if(workspace_path != "")
            set_gtk_property!(workspacePositionLabel, :label, "Workspace Position : \n $workspace_path")
            set_gtk_property!(selectedImage, :icon_name, "image-x-generic-symbolic")
            set_gtk_property!(selectedImage, :icon_size, 6)
            set_gtk_property!(segmentedImage, :icon_name, "image-x-generic-symbolic")
            set_gtk_property!(segmentedImage, :icon_size, 6)
            set_gtk_property!(graphVertexImage, :icon_name, "image-x-generic-symbolic")
            set_gtk_property!(graphVertexImage, :icon_size, 6)
            set_gtk_property!(graphEdgesImage, :icon_name, "image-x-generic-symbolic")
            set_gtk_property!(graphEdgesImage, :icon_size, 6)
            set_gtk_property!(tessCellImage, :icon_name, "image-x-generic-symbolic")
            set_gtk_property!(tessCellImage, :icon_size, 6)
            set_gtk_property!(tessTotalImage, :icon_name, "image-x-generic-symbolic")
            set_gtk_property!(tessTotalImage, :icon_size, 6)
            set_gtk_property!(loadButton, :sensitive, false)
            set_gtk_property!(loadImageMenuItem, :sensitive, false)
            set_gtk_property!(segmentationButton, :sensitive, false)
            set_gtk_property!(tessellationButton, :sensitive, false)
            set_gtk_property!(simulationButton, :sensitive, false)
            set_gtk_property!(descriptionLabel, :label,
                            "Project Name : ______________________")
            set_gtk_property!(thresholdGreyscaleValueLabel, :label,
                            "Selected Greyscale Filter's Threshold : _____")
            set_gtk_property!(thresholdMarkersValueLabel, :label,
                            "Selected Marker's Distance Threshold : _____")
            set_gtk_property!(thresholdMinValueLabel, :label,
                            "Selected Minimum Threshold for Segmentation Area Detection : _______")
            set_gtk_property!(thresholdMaxValueLabel, :label,
                            "Selected Maximum Threshold for Segmentation Area Detection : _______")
        end
    end

    signal_connect(downloadSingleCollectionMenuItem, "button-press-event") do widget, event
         path_download_dataset =
            open_dialog("SOPHYSM - Select Folder for Downloading Dataset",
                        action=GtkFileChooserAction.SELECT_FOLDER)
        run(chooseCollectionDialog)
    end

    signal_connect(downloadAllCollectionMenuItem, "button-press-event") do widget, event
         path_download_dataset =
            open_dialog("SOPHYSM - Select Folder for Downloading Dataset",
                        action=GtkFileChooserAction.SELECT_FOLDER)
        # Call JHistInt
        JHistint.download_all_collection_SOPHYSM(path_download_dataset)
    end

    # slideAlreadyExistMessage elements
    signal_connect(errorSlideOkButton, "button-press-event") do widget, event
        rm(path_slide_folder, force=true, recursive=true)
        mkdir(path_slide_folder)
        if Sys.iswindows()
             filepath_slide_to_segment = path_slide_folder * "\\" * slide_name
        elseif Sys.isunix()
             filepath_slide_to_segment = path_slide_folder * "/" * slide_name
        end
        set_gtk_property!(thresholdGreyscaleValueLabel, :label,
                        "Selected Greyscale Filter's Threshold : _____")
        set_gtk_property!(thresholdMarkersValueLabel, :label,
                        "Selected Marker's Distance Threshold : _____")
        set_gtk_property!(thresholdMinValueLabel, :label,
                        "Selected Minimum Threshold for Segmentation Area Detection : _______")
        set_gtk_property!(thresholdMaxValueLabel, :label,
                        "Selected Maximum Threshold for Segmentation Area Detection : _______")
        cp(filepath_slide, filepath_slide_to_segment)
        hide(slideAlreadyExistMessage)
    end

    signal_connect(errorSlideCancelButton, "button-press-event") do widget, event
        hide(slideAlreadyExistMessage)
        set_gtk_property!(segmentationButton, :sensitive, true)
        set_gtk_property!(tessellationButton, :sensitive, true)
        set_gtk_property!(simulationButton, :sensitive, true)
        ## SHOW PREVIOUS ANALYSIS
        if Sys.iswindows()
             filepath_slide_to_segment = path_slide_folder * "\\" * slide_name
        elseif Sys.isunix()
             filepath_slide_to_segment = path_slide_folder * "/" * slide_name
        end
        set_gtk_property!(selectedImage, :file, filepath_slide_to_segment)
        set_gtk_property!(segmentedImage, :file,
                              replace(filepath_slide_to_segment,
                                      r"....$" => "_seg-0.png"))
        set_gtk_property!(graphVertexImage, :file,
                              replace(filepath_slide_to_segment,
                                      r"....$" => "_graph_vertex.png"))
        set_gtk_property!(graphEdgesImage, :file,
                              replace(filepath_slide_to_segment,
                                      r"....$" => "_graph_edges.png"))
        set_gtk_property!(tessCellImage, :icon_name, "")
        set_gtk_property!(tessCellImage, :icon_size, 6)
        set_gtk_property!(tessTotalImage, :icon_name, "")
        set_gtk_property!(tessTotalImage, :icon_size, 6)

    end
    ## newProjectDialog elements
    signal_connect(newProjectDialog, "delete-event") do widget, event
        hide(newProjectDialog)
    end

    signal_connect(newProjectOkButton, "button-press-event") do widget, event
         project_name = get_gtk_property(projectNameEntry, :text, String)
         path_project_folder = joinpath(workspace_path, project_name)
        if project_name == ""
            run(invalidNameProjectMessage)
        else
            if isdir(path_project_folder)
                run(projectAlreadyExistMessage)
            else
                # Build Project Folder
                mkdir(path_project_folder)
                hide(newProjectDialog)
                set_gtk_property!(descriptionLabel, :label, "Project Name : "*project_name)
                set_gtk_property!(loadButton, :sensitive, true)
                set_gtk_property!(loadImageMenuItem, :sensitive, true)
                set_gtk_property!(segmentationButton, :sensitive, false)
                set_gtk_property!(tessellationButton, :sensitive, false)
                set_gtk_property!(simulationButton, :sensitive, false)
                set_gtk_property!(selectedImage, :icon_name, "image-x-generic-symbolic")
                set_gtk_property!(selectedImage, :icon_size, 6)
                set_gtk_property!(segmentedImage, :icon_name, "image-x-generic-symbolic")
                set_gtk_property!(segmentedImage, :icon_size, 6)
                set_gtk_property!(graphVertexImage, :icon_name, "image-x-generic-symbolic")
                set_gtk_property!(graphVertexImage, :icon_size, 6)
                set_gtk_property!(graphEdgesImage, :icon_name, "image-x-generic-symbolic")
                set_gtk_property!(graphEdgesImage, :icon_size, 6)
                set_gtk_property!(tessCellImage, :icon_name, "image-x-generic-symbolic")
                set_gtk_property!(tessCellImage, :icon_size, 6)
                set_gtk_property!(tessTotalImage, :icon_name, "image-x-generic-symbolic")
                set_gtk_property!(tessTotalImage, :icon_size, 6)
                set_gtk_property!(thresholdGreyscaleValueLabel, :label,
                                "Selected Greyscale Filter's Threshold : _____")
                set_gtk_property!(thresholdMarkersValueLabel, :label,
                                "Selected Marker's Distance Threshold : _____")
                set_gtk_property!(thresholdMinValueLabel, :label,
                                "Selected Minimum Threshold for Segmentation Area Detection : _______")
                set_gtk_property!(thresholdMaxValueLabel, :label,
                                "Selected Maximum Threshold for Segmentation Area Detection : _______")
            end
        end
    end

    signal_connect(newProjectCancelButton, "button-press-event") do widget, event
        hide(newProjectDialog)
    end
    # errorNameMessage element
    signal_connect(errorNameCancelButton, "button-press-event") do widget, event
        hide(projectAlreadyExistMessage)
    end
    # invalidNameMessage element
    signal_connect(invalidNameProjectButton, "button-press-event") do widget, event
        hide(invalidNameProjectMessage)
    end

    ## chooseCollectionDialog elements
    signal_connect(chooseCollectionDialog, "delete-event") do widget, event
        hide(chooseCollectionDialog)
    end

    signal_connect(collectionCancelButton, "button-press-event") do widget, event
        hide(chooseCollectionDialog)
    end

    signal_connect(collectionOkButton, "button-press-event") do widget, event
         collection_name = get_gtk_property(nameCollectionEntry, :text, String)
        # Call JHistInt
        JHistint.download_single_collection_SOPHYSM(collection_name, path_download_dataset)
        hide(chooseCollectionDialog)
    end

    ## thresholdDialog elements
    signal_connect(thresholdDialog, "delete-event") do widget, event
        hide(thresholdDialog)
    end

    signal_connect(thresholdCancelButton, "button-press-event") do widget, event
        hide(thresholdDialog)
    end

    signal_connect(thresholdOkButton, "button-press-event") do widget, event
        # Setting parameter for Segmentation
         threshold_gray = get_gtk_property(thresholdGreyscaleEntry, :text, String)
         threshold_marker = get_gtk_property(thresholdMarkersEntry, :text, String)
         threshold_min = get_gtk_property(thresholdMinEntry, :text, String)
         threshold_max = get_gtk_property(thresholdMaxEntry, :text, String)
        if (threshold_gray == "" || threshold_marker == "" || threshold_min == ""
            || threshold_max == "")
            run(thresholdErrorMessage)
        else
            set_gtk_property!(thresholdGreyscaleValueLabel, :label,
                            "Selected Greyscale Filter's Threshold : " * threshold_gray)
            set_gtk_property!(thresholdMarkersValueLabel, :label,
                            "Selected Marker's Distance Threshold : " * threshold_marker)
            set_gtk_property!(thresholdMinValueLabel, :label,
                            "Selected Minimum Threshold for Segmentation Area Detection : " * threshold_min)
            set_gtk_property!(thresholdMaxValueLabel, :label,
                            "Selected Maximum Threshold for Segmentation Area Detection : " * threshold_max)
             threshold_gray = parse(Float64, threshold_gray)
             threshold_marker = parse(Float64, threshold_marker)
             threshold_min = parse(Float32, threshold_min)
             threshold_max = parse(Float32, threshold_max)
            hide(thresholdDialog)
            Gtk.set_gtk_property!(simulationButton, :sensitive, true)
        end
    end

    signal_connect(defaultSettingsButton, "button-press-event") do widget, event
        set_gtk_property!(thresholdGreyscaleEntry, :text, "0.15")
        set_gtk_property!(thresholdMarkersEntry, :text, "-0.3")
        set_gtk_property!(thresholdMinEntry, :text, "300")
        set_gtk_property!(thresholdMaxEntry, :text, "3000")
    end

    # invalidThresholdMessage element
    signal_connect(thresholdErrorCancelButton, "button-press-event") do widget, event
        hide(thresholdErrorMessage)
    end
    ## ProjectBox elements
    signal_connect(loadButton, "button-press-event") do widget, event
         filepath_slide =
            open_dialog("SOPHYSM - Select Histological Image",
                        GtkNullContainer(),
                        ("*.tif",
                         "*.png",
                         "*.jpg",
                         GtkFileFilter("*.tif, *.png, *.jpg",
                                       name = "All supported formats")))
       if filepath_slide != ""
           set_gtk_property!(selectedImage, :file, filepath_slide)
           set_gtk_property!(segmentedImage, :icon_name, "image-x-generic-symbolic")
           set_gtk_property!(segmentedImage, :icon_size, 6)
           set_gtk_property!(graphVertexImage, :icon_name, "image-x-generic-symbolic")
           set_gtk_property!(graphVertexImage, :icon_size, 6)
           set_gtk_property!(graphEdgesImage, :icon_name, "image-x-generic-symbolic")
           set_gtk_property!(graphEdgesImage, :icon_size, 6)
           set_gtk_property!(tessCellImage, :icon_name, "image-x-generic-symbolic")
           set_gtk_property!(tessCellImage, :icon_size, 6)
           set_gtk_property!(tessTotalImage, :icon_name, "image-x-generic-symbolic")
           set_gtk_property!(tessTotalImage, :icon_size, 6)
           set_gtk_property!(segmentationButton, :sensitive, true)
           set_gtk_property!(tessellationButton, :sensitive, true)
           set_gtk_property!(simulationButton, :sensitive, false)
           set_gtk_property!(thresholdGreyscaleValueLabel, :label,
                           "Selected Greyscale Filter's Threshold : _____")
           set_gtk_property!(thresholdMarkersValueLabel, :label,
                           "Selected Marker's Distance Threshold : _____")
           set_gtk_property!(thresholdMinValueLabel, :label,
                           "Selected Minimum Threshold for Segmentation Area Detection : _______")
           set_gtk_property!(thresholdMaxValueLabel, :label,
                           "Selected Maximum Threshold for Segmentation Area Detection : _______")
           # Build directory for loaded image
           if Sys.iswindows()
               res = split(filepath_slide, "\\")
           elseif Sys.isunix()
               res = split(filepath_slide, "/")
           end
           data = []
           for i in res
               push!(data, i)
           end
            slide_name = data[end]
           if Sys.iswindows()
                path_slide_folder = path_project_folder * "\\" * slide_name
           elseif Sys.isunix()
                path_slide_folder = path_project_folder * "/" * slide_name
           end
            path_slide_folder = replace(path_slide_folder, r"....$" => "")
           if isdir(path_slide_folder)
               run(slideAlreadyExistMessage)
           else
               mkdir(path_slide_folder)
               if Sys.iswindows()
                    filepath_slide_to_segment = path_slide_folder * "\\" * slide_name
               elseif Sys.isunix()
                    filepath_slide_to_segment = path_slide_folder * "/" * slide_name
               end
               cp(filepath_slide, filepath_slide_to_segment)
           end
       end
    end

    signal_connect(segmentationButton, "button-press-event") do widget, event
        run(thresholdDialog)
        # Launch JHistint Segmentation
        JHistint.start_segmentation_SOPHYSM_graph(filepath_slide_to_segment,
                                            filepath_slide_to_segment,
                                            threshold_gray,
                                            threshold_marker,
                                            threshold_min,
                                            threshold_max)
        set_gtk_property!(segmentedImage, :file,
                              replace(filepath_slide_to_segment,
                                      r"....$" => "_seg-0.png"))
        set_gtk_property!(graphVertexImage, :file,
                              replace(filepath_slide_to_segment,
                                      r"....$" => "_graph_vertex.png"))
        set_gtk_property!(graphEdgesImage, :file,
                              replace(filepath_slide_to_segment,
                                      r"....$" => "_graph_edges.png"))
        set_gtk_property!(tessCellImage, :icon_name, "")
        set_gtk_property!(tessCellImage, :icon_size, 6)
        set_gtk_property!(tessTotalImage, :icon_name, "")
        set_gtk_property!(tessTotalImage, :icon_size, 6)
    end

    signal_connect(tessellationButton, "button-press-event") do widget, event
        run(thresholdDialog)
        # Launch JHistint Segmentation
        JHistint.start_segmentation_SOPHYSM_tessellation(filepath_slide_to_segment,
                                            filepath_slide_to_segment,
                                            threshold_gray,
                                            threshold_marker,
                                            threshold_min,
                                            threshold_max)
        set_gtk_property!(segmentedImage, :file,
                              replace(filepath_slide_to_segment,
                                      r"....$" => "_seg-0.png"))
        set_gtk_property!(graphVertexImage, :file,
                              replace(filepath_slide_to_segment,
                                      r"....$" => "_graph_vertex.png"))
        set_gtk_property!(graphEdgesImage, :file,
                              replace(filepath_slide_to_segment,
                                      r"....$" => "_graph_edges.png"))
        set_gtk_property!(tessCellImage, :file,
                              replace(filepath_slide_to_segment,
                                      r"....$" => "_cell_tessellation.png"))
        set_gtk_property!(tessTotalImage, :file,
                              replace(filepath_slide_to_segment,
                                      r"....$" => "_total_tessellation.png"))
    end

    signal_connect(simulationButton, "button-press-event") do widget, event
         filepath_file_JSPACE = replace(filepath_slide_to_segment,
                                       r"....$" => "_Files_JSpace")
        if !isdir(filepath_file_JSPACE)
            mkdir(filepath_file_JSPACE)
        end
         filepath_plot_JSPACE = replace(filepath_slide_to_segment,
                                       r"....$" => "_Plots_JSpace")
        if !isdir(filepath_plot_JSPACE)
            mkdir(filepath_plot_JSPACE)
        end
         filepath_reference_JSPACE =
            replace(filepath_slide_to_segment,
                    r"....$" => "_reference.fasta")
         filepath_matrix =
            replace(filepath_slide_to_segment,
                    r"....$" => ".txt")
         filepath_dataframe_labels =
            replace(filepath_slide_to_segment,
                    r"....$" => "_dataframe_labels.csv")
         filepath_dataframe_edges =
            replace(filepath_slide_to_segment,
                    r"....$" => "_dataframe_edges.csv")
        # Launch J-Space Simulation
        Start_J_Space(filepath_reference_JSPACE,
                        filepath_matrix,
                        filepath_file_JSPACE,
                        filepath_plot_JSPACE,
                        slide_name,
                        filepath_dataframe_edges,
                        filepath_dataframe_labels)
        run(jspaceOutputDialog)
    end

    ## jspaceOutputDialog elements
    signal_connect(conf10PlotButton, "button-press-event") do widget, event
        filepath_conf10Plot = joinpath(filepath_plot_JSPACE, "Conf_t_10.png")
        set_gtk_property!(infoPlotLabel, :label, "Selected Plot : State of the Lattice at time T = 10 of the Simulation")
        set_gtk_property!(outputPlotImage, :file, filepath_conf10Plot)
    end

    signal_connect(conf20PlotButton, "button-press-event") do widget, event
        set_gtk_property!(infoPlotLabel, :label, "Selected Plot : State of the Lattice at time T = 20 of the Simulation")
        filepath_conf20Plot = joinpath(filepath_plot_JSPACE, "Conf_t_20.png")
        set_gtk_property!(outputPlotImage, :file, filepath_conf20Plot)
    end

    signal_connect(confFinalPlotButton, "button-press-event") do widget, event
        set_gtk_property!(infoPlotLabel, :label, "Selected Plot : State of the Lattice at time T = Final of the Simulation")
        filepath_confFinalPlot = joinpath(filepath_plot_JSPACE, "Final_conf.png")
        set_gtk_property!(outputPlotImage, :file, filepath_confFinalPlot)
    end

    signal_connect(driverTreeButton, "button-press-event") do widget, event
        set_gtk_property!(infoPlotLabel, :label, "Selected Plot : Mutational Tree of the Driver Mutations")
        filepath_driverTree = joinpath(filepath_plot_JSPACE, "driver_tree.png")
        set_gtk_property!(outputPlotImage, :file, filepath_driverTree)
    end

    signal_connect(phyloTreeButton, "button-press-event") do widget, event
        set_gtk_property!(infoPlotLabel, :label, "Selected Plot : Ground Truth Phylogenetic Tree")
        filepath_phyloTree = joinpath(filepath_plot_JSPACE, "phylo_tree.png")
        set_gtk_property!(outputPlotImage, :file, filepath_phyloTree)
    end

    signal_connect(jspaceOutputCloseButton, "button-press-event") do widget, event
        hide(jspaceOutputDialog)
    end

    ## Start GUI
     workspace_path = open_dialog("SOPHYSM - Select Workspace Folder",
                   action= GtkFileChooserAction.SELECT_FOLDER)
    if(workspace_path != "")
        # set-visible for Gtk Crash
        # Gtk.set_gtk_property!(mainWindow, :visible, true)
        # Gtk.set_gtk_property!(mainWindow, :sensitive, true)
        showall(mainWindow)
        set_gtk_property!(workspacePositionLabel, :label, "Workspace Position : \n $workspace_path")
    else
        hide(mainWindow)
    end
end
end

### end of file -- SOPHYSM.jl
