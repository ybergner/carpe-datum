getcolors <- function(data, ntile, missingcol, rdgrbl=c(1,0,0), mycolors=NULL){
  mybreaks <- c(-1, quantile(data,
                             probs = seq(0, 1, length.out=ntile+1),
                             na.rm = T))
  mycols <- rgb(rdgrbl[1],rdgrbl[2],rdgrbl[3],
                seq(0.05,0.65, length.out = length(mybreaks)-1))
  if(!is.null(mycolors)){
    mycols <- mycolors
  }
  mycols[1] <- missingcol
  data[is.na(data)] <- -.1
  mycolorscheme <- cut(data, mybreaks) %>%
    as.numeric()
  mycolorscheme <- mycols[mycolorscheme]
  levs <- levels(cut(data, mybreaks))
  levs[1] <- "No Data"
  return(list(mycolorscheme, levs, mycols))
}

getcolors2 <- function(data, data2, ntile, missingcol, rdgrbl=c(1,0,0), mycolors=NULL){
  mybreaks <- c(-1, quantile(data,
                             probs = seq(0, 1, length.out=ntile+1),
                             na.rm = T))
  mybreaks2 <- c(-1, quantile(data2,
                              probs = seq(0, 1, length.out=ntile+1),
                              na.rm = T))
  alphas <- seq(.1, .8, length.out=length(mybreaks)-1)
  mycols <- alphas
  for(i in 1:length(alphas)){
    mycols2 <- rgb(seq(0, 1, length.out = length(mybreaks)-1),
                   0,
                   seq(1, 0, length.out = length(mybreaks)-1),
                   alphas[i])
    mycols <- rbind(mycols,mycols2)
  }
  mycols[1,] <- missingcol
  mycols <- cbind(rep(missingcol,length(mybreaks)), mycols)
  if(!is.null(mycolors)){
    mycols <- mycolors
  }
  data[is.na(data)] <- -.1
  data2[is.na(data2)] <- -.1
  mycolorscheme1 <- cut(data, mybreaks) %>%
    as.numeric()
  mycolorscheme2 <- cut(data2, mybreaks2) %>%
    as.numeric()
  for(i in 1:length(data)){
    mycolorscheme[i] <- mycols[mycolorscheme1[i], mycolorscheme2[i]]
  }
  levs <- levels(cut(data, mybreaks))
  levs[1] <- "No Data"
  return(mycolorscheme)
}
