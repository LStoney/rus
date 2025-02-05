filein=$1

# This script does the following:
# Take the netcdf file filein (gridded data set, >0 monthly time steps).
# Create a record of only the january months. Same for feb-dec months. Use script month.sh
# Create a record of yearly means. Use script year.sh
# Create a record of summers (Nov_March). Use script summer.sh
# " " winters " " winter.sh
#
# usage: bash reformat_field.sh filein
# 
# The individual scripts (e.g. winter.sh) can be used on their own and edited, if necessary.
#
# Specify inside this script the number of expected months, years, summers, etc.
#
# e.g. if there are 77 januaries in filein, then edit the
# first statement to say 'bash month.sh $filein 1 77'
# Sometimes there is one less summer than the total number of years. 
# This is because you need the previous year's nov and dec to calculate
# the summer mean.
#
# AUTHOR: Lachlan Stoney          lgstoney@student.unimelb.edu.au

bash month.sh $filein 1 114
bash month.sh $filein 2 114
bash month.sh $filein 3 114
bash month.sh $filein 4 114
bash month.sh $filein 5 114
bash month.sh $filein 6 114
bash month.sh $filein 7 114
bash month.sh $filein 8 114
bash month.sh $filein 9 114
bash month.sh $filein 10 114
bash month.sh $filein 11 114
bash month.sh $filein 12 114

bash year.sh $filein 114

bash summer.sh $filein 113

bash winter.sh $filein 114
