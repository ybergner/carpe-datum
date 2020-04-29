getShapeColors <- function(data, nbreaks=5, missingcol="gray88", rdgrbl=c(0,0,1), mycolors=NULL){
  if(length(nbreaks) == 1) {
    mybreaks <- c(-1, quantile(data,
                               probs = seq(0, 1, length.out=nbreaks+1),
                               na.rm = T))
  } else {
    mybreaks <- c(-1,nbreaks)
  }
  if(!is.null(mycolors)){
    mycols <- mycolors
  } else {
    mycols <- rgb(rdgrbl[1],rdgrbl[2],rdgrbl[3],
                  seq(0.05,0.65, length.out = length(mybreaks)-1))
  }
  mycols[1] <- missingcol
  data[is.na(data)] <- -.1
  mycolorscheme <- cut(data, mybreaks) %>%
    as.numeric()
  mycolorscheme <- mycols[mycolorscheme]
  levs <- levels(cut(data, mybreaks))
  levs[1] <- "No Data"
  return(list(regionValues=mycolorscheme, legendText=levs, legendColors=mycols))
}


