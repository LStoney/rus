# This scripts reads and filters the rain data for Mundrabilla (.csv format)
# The filtered data is sent to a new .dat file with the following variables
#
# for daily data: YEAR,MONTH,DAY,RAINFALL(mm),FLAG
# where flag=1 if the data has been quality checked, 0 if not.
#
#
# for monthly data: .... 
#
# AUTHOR: Lachlan Stoney
#         lgstoney@student.unimelb.edu.au
#





ln -s original_data/IDCJAC0009_011008_1800_Data.csv tmp1.d      # input file, daily data

ln -s original_data/IDCJAC0001_011008_Data1.csv tmp2.d      # input file, monthly data 1

ln -s original_data/IDCJAC0001_011008_Data12.csv tmp3.d      # input file, monthly data 2


############   FILTER DAILY RAINFALL DATA ################################

awk -F"," -v MISSVAL=-999 '

          NR < 2 {next}
                                            
          
          {
          
            if ( ($6>=0)  && (substr($8,1,1) == "Y" )   )
            {
               RAIN = $6
               VERIFIED=1              
            }
            else
            {
               RAIN = MISSVAL
               VERIFIED=0
            }
            
            if (($4>3) && ($4<11))          #summer rainfall
            { 
              SRAIN=MISSVAL            
            }
            else
            {
              SRAIN=RAIN
            }
         
            print $3,$4,$5,RAIN,SRAIN,VERIFIED
          
          }' tmp1.d > filtered_data/daily_filtered2.dat
          
          
          




############   FILTER MONTHLY RAINFALL DATA ################################

awk -F"," -v MISSVAL=NaN '                    # define missing value

         
          
          NR < 2  { next }                     # ignore first row of input file
          
          

          { 
           
           
           
           if ($5<0)                           # if rainfall data negative, then use MISSVAL
           { 
              RAINFALL = MISSVAL
           }
           else
           {
              RAINFALL = $5
           }
         
           
           if ( substr($6,1,1) == "Y" )        # if data is verified...
           {
              VERIFIED = 1
           }  
           else
           {
              VERIFIED = 0
           }
           
           
           
           
           
           MONTH = 10       # select particular month
           
                             # select data between Jan 1902 and Dec 2015
                   
           if (   ($3 > 1901)  && ($3 < 2016))
           
           
             if ($4==MONTH)
             {
               {
               print $3,$4,RAINFALL,VERIFIED
               }
             }
           
          if (  ($3==1972) && ($4==2)  )                            # Add in entries for March1979-Dec1983, with missing data
          {                                                         # otherwise there is a gap.
          
            if (MONTH>2)
            {
             print 1972,MONTH,MISSVAL,O
            }
            
            print 1973,MONTH,MISSVAL,0
            print 1974,MONTH,MISSVAL,0
            print 1975,MONTH,MISSVAL,0
            print 1976,MONTH,MISSVAL,0
            print 1977,MONTH,MISSVAL,0
            print 1978,MONTH,MISSVAL,0
            print 1979,MONTH,MISSVAL,0
            print 1980,MONTH,MISSVAL,0
            print 1981,MONTH,MISSVAL,0
            print 1982,MONTH,MISSVAL,0
            print 1983,MONTH,MISSVAL,0
            
          }
           
           if ( ($3==2011) && ($4==12) && (MONTH==01) )                   # Add in entry for Jan 2012, with missing data
           {                                                             # Otherwise there is a gap.
           print 2012,01,MISSVAL,0
           }



           }' tmp2.d > filtered_data/oct_filtered.dat             # save in output file




##################### FILTER FOR YEARLY AND SEASONAL DATA ################################

awk -F"," -v MISSVAL=NaN '                    # define missing value

         
          
          NR < 2  { next }                     # ignore first row of input file
          
          BEGIN {
          
          RESIDUAL=29.7                           # intialise variable for last years nov+dec rainfall
          
          }

          { 
           
           
                           
        
          # select data between 1902 and 2015
          
          if (   ($3 > 1901)  &&  ($3 < 2016) && !($3==1972))
          {
          
           SUMMER=$4+$5+$6+RESIDUAL
           WINTER=$9+$10+$11                     
           YEAR=$16
           
           if ($3==1984)
           {
             SUMMER=MISSVAL
           }
          
           if ($3==2012)
           {
             SUMMER=MISSVAL
             YEAR=MISSVAL
           }
           
           
          
          
           print $3,SUMMER,WINTER,YEAR
            
           RESIDUAL = $14+$15
          }
        
        
          if ($3 == 1972)
          {
            print 1972,MISSVAL,MISSVAL,MISSVAL
            print 1973,MISSVAL,MISSVAL,MISSVAL
            print 1974,MISSVAL,MISSVAL,MISSVAL
            print 1975,MISSVAL,MISSVAL,MISSVAL
            print 1976,MISSVAL,MISSVAL,MISSVAL
            print 1977,MISSVAL,MISSVAL,MISSVAL
            print 1978,MISSVAL,MISSVAL,MISSVAL
            print 1979,MISSVAL,MISSVAL,MISSVAL
            print 1980,MISSVAL,MISSVAL,MISSVAL
            print 1981,MISSVAL,MISSVAL,MISSVAL
            print 1982,MISSVAL,MISSVAL,MISSVAL
            print 1983,MISSVAL,MISSVAL,MISSVAL    
          }
        
        
           
        
           

           }' tmp3.d > filtered_data/yearTEST.dat            # save in output file





rm tmp1.d tmp2.d tmp3.d

