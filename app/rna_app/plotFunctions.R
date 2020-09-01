library(RColorBrewer)
library(ggplot2)
library(gdata)

plotHisto <- function(xlab,xVar,xScale,title){
  df <- data.frame(varX=xVar/xScale)
  
  g <- ggplot(df, aes(x=varX)) + 
    geom_histogram(color="black", fill="white") +
    theme_bw(base_size=15) +
    xlab(xlab) +
    ylab("Count") +
    ggtitle(title) 
  
  return(g)
}

plotVln <- function(xlab, ylab, xVar, yVar, xScale, yScale, Grlab, Grp, title, pointSize, palette) {
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
    theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust = 1)) +
    xlab(xlab) +
    ylab(ylab) +
    ggtitle(title) 
  
  return(g)
}

plotScatter <- function(xlab, ylab, xVar, yVar, xScale, yScale, Grlab, Grp, title, pointSize, palette) {
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
  
  return(g)
}

plotScatterFeatures <- function(coordinate.matrix, exp.matrix, title, group, grpLabel, xLab, yLab, point.size) {
  if(!is.null(group)){
    df <- data.frame(coordinate.matrix, Exp = exp.matrix, Group = as.factor(group))
    g <- ggplot(df, aes(x = df[,1], y = df[,2], shape = Group))
  } else {
    df <- data.frame(coordinate.matrix, Exp = exp.matrix)
    g <- ggplot(df, aes(x = df[,1], y = df[,2])) 
  }

  g <- g +
    geom_point(mapping = aes(colour = Exp), size = point.size) +
    scale_colour_gradient2(low = "gray", mid = "yellow", high = "red3", 
                           midpoint = ((max(df$Exp) - min(df$Exp))/2), 
                           space = "Lab", na.value = "midnightblue", 
                           guide = "colourbar", limits=c(min(df$Exp), max(df$Exp))) +
    {if(!is.null(group))scale_shape_manual(values = c(16, 17, 15, 3, 12, 8, 1, 0, 6, 4, 18), name = grpLabel)} +
    xlab(xLab) +
    ylab(yLab) +
    theme_bw(base_size=15) +
    ggtitle(title)
  
  return(g)
}

#library(ComplexHeatmap)
DrawHeatmap <- function (dat, annotation, expr, show, cluster_cell_method, cluster_gene_method, grp1Lab, grp2Lab) {
  dat$N -> row.names(dat)
  # dat2 <- dat[order(dat$group1),]
  # expr1 <- expr[,row.names(dat2)]
  
  # calculate Z scores for rows of expression matrix
  expr2 <- t(scale(t(expr), center = TRUE, scale = TRUE))
  # problem - missing or zero values not missing/zero after scaling
  
  fun <- function(x) {
    ifelse(x > 3, 3, ifelse(x < -3, -3, x))
  }
  expr3 <- matrix(sapply(expr2, fun), ncol=dim(expr)[2])
  row.names(expr2) -> row.names(expr3)
  colnames(expr2) -> colnames(expr3)
  expr3[is.na(expr3)] <- 0
  
  # make annotation for columns and rows
  anncol <- data.frame(Group1 = dat$group1, row.names=row.names(dat))
  names(anncol)[1] <- grp1Lab
  if (length(dat$group2)>0){
    anncol[["Group2"]] =dat$group2
    names(anncol)[2] <- {if (grp1Lab == grp2Lab) paste0(grp2Lab,"_2") else grp2Lab}
  }
  #annrow <- data.frame(Annotation = as.factor(annotation[,2]), row.names = annotation[,1])
  
  cluster_cell <- ifelse(is.null(cluster_cell_method),F,T)
  cluster_gene <- ifelse(is.null(cluster_gene_method),F,T)
  
  out <- pheatmap(expr3, annotation_col = anncol, annotation_row = annotation, color = colorRampPalette(rev(brewer.pal(n = 8, name = "RdYlBu")))(8),
                  fontsize=13, show_rownames=T, scale="none", show_colnames=show,  
                  cluster_cols=cluster_cell, clustering_distance_cols=cluster_cell_method, 
                  cluster_rows=cluster_gene, clustering_distance_rows=cluster_gene_method,
                  clustering_method="complete", border_color=FALSE, cellheight = 20)
  return(out)
}
