filein=$1
Nt=$2


for (( n=1; n<=$Nt; n++ ))
do


let a=$n-1
let a=$a*12
let a=$a+11
let b=$a+4




if [ $n -lt 10 ]
then
  ncra -F -d time,$a,$b $filein temp_0$n.nc
fi

if [ $n -ge 10 ]
then
  ncra -F -d time,$a,$b $filein temp_$n.nc
fi


done

ncrcat -h temp*nc summer_$filein
rm     temp*.nc



