searchGenes <- function(genes,keywords,id_fields,name_fields){
  keywords <- toupper(keywords)
  
  results <- (toupper(genes[[id_fields]]) %in% keywords | toupper(genes[[name_fields]]) %in% keywords)
  gene_list <- genes[results,]
  
  searchGenes <- gene_list
}