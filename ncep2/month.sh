#!/bin/sh

filein=$1
offset=$2
Nt=$3



for (( n=1; n<=$Nt; n++ ))
do


let a=$n-1
let a=$a*12
let a=$a+$offset

if [ $n -lt 10 ]
then
  ncks -F -d time,$a,$a $filein temp_0$n.nc
fi

if [ $n -ge 10 ]
then
  ncks -F -d time,$a,$a $filein temp_$n.nc
fi


done

ncrcat -h temp*nc month_$offset$filein
rm     temp*.nc



