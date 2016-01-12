all: 
	$(MAKE) sim_trees
	$(MAKE) run_analyses
	$(MAKE) plots

.PHONY: sim_trees
sim_trees:
	scripts/make_samples.py 500 divergence
	scripts/make_samples.py 1500 migration

run_analyses: data/gsi_2v4.csv data/gsi_migration.csv

data/gsi_2v4.csv:
	scripts/analyse_div.r

data/gsi_migration.csv:
	scripts/analyse_mig.r

plots:	figures/divergence_gsi.svg 	

figures/divergence_gsi.svg: data/gsi_2v4.csv data/gsi_migration.csv
	scripts/plots.r



Supplement:
	Rscript -e 'rmarkdown::render("pwgsi_demonstration/pwgsi.Rmd")'
	


.PHONY: test
test:
	scripts/make_samples.py 1 divergence
	scripts/make_samples.py 1 migration
	$(MAKE) run_analyses 
	$(MAKE) plots


.PHONY: clean
clean:
	 rm -f data/*.csv
	 rm -f figures/*.svg
	 rm -f trees/*.tr
	 rm -rf pwgsi_demonstration/pwgsi_files/
	 rm -rf pwgsi_demonstration/pwgsi.pdf

