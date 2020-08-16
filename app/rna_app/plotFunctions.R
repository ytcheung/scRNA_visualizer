library(RColorBrewer)
library(ggplot2)
library(gdata)

plotVln <- function(xlab, ylab, xVar, yVar, xScale, yScale, Grlab, Grp, title, pointSize, palette, plotName) {
  if(!is.null(Grp)){
    df <- data.frame(varY=yVar, varX=xVar, Group=as.factor(Grp))
  } else {
    df <- data.frame(varY=yVar, varX=xVar)
  }
  
  g <- ggplot(df, aes(x=varX, y=varY)) + 
    geom_violin() + 
    {if(!is.null(Grp))geom_point(size=pointSize, aes(colour = Group), position="jitter")}+
    {if(is.null(Grp))geom_point(size=pointSize, position="jitter")}+
    {if(!is.null(xScale))scale_x_continuous(trans = xScale)} + 
    {if(!is.null(yScale))scale_y_continuous(trans = yScale)} + 
    scale_color_brewer(palette=palette,name=Grlab) +
    theme_bw(base_size=15) +
    xlab(xlab) +
    ylab(ylab) +
    ggtitle(title) 
  
  g
}

plotScatter <- function(xlab, ylab, xVar, yVar, xScale, yScale, Grlab, Grp, title, pointSize, palette, plotName) {
  data <- data.frame(varY=yVar, varX=xVar, Group=as.factor(Grp))
  
  g <- ggplot(data, aes(x=varX, y=varY, colour=Group)) + 
    geom_point(size=pointSize) +
    {if(!is.null(xScale))scale_x_continuous(trans = xScale)} + 
    {if(!is.null(yScale))scale_y_continuous(trans = yScale)} + 
    scale_color_brewer(palette=palette, name = Grlab) +
    theme_bw(base_size=15) +
    xlab(xlab) +
    ylab(ylab) +
    ggtitle(title)
  
  g
}

plotScatterFeatures <- function(coordinate.matrix, exp.matrix, marker, group, grpLabel, xLab, yLab, point.size, plotName) {
  if(!is.null(group)){
    df <- data.frame(coordinate.matrix, Exp = exp.matrix, Group = as.factor(group))
    g <- ggplot(df, aes(x = df[,1], y = df[,2], shape = Group))
  } else {
    df <- data.frame(coordinate.matrix, Exp = exp.matrix)
    g <- ggplot(df, aes(x = df[,1], y = df[,2])) 
  }

  g <- g +
    geom_point(mapping = aes(colour = Exp), size = point.size) +
    scale_colour_gradient2(low = "gray", mid = "pink", high = "red3", 
                           midpoint = ((max(df$Exp) - min(df$Exp))/2), 
                           space = "Lab", na.value = "midnightblue", 
                           guide = "colourbar", limits=c(min(df$Exp), max(df$Exp))) +
    {if(!is.null(group))scale_shape_manual(values = c(16, 17, 15, 3, 12, 8, 1, 0, 6, 4, 18), name = grpLabel)} +
    xlab(xLab) +
    ylab(yLab) +
    theme_bw(base_size=15) +
    ggtitle(marker)
  
  g
}

