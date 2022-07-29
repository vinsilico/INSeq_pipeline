#script to check whether a barcode (coordinate) correspond to TA motif in the wig file. 
#The input file will have more 10 million reads


#!/usr/bin/env python
import collections
import os
import sys
import pandas as pd
import numpy as np
import readline

#Usage : python script.py inputfile TA_wigfile 

#Read the files from the command line
passed=str(sys.argv)
wkdir=os.getcwd()
IP_File=wkdir+'/'+str(sys.argv[1])
IP_File2=wkdir+'/'+str(sys.argv[2])

#print names of input file and TA wig file
print ("File 1:", IP_File)
print ("File 2:", IP_File2)

bedfile = open(IP_File, 'r')
TAfile = open(IP_File2, 'r')
subfolders_list=[]
subfolders = IP_File.split(".")
subfoldername = subfolders[0]
File_name = subfoldername.split("/")
#print ("File:", File_name[-1])

#Read in the TA coordinate from wig file
TA_data=[]
for line in TAfile:
    items = line.rstrip('\r\n').split('\t')
    items = [item.strip() for item in items]
    TA_data.append(items)

#Read only the T coordinate position into a list
TA_data1=open(IP_File2,"r")
lines=TA_data1.readlines()
TA_start=[]
for value in lines:
    TA_start.append(value.split('\t')[1])
TA_data1.close()

#converting the T coordinate from string to integer dType
TA_start = list(map(int, TA_start))

TA_start_plus = []
TA_start_minus = []
TA_start_plus = [x+1 for x in TA_start]
TA_start_minus = [x-1 for x in TA_start]

#Read the input file into a dataframe and add column header
datasetB = pd.read_csv(IP_File, sep=" ", delimiter="\t",  header=None)
datasetB.columns = ["ID", "BC", "Rep","Coord", "Strand", "Col6", "Col7", "Col8", "Col9", "COl10"] 

#Sort the dataframe by coordinate
datasetB = datasetB.sort_values(by=['Coord'])

#check for the presence T, T+1 and T-1 coordinate in the the infput file
datasetB['F_srt'] = datasetB.Coord.isin(TA_start).astype(int)
datasetB['F_srt_p'] = datasetB.Coord.isin(TA_start_plus).astype(int)
datasetB['F_srt_m'] = datasetB.Coord.isin(TA_start_minus).astype(int)

#filter 
datasetG = datasetB.query('F_srt == 1')
datasetH = datasetB.query('F_srt_m == 1')
datasetJ = datasetB.query('F_srt_p == 1')

frames = [datasetG, datasetH, datasetJ]
datasetK = pd.concat(frames)
print(datasetK)
datasetC = datasetK[(datasetK['F_srt'] == 1) | (datasetK['F_srt_p'] == 1) | (datasetK['F_srt_m'] == 1)]
datasetD = datasetK.drop(columns=['F_srt','F_srt_p','F_srt_m'])
datasetC.to_csv(wkdir+'/'+'TA_check-NTA-'+File_name[-1]+'.txt', header=False, index=False, sep='\t')
datasetD.to_csv(wkdir+'/'+'TA_filter-NTA-'+File_name[-1]+'.txt', header=False, index=False, sep='\t')
print("Output files written")
