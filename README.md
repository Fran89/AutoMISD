# AutoMISD
A wrapper for the Model Independent Stochastic Declustering

### Brief:
This is a wrapper for MISD by Marsan D., and O. Lengliné (2008). Main program is included but may also be found here:
https://isterre.fr/annuaire/pages-web-du-personnel/david-marsan/article/model-independent-stochastic?lang=en

### Usage:

A catalog must be placed in this directory in the Comma Separated Values following the format:
Year	Month	Day	Hour	Minute	Sec	Lat	Lon	Depth	Mag

Then AutoMISD must be run. It will ask for the catalog name and threshold value.
MISD and an input file will be compiled and created in the first run of this program.
This program will modify the catalog and format it for MISD input using routines by Thomas van Stiphout (2007)
for the Zmap project.

The output will be placed in a folder called Output (auto-generated) and consist of the MISD output and 2 more files:
  * CCatalog.csv: Clustered Catalog in Zmap format.
  * DCCatalog.csv: Declustered Catalog in Zmap format.

### Dependencies

  1. Bash-capable linux
  2. Octave
  3. GCC Compiler

### Acknolegments:
 * Marsan D., and O. Lengliné (2008), Extending earthquake’ reach through cascading, Science, 319, 1076-1079.
 * S. Wiemer (2001) A Software Package to Analyze Seismicity: ZMAP, Seismological Research Letters, Vol. 72, 373-382, 2001.
 * Thomas van Stiphout (2007) for the Zmap routiens for MISD.
