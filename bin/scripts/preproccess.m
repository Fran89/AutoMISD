#!/usr/bin/octave -qf
#
#       preproccess.m
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

tic();
catalog = CSVInput(1,arg_list{2});
export4misd(catalog,'Ocat.dat');
calc_misdMcorr(catalog,'Ocor.dat');
csvwrite('Icat.csv', catalog)
elapsed = toc();
printf("Catalogs prepared in %.4f seconds\n", elapsed);

