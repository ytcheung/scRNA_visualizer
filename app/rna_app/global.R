## Global Variables for both UI and Server

ENSEMBL_LINK <- "https://www.ensembl.org/Homo_sapiens/Gene/Summary?g="

COL_CLUSTER <- "Cluster"
COL_CELL_NAME <- "CellName"
COL_EXPRESSION <- "Log2(RPKM+1)"
COL_EXPRESSION_DE <- "RPKM"
COL_REDUCED_DIMS <- "reducedDims"

LEGEND_EXPRESSION <- "log2(RPKM+1)"

GROUP_BY_OPTIONS <- list("Sample Type" = "Type", "Cluster" = COL_CLUSTER) #The values must match the column names in sce

DIM_TYPES <- list("TSNE" = "TSNE") #list("PCA" = "PCA", "UMAP" = "UMAP", "TSNE" = "TSNE")

#Column names of gene_info
COL_GENE_NAME <- "Gene.Name"
COL_GENE_ID <- "" #"Gene.ID" #Optional, used for the search function and the link to ensembl
COL_GENE_ANNO <- "" #"Annotation"

########################
## QC Plots Settings ##
########################
COL_LIBSIZE <- "nCount_RNA"
COL_FEATURES_COUNT <- "nFeature_RNA"
COL_MT_PERCENT <- "percent.mito"
COL_BATCH <- "Experiment"
LABEL_BATCH <- "Experiment" #For labelling plots

COLOR_DISCARDED <- TRUE #Highlight discarded cells based on qc_reasons.rds
COL_DISCARD_LIBSIZE <- "low_lib_size"
COL_DISCARD_FEATURES_COUNT <- "low_n_features"
COL_DISCARD_MT_PERCENT <- "high_subsets_mito_percent"

USE_MANUAL_COLOUR <- TRUE #Use manual colour defined in anno_colour.rds to create plots

########################
## DE Settings ##
########################
COL_DE_MARKER_DT_HIDE <- c() #Hide column(s) of DE results table
COL_DE_DT_HIDE <- c(1,2)

#Column names of de
COL_DE_LOG_FC <- "log2FC" #For filtering
COL_DE_P_VAL <- "p_val_adj" #For filtering
COL_DE_GENE_NAME <- "Gene"
COL_DE_CLUSTER <- "Cluster"

MARKER_SUBSET_OPTIONS <- list("Sample Type" = "Type") 
MARKER_DEFAULT_GROUP <- "Type" #Default cell grouping of the heatmap

DE_GROUP1_TITLE <- "Cluster"
DE_GROUP1_COL_NAME <- "Cluster" 
DE_GROUP1_OPTIONS <- list("Keratinocyte","Melanocyte")
DE_GROUP1_MAPPING <- list("Keratinocyte"=list("KC_1","KC_2","KC_3","KC_4"),"Melanocyte"="Melanocyte")
DE_GROUP2_TITLE <- "Type"
DE_GROUP2_COL_NAME <- "Type"
#Types seperated by "_"
DE_GROUP2_OPTIONS <- list("Acute wounds (AW) vs Skin"="Acute wounds (AW)_Skin","Pressure ulcers (PU) vs Skin"="Pressure ulcers (PU)_Skin","Acute wounds (AW) vs Pressure ulcers (PU)"="Acute wounds (AW)_Pressure ulcers (PU)")