filein=$1
Nt=$2                  # number of june-august winters in filein


for (( n=1; n<=$Nt; n++ ))
do


let a=$n-1
let a=$a*12
let a=$a+6
let b=$a+2

# want to take average between time indices a and b in filein


if [ $n -lt 10 ]
then
  ncra -F -d time,$a,$b $filein temp_00$n.nc
fi

if [ $n -ge 10 -a $n -lt 100 ]
then
  ncra -F -d time,$a,$b $filein temp_0$n.nc
fi

if [ $n -ge 100 ]
then
  ncra -F -d time,$a,$b $filein temp_$n.nc
fi


done

ncrcat -h temp*nc winter_$filein       # concatenate into single file
rm     temp*.nc



