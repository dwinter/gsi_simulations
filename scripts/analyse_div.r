#!/usr/bin/Rscript

##
# Calcute the "normal" gsi for group "A" twice for every simulation, onece with
# tips for all four groups, and a second time with groups "C" and "D" dropped.
# 
# Note: the 'main' function relies on filenames to identify the tree files to 
# read and the paramater values for each simulation (so, if you change
# 'make_samples.py' you'll need to change the main function too )
##

library(stringr)
library(genealogicalSorting)
library(plyr)

gsi_a <- function(tr, imap, nperm=1000){
    grp <- as.factor("A")
    assigns <- imap[tr$tip.label,2]
    gsi_val <- gsi(tr, grp, assigns)
    p_val <- permutationTest(tr, grp, assigns, nperm)
    return(c(gsi=gsi_val, P=p_val))
}


per_tree <- function(tr, imap, nperm=1000){
    dropped_tr <- drop.tip(tr, as.character(21:40))
    res_2 <- gsi_a(dropped_tr, imap=imap)
    res_4 <- gsi_a(tr, imap=imap)
    final <-  cbind(c(2,4),rbind(res_2, res_4))
    colnames(final) <- c("comp", "gsi", "P")
    return(final)
}

is_gsi <- function(fname) {
    str_split(fname, "_")[[1]][1] == "gsi"
}

main <- function(){

    tfiles <- paste("trees/", Filter(is_gsi, list.files("trees/")), sep="")
    div_time <- as.numeric(sapply(tfiles, str_extract,  "\\d\\.\\d+"))

    message(paste("loading data from", length(tfiles), "tree files..."))
    all_trees <- do.call("c", lapply(tfiles, read.tree))
    sp_map <- read.table("sample.imap")
    n <- length(all_trees)

    message("calcuating gsi...")
    res <- llply(all_trees, per_tree, sp_map, .progress="text")
    res <- do.call('rbind', res)

    message("writing data...")
    df0 <- data.frame(res, t_div = rep(div_time, each=2*n/21))
    write.csv(df0, "data/gsi_2v4.csv", row.names=FALSE)
}

if(!interactive()){
    main()
}
