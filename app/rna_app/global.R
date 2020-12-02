## Global Variables for both UI and Server

ENSEMBL_LINK <- "https://www.ensembl.org/Homo_sapiens/Gene/Summary?g="

COL_CLUSTER <- "Cluster"
COL_EXPRESSION <- "exp"
COL_REDUCED_DIMS <- "reducedDims"

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

########################
## DE Settings ##
########################
COL_DE_DT_HIDE <- c() #Hide column(s) of DE results table

#Column names of de
COL_DE_LOG_FC <- "logFC" #For filtering
COL_DE_P_VAL <- "p_val_adj" #For filtering
COL_DE_GENE_NAME <- "Gene"
COL_DE_CLUSTER <- "cluster"