#!/usr/bin/Rscript

##
# Plot the data with ggplot. 
#
# For each plot their are two facets - the average of the _gsi_ being 
# being summarised for each data and proportion of the runs for each
# paramater that have a significant (P < 0.05) result. There is probably
# some clever way to do this in one go with `viewports` and the like. 
# I'm not clever enough, so just made two plots for each and pasted them
# together in Inkscape...
#
##

library(reshape)
library(ggplot2)


stat_sum_single <- function(fun=mean, geom="point", ...) {
       stat_summary(fun=fun, colour="black", geom=geom)
}

plot_div <- function(){
    theme_set(theme_bw())
    gsi_sims <- read.csv("data/gsi_2v4.csv")
    molten_sims <- melt(gsi_sims, id.var=c("comp", "t_div"))

    p <- ggplot(molten_sims, aes(t_div, value, colour=factor(comp)))
    
    svg("figures/divergence_pval.svg", width=8.5, height=4)
    print(p + stat_summary(fun.y=function(x) mean(x < 0.05), geom='line', size=1) + 
        facet_grid(variable~.) + scale_colour_brewer(palette="Set1") ) 
    dev.off()

    svg("figures/divergence_gsi.svg", width=8.5, height=4)
    print(
        p +  stat_summary(fun.y='mean', geom='line', size=1) +
        facet_grid(variable~.) + scale_colour_brewer(palette="Set1")
    )
    dev.off()
}


plot_mig <- function(){
    theme_set(theme_bw())
    mig_sims <- read.csv("data/gsi_migration.csv")
    molten_sims <- melt(mig_sims, id.var=c("m"))
    p <- ggplot(molten_sims, aes(m, value, group=m))

    svg("figures/mig_pval.svg", width=8.5, height=4)
    print(
           p + geom_point(position='jitter', colour='grey70', size=1.2) +
               scale_x_log10() + 
               stat_summary(fun.y=function(x) mean(x <0.05), geom='point') + 
               facet_grid(variable~.)
               )
    dev.off()

    svg("figures/mig_pwgsi.svg", width=8.5, height=4)
    print(
           p + geom_boxplot() + facet_grid(variable~.) + scale_x_log10()
    )
    dev.off()
}



if(!interactive()){
    plot_div()
    plot_mig()
}
