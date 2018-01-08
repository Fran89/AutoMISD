#!/usr/bin/octave -qf
#
#       postproccess.m
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

# Grab our arguments.
arg_list = argv();
addpath(arg_list{1});
thres = str2double(arg_list{4});

tic();
catalog = CSVInput(1,arg_list{2});
vM=load(arg_list{3});
vDC=(vM(:,1) >  thres);
vCC=(vM(:,1) <= thres);
DC=catalog(vDC,:);
CC=catalog(vCC,:);
csvwrite('DCCatalog.csv', DC);
csvwrite('CCatalog.csv' , CC);
elapsed = toc();
printf("Catalog prepared in %.4f seconds\n", elapsed);

