README file for misd (model-independent stochastic declustering).
Written by David Marsan, the 3th of July 2007 (David.Marsan@univ-savoie.fr)

The command line is:
> misd input_file

The input file has the following format:
----------------------------------BEGINNING OF INPUT FILE---------------------------------------
*______ DATA ______
* CATALOGUE FILE NAME
/home/dmars/Data/SHLK/new.dat
* # COLUMN FOR (1) time (2) magnitude (3) latitude (4) longitude [NB: 1st column is "1", not "0"]
1 2 3 4
* ARE THE EPICENTRES REALLY IN (LAT,LON) OR RATHER IN (X,Y) FORMAT (1/0)?
1
* CORRECTION FOR DETECTION (0/1)? IF yes (1), THEN FOLLOW WITH NAME OF FILE CONTAINING THE CORRECTION VALUES
1 /home/dmars/Ponderation/correction.dat
*______ DISCRETIZATION ______
* MAGNITUDE INTERVALS
3 4 5 6 7 8 
* TIME INTERVALS
0. 0.001 0.004 0.016 0.064 0.256 1.024 4.096 16.384 65.536 262
* DISTANCE INTERVALS (km if epicentres in lat/lon)
0. 0.2 0.5 1. 2. 5. 10. 25. 50. 100. 200. 500. 1000.
*______ BACKGROUND ______
* BACKGROUND OPTIONS: (1) imposed rate (follow with rate), (2) random 2D Poisson (follow with surface), 
* (3) random 2D Poisson with periodic boundaries (follow with square surface), (4) Poisson & spatial clustering
4
*______ CONVERGENCE _______
* CONVERGENCE LEVEL
0.01
*______ OUTPUT _______
* SUFFIX FOR OUTPUT FILES

* SAVE mbin, tbin, rbin, lambda_t, lambda_s, lambda0, w, w0 (0/1 for each)?
0 0 0 1 1 1 0 1
----------------------------------END OF INPUT FILE---------------------------------------

Please do not modify the line order of the input file, and do not add blank lines.

'DATA' SECTION:
(1) name of file containing the earthquake catalogue
(2) indicate which columns correspond to the time, magnitude, latitude (or x), longitude (or y).
The catalogue should not have any letter characters (only numbers).
(3) say if the coordinates are in latitude / longitude (1) or are cartesian [in arbitary units] (0) 
(4) flag = 1 if there is a correction for detection, followed by name of correction file if required.
This is to correct for change in completness magnitude mc immediately following large earthquakes. If no
correction is given, then the triggering rate at early time will saturate or even be zero if the change
in mc is very large. The correction amounts to give a weight (>1) to early aftershocks, so that they
"count" for their missing colleagues. This weight is then simply the number of earthquakes they are
supposed to represent (=1 if they represent only themselves).
The correction file must have one entry for each earthquake in the catalogue. This entry is just the
weight, so 1 if no correction, and >1 if there is a correction.

'DISCRETIZATION' SECTION:
(1) magnitude intervals for discretizing the rates and densities.
Note that the 1st magnitude *is not* the completness magnitude: it gives the
minimum magnitude for an earthquake to be considered as a trigger. So an earthquake
with magnitude less than this 1st value will still be considered as a triggered earthquake,
although the algorithm will not consider it could have triggered anything itself.
The cutting off of the earthquake catalogue at completness magnitude must be done when
creating the catalogue file, this program will not look after this.
(2) time intervals for discretization. The units are in whatever time unit was used for 
computing the occurrence times in the earthquake catalogue.
(3) distance intervals for discretization, in km if coordinates in latitude / longitude,
otherwise in whatever units was used for computing the cartesian coordinates.

'BACKGROUND' SECTION:
(1) indicate which method must be used for estimating the background rate / density. The
following options apply:

	1: imposed rate. The background is random in space and in time. The number of earthquakes
	per unit time and unit surface must then be given.

	2 and 3: random 2D. The background is random in space and in time, but the rate density is unknown. The
	algorithm then estimates this value (number of background earthquakes per unit time and unit
	surface). The total surface over which background earthquakes can occur must be given.
	If option 3 is used: periodic boundaries are assumed when computing epicentral distances. This can only
	be used if the coordinates are cartesian (in x | y, not in latitude | longitude). The surface must then
	be square (same period along the x and the y axes).

	4: spatial clustering. The background is random in time with an unknown rate, and clustered in space with
	an unknown conditional density. The algorithm then estimates the rate (1 value), and the conditional 
	density (1 value per distance interval, as specified in the discretization section).

'CONVERGENCE' SECTION:
(1) convergence criterion for stopping the iteration. The convergence is tested by computing the difference
in logarithm of all the (non-zero) densities lambda_s(r,m) and rates lambda_t(t,m). The *largest* change,
either in density or rate, caused by the iteration is then compared to the criterion value. If it is smaller,
then the program stops. When the program is running, updated values (at each iteration) of this largest
change are displayed.

'OUTPUT' SECTION:
(1) suffix for the output files. All the input files will be given names like "quantitysuffix", where 
suffix can be blank, or have a dot, ... Example: using ".2nd_try" will causes the w0 file to be
named "w0.2nd_try"
(2) flags for outputing specific quantities. Say if the quantity must be saved (1) or not (0).
Note that the weight matrix w can be very big if the catalogue is long (N earthquakes in the
catalogue will result in saving a NxN matrix in ASCII format...).

Compile:
gcc -c misd.c
gcc misd.o -lm -o MISD 


