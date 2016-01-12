#!/usr/bin/Rscript

##
# Calculate the mean-pairwise gsi for groups "B" and "C" for every migration
# simulation.
#
# Note: the 'main' function relies on filenames to identify the tree files to
# read and the paramater values for each simulation (so, if you change
# 'make_samples.py' you'll need to change the main function too )    
##

library(stringr)
library(plyr)
library(genealogicalSorting)

permute_gsi <- function(observed_value, tr, imap, nperm=1000){
    one_rep <- function(){
      tr$tip.label <- sample(tr$tip.label)
      assigns <- imap[tr$tip.label,2]
      return(mean(gsi(tr, 0, assigns)$gsi))
    }
    distr <- replicate(nperm, one_rep())
    return(mean(distr > observed_value))
}

pwgsi <- function(tr, imap, nperm=1000){
    assigns <- imap[tr$tip.label,2]
    pw_gsi <- mean(gsi(tr, 0, assigns)$gsi)
    p_val <- permute_gsi(pw_gsi, tr, imap,nperm)
    return(c(pwgsi=pw_gsi, P=p_val))
}


per_tree <- function(tr, imap, nperm=1000){
    dropped_tr <- drop.tip(tr, as.character(1:10))
    res <- pwgsi(dropped_tr, imap=imap)
    return(res)
}

is_mig <- function(fname) {
    str_split(fname, "_")[[1]][1] == "migration"
}

main <- function(){

    tfiles <- paste("trees/", Filter(is_mig, list.files("trees/")), sep="")
    m_rate <- as.numeric(sapply(tfiles, str_extract,  "\\d+(\\.\\d{1,2})?"))
    nfiles <- length(tfiles)                     

    message(paste("loading data from", nfiles, "tree files..."))
    all_trees <- do.call("c", lapply(tfiles, read.tree))
    n <- length(all_trees)

    sp_map <- read.table("sample.imap")
    message("calcuating gsi...\n")
    res <- laply(all_trees, per_tree, sp_map, .progress="text")

    message("writing data... \n")
    df0 <- data.frame(res,  m = rep(m_rate, each=n/nfiles))
    write.csv(df0, "data/gsi_migration.csv", row.names=FALSE)
}

if(!interactive()){
    main()
}