################################################################################
# Catergorize markers to EPI, PE and TE
# input: vector of gene names
# output: data frame with gene name and annotation
################################################################################
CategorizeMarkers <- function (data) {
  
  #Bovine bEPI Preimplantation TOPModular Genes
  bEPI <- c('GDF3','PRDM14','TDGF1','FGF4','ZIC3','NANOG','SOX15','LIN28B','ZFP42', 'IFITM1', 'IFITM3','TDF1P3','PRICKLE1','DPPA5','KLF17','KLF4','ARGFX','ESRG','MRS2','POU5F1', 'LEFTY2', 'WNT3','VENTX','SERINC5','FBP1','MT1X','ATG3','CDHR1','DND1','SAT1','PARP1','CFLAR','MAN1C1','CD9','CAPG','SOX2','PIM2','TVC1D23','UNC5B','DPPA2','MEG3','ASH2L','MSH6','CBFA2T2','MRPS23','USP28','BCOR','VCAN','ETV4','CNIH4','DEPTOR','ABHD12B','NODAL','GPR160','SPRY2','SLC39A10','WARS','ASRGL1',"ESRRB")
  
  #Bovineb PE New Preimplantation TOP Modular Genes
  bPE <- c('UACA','PDGFRA', 'GATA6', 'GATA4', 'COL4A1', 'HNF1B', 'NID2', 'RSPO3', 'APOA1','SOX17','GAPDA', 'FN1', 'LAMB1','LBH', 'KIT', 'FGFR2','GPX2', 'LAMA4', 'LAMA1','BMP2','SERPINH1','P4HA1','EGLN3','ZC3HAV1','BAMBI','GPRC5B', 'MARCKS','HNF4A', 'DUSP1','ALDH2','APOC1','TCEA1','CDC42EP4','PHLDA1','SEPT11','ENO2','SLC4A8','HORMAD2-AS1','ST3GAL1','NDUFAB1','SPARC','SPATS2L','TMBIM1','UQCRH','TPST2','GYPC','RCBTB1','PXDN','TBCA','RAB15','CLDN19','KLHL18','CADM1','FGFR1','UBASH3B','SRGAP1','GSN','CTSE','GSTO1','BRDT','OTX2','LARP6','UQCRHL')
  
  #Bovine bTE New Preimplantation TOP Modular Genes
  bTE <- c('CLDN4','GATA3','GATA2','KRT18','PPIA','CDX2','TEAD4','DAB2','SLC7A2','ABCG2', 'MYC', 'LRP2', 'WNT7A', 'FDGFA', 'FRDM4','KRT8','GRHL2','TACSTD2','MPZL1','PALLD','TACC1','LRRFIP1','RAB11FIP4','RALBP1','PTGES','EMP2','PTN','SH3KBP1','SH2D4A','TEAD1','MGST3','TGFBR3','ODC1','S100A6','JUP','TCF7L2','PRSS8','CEBPA','SLC7A4','ZFHX3','VAMP8','ENTPD1','HIC2','SLC7A5','DLX3','EFNA1','TIGAR','GRHL1','FOLR1','CD55','GAB2','ADK','PPT1','PERP','FHL2','KRT19','TMEM106C',"TMEM54")
  
  EPI <- data.frame(gene=bEPI, Annotation="EPI")
  PE <- data.frame(gene=bPE, Annotation="PE")
  TE <- data.frame(gene=bTE, Annotation="TE")
  
  d1 <- rbind(EPI, PE)
  d2 <- rbind(d1, TE)
  
  all <- data.frame(gene=data, Annotation="UN")
  all2 <- merge(all, d2, by.x="gene", by.y="gene", all.x=T)
  all2$Annotation <- ifelse(!is.na(all2$Annotation.y), as.character(all2$Annotation.y), "UN")
  all2 <- all2[,c(1,4)]
  row.names(all2) <- all2$gene
  annogenes <- all2[!duplicated(all2$gene),]
  
  return(annogenes)
}

################################################################################
# Draw Heatmap

# Input: data frame for clustering and grouping of cells, data frame for annotation of marker genes,
#        expression matrix including only chosen markers, vector of chosen markers,
#        pheatmap parameter TRUE/FALSE for whether to show column names, clustering method for cells, 
#        pheatmap parameter TRUE/FALSE for whether to cluster cells
# Output: heatmap
################################################################################
DrawHeatmap <- function (dat, annotation, expr, markers, show, method, cluster) {
  # order cells in expression matrix according to group1
  dat$N -> row.names(dat)
  dat2 <- dat[order(dat$group1),]
  expr1 <- expr[,row.names(dat2)]
  
  # calculate Z scores for rows of expression matrix
  expr2 <- t(scale(t(expr1), center = TRUE, scale = TRUE))
  # problem - missing or zero values not missing/zero after scaling
  
  fun <- function(x) {
    ifelse(x > 3, 3, ifelse(x < -3, -3, x))
  }
  expr3 <- matrix(sapply(expr2, fun), ncol=dim(expr)[2])
  row.names(expr2) -> row.names(expr3)
  colnames(expr2) -> colnames(expr3)
  expr3[is.na(expr3)] <- 0
  
  # make annotation for columns and rows
  anncol <- data.frame(Group1 = dat$group1, Group2=dat$group2, row.names=row.names(dat))
  annrow <- data.frame(Celltype = as.factor(annotation[,2]), row.names = annotation[,1])
  
  out <- pheatmap(expr3, annotation_col = anncol, annotation_row = annrow, color = colorRampPalette(rev(brewer.pal(n = 8, name = "RdYlBu")))(8),
                  fontsize=14, show_rownames=T, cluster_cols=cluster, cluster_rows=T, scale="none", 
                  show_colnames=show, cex=1, clustering_distance_rows="euclidean", width = 11, height = 10,
                  clustering_distance_cols=method, clustering_method="complete", border_color=FALSE)
  return(out)
}
