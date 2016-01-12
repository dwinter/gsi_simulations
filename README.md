#Simulations from _The Genealogical Sorting Index and species delmiation_

##Prereqs

The simulation are performed using a combination of python and R scripts. Toget
them to run you will need:

 * Python 2 (>2.6)
 * R (and recent version)
 * ms (an executable for runnign demographic simulations)
 
In addition the scripts use the following R packages

 * genealogicalSorting
 * ape
 * stringr
 * plyr
 * ggplot2
 * reshape

The directory has a Makefile, meaning you can automatically run these
simualations if (GNU) Make is installed on your system.

##Replicating our results
rm r
You can ensure that everything is working properly by simulating just a handful
of trees and analysing the results:

```sh
make test
```

That should write `.csv` files to the data directory, and `.svg` files to
figures. If that all went off without a hitch, you can now replicate our retuls

`make clean` will clean up the test cases and `make` will run a bunch of
replicates for every parameter-value

```sh
make clean
make
```

##Extending our results

The above explains how to replicate our results. If you would like to extend
them, trying different parameter values or demographic histories please feel
free to fork this repository and make any changes you like. If you'd like any
help undestanding how the scripts work feel free to contact David Winter.
