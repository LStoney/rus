# create sea-mask, and isolate only ocean data from global skin temp data

cdo addc,-1 land.sfc.gauss.nc 1.nc     # change values from land=1 sea=0 to
                                       # lane=0 sea=-1
cdo abs 1.nc sea_mask.nc               # sea=1

cdo -b 32 mul skt.sfc.mon.mean.nc sea_mask.nc SST.nc  #isolate sea values

rm 1.nc