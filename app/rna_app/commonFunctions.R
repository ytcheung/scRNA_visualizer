searchGenes <- function(genes,keywords,id_fields,name_fields){
  keywords <- toupper(keywords)
  
  #Row names with "_" in "genes" were replaced by "-"
  keywords2 <- keywords[grep("-", keywords)]
  keywords2 <- gsub('-', '_', keywords2)
  
  results <- (toupper(genes[[id_fields]]) %in% keywords | toupper(genes[[name_fields]]) %in% keywords |
                toupper(genes[[id_fields]]) %in% keywords2 | toupper(genes[[name_fields]]) %in% keywords2)
  gene_list <- genes[results,]
  
  searchGenes <- gene_list
}

createLink <- function(val,link,label) {
  sprintf('<a href="%s%s" target="_blank">%s</a>',link,val,label)
}