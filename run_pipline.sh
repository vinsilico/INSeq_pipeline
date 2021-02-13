#!/bin/csh
rm *.ext
rm *.uqt
rm *.wig
rm extlist.txt
rm uniqlist.txt
rm bedlist.txt
ls *.bed > extlist.txt
perl extract_columns_list.pl
ls *.ext > uniqlist.txt
perl map_unique_list_para.pl
ls *.uqt > bedlist.txt
perl TAmapparallel_list_1.pl
ls -l
