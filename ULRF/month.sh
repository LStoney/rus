#!/bin/sh

filein=$1
offset=$2      # number of month e.g Nov=11, Feb=2
Nt=$3          # number of occurences of said month in filein



for (( n=1; n<=$Nt; n++ ))      # repeat this Nt times...
do


let a=$n-1
let a=$a*12
let a=$a+$offset               # the time index in filein corresponding 
                               # to the nth FEB (if offset=2, for example).



if [ $n -lt 10 ]
then
  ncks -F -d time,$a,$a $filein temp_00$n.nc       # extract this month
fi

if [ $n -ge 10 -a $n -lt 100 ]
then
  ncks -F -d time,$a,$a $filein temp_0$n.nc
fi

if [ $n -ge 100 ]
then
  ncks -F -d time,$a,$a $filein temp_$n.nc
fi


done

ncrcat -h temp*nc month_$offset$filein        # concatenate individual months in to single file
rm     temp*.nc



