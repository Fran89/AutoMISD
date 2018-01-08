#!/bin/sh
#
#       Shell_script.sh
#       
#       Copyright 2011 Francisco Hernandez <FJHernandez89@gmail.com>
#       
#       This program is free software; you can redistribute it and/or modify
#       it under the terms of the GNU General Public License as published by
#       the Free Software Foundation; either version 2 of the License, or
#       (at your option) any later version.
#       
#       This program is distributed in the hope that it will be useful,
#       but WITHOUT ANY WARRANTY; without even the implied warranty of
#       MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#       GNU General Public License for more details.
#       
#       You should have received a copy of the GNU General Public License
#       along with this program; if not, write to the Free Software
#       Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
#       MA 02110-1301, USA.
#       
#       

# Grab our current directory and cd into it
CurDir="$( cd "$( dirname "$0" )" && pwd )"
cd $CurDir

# Create our I/O Directories
echo "Creating directories"
  mkdir -p Input
  mkdir -p Output
echo "Done creating directories"

# Read catalog
echo "Type the catalog that you wish to proccess, followed by [ENTER](Default: Catalog.csv):"
  read catalog
  catalog=${catalog:-Catalog.csv}
  cp $catalog $CurDir/Input/Icat.dat
echo "Selected catalog: $catalog"

# Begin Pre-Proccessing
echo "Begin pre-proccessing the catalog"
  octave $CurDir/bin/scripts/preproccess.m $CurDir/bin/scripts/ $CurDir/Input/Icat.dat
  mv Ocat.dat ./Input
  mv Ocor.dat ./Input
echo "Catalog pre-proccessing done"

# Prep MISD
if [ ! -f $CurDir/bin/misd/misd ]; then
  echo "MISD executable does not exist, creating..."
  cd $CurDir/bin/misd
  gcc misd.c -lm -o misd
  cd $CurDir
else
  echo "MISD executable exist"
fi

# Prep Input for MISD
if [ ! -f $CurDir/Input/MISD.in ]; then
  echo "MISD input files does not exist, creating..."
  echo "*______ DATA ______
* CATALOGUE FILE NAME
$CurDir/Input/Ocat.dat
* # COLUMN FOR (1) time (2) magnitude (3) latitude (4) longitude [NB: 1st column is \"1\", not \"0\"]
1 2 3 4
* ARE THE EPICENTRES REALLY IN (LAT,LON) OR RATHER IN (X,Y) FORMAT (1/0)?
1
* CORRECTION FOR DETECTION (0/1)? IF yes (1), THEN FOLLOW WITH NAME OF FILE CONTAINING THE CORRECTION VALUES
*1 $CurDir/Input/Ocor.dat
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
0.1
*______ OUTPUT _______
* SUFFIX FOR OUTPUT FILES
_Out
* SAVE mbin, tbin, rbin, lambda_t, lambda_s, lambda0, w, w0 (0/1 for each)?
1 1 1 1 1 1 0 1" > $CurDir/Input/MISD.in
else
  echo "It seem we already have an MISD Input file, continuing..."
fi

echo "Please verify any remaining edits to the MISD input file in the Input folder"
read -p "Press enter to continue" na

# Begin MISD
echo "Begining MISD Run"
  cd Output
  $CurDir/bin/misd/misd $CurDir/Input/MISD.in
  cd $CurDir
echo "MISD Done"

# Define threshold
  read -p "Define threshold for background event (Default 0.001): " thres 
  thres=${thres:-0.001}

# Begin Post-Proccessing
echo "Begining post-proccessing"
  octave $CurDir/bin/scripts/postproccess.m $CurDir/bin/scripts/ $CurDir/Input/Icat.dat $CurDir/Output/w0_Out $thres
  mv DCCatalog.csv ./Output
  mv CCatalog.csv  ./Output
echo "Post-proccessing done"

