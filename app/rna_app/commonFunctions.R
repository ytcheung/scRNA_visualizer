searchGenes <- function(genes,keywords){
  keywords <- toupper(keywords)
  
  #Row names with "_" in "genes" were replaced by "-"
  keywords2 <- keywords[grep("-", keywords)]
  keywords2 <- gsub('-', '_', keywords2)
  
  results <- (toupper(genes[[COL_GENE_NAME]]) %in% keywords | toupper(genes[[COL_GENE_NAME]]) %in% keywords2)
  
  if(COL_GENE_ID != "")
    results <- (toupper(genes[[COL_GENE_ID]]) %in% keywords | toupper(genes[[COL_GENE_ID]]) %in% keywords2 | results)
  
  gene_list <- genes[results,]
  
  searchGenes <- gene_list
}

createLink <- function(val,link,label) {
  sprintf('<a href="%s%s" target="_blank">%s</a>',link,val,label)
}