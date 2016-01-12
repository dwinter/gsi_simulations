#Simulations from _The Genealogical Sorting Index and species delmiation_

##Prerequisites

The simulation are performed using a combination of python and R scripts. To get
them to run you will need:

 * Python (>2.6)
 * R (any recent version)
 * [ms](http://home.uchicago.edu/rhudson1/source/mksamples.html) (an executable for running demographic simulations)
 
In addition the scripts use the following R packages

 * genealogicalSorting (not on CRAN, [can be downloaded from here](http://www.molecularevolution.org/software/phylogenetics/gsi))
 * ape
 * stringr
 * plyr
 * ggplot2
 * reshape

The directory has a Makefile, meaning you can automatically run these
simulations if (GNU) Make is installed on your system.

##Replicating our results

You can ensure that everything is working properly by simulating just a handful
of trees and analysing the results:

```sh
make test
```

That should write `.csv` files to the data directory, and `.svg` files to
figures. If that went as expected, you can run the complete analysis.

`make clean` will clean up the test cases and `make` will run a bunch of
replicates for every parameter-value. Not that this will take several hours if
run in serial. Because each simulation is independent from all others it would
be possible to run these in parallel using R's `parallel` library. 

```sh
make clean
make
```

##Extending our results

The above explains how to replicate our results. If you would like to extend
them, trying different parameter values or demographic histories please feel
free to fork this repository and make any changes you like. Note that many of
the key parameter values in our simulations are hard coded in the scripts, thus
extending the results will require those sripts to be edited. If you'd like any
help understanding how the scripts work feel free to contact David Winter by
raising an issue on this repo or emailing him (david dot winter at gmail)

## Building the supplementary material

The manuscript also contains a supplementary file which demonstrates how the
"pariwse _gsi_" can be calculated with existing software. If you would like to
build this file for yourself you can. You will need to have the R package
`rmarkdown` installed. Then simply type:

```sh
make Supplement
```
