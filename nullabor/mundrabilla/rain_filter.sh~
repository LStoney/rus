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


awk -F"," -v MISSVAL=-999 '                    # define missing value

         
          NR < 2  { next }                     # ignore first row of input file

          { 
           
           
           if ($6<0)                           # if rainfall data missing, then use MISSVAL
           { 
              RAINFALL = MISSVAL
           }
           else
           {
              RAINFALL = $6
           }
         
           
           if ( substr($8,1,1) == "Y" )        # if data is verified...
           {
              VERIFIED = 1
           }  
           else
           {
              VERIFIED = 0
           }
           
           
                             # select data between Jan 1979 and July 2015
                             
           if (   ($3 > 1983)  && (($3 < 2015) || ($4 <= 7))   && ($3 < 2016))
           {
           print count,$3,$4,$5,RAINFALL,VERIFIED
           }
        
           
           }' tmp1.d > filtered_data/daily_filtered.dat             # save in output file
           
           





############   FILTER MONTHLY RAINFALL DATA ################################

awk -F"," -v MISSVAL=-999 '                    # define missing value

         
          
          NR < 2  { next }                     # ignore first row of input file

          { 
           
           
           
           if ($5<0)                           # if rainfall data missing, then use MISSVAL
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
           
           
           MONTH = 12
           
                             # select data between Jan 1984 and July 2015
                   
           if (   ($3 > 1983)  && (($3 < 2015) || ($4 <= 7))   && ($3 < 2016))
           
           
             if ($4==MONTH)
             {
               {
               print $3,$4,RAINFALL,VERIFIED
               }
             }
           
           if ( ($3==2011) && ($4==12))                   # Add in entry for Jan 2012, with missing data
           {                                              # Otherwise there is a gap.
           #print 2012,01,MISSVAL,0
           }



           }' tmp2.d > filtered_data/dec_filtered.dat             # save in output file




##################### FILTER MONTHLY DATA2 ################################

awk -F"," -v MISSVAL=-999 '                    # define missing value

         
          
          NR < 2  { next }                     # ignore first row of input file
          
          BEGIN {
          
          RESIDUAL=0                           # intialise variable for last years nov+dec rainfall
          
          }

          { 
           
           
                           
        
        
        
           # select data between 1984 and 2015 
        
           if ($3==1984)
           {
             
             SUMMER=MISSVAL                      # nov-march rainfall
             WINTER=$9+10+$11                     # July-August rainfall
             YEAR=$16
             
             RESIDUAL = $14+$15                    
             
             print $3,SUMMER,WINTER,YEAR
           
           }
                   
                   
           if (   ($3 > 1984)  &&  ($3 < 2015) && !($3==2012))
           {
           
           
            SUMMER=$4+$5+$6+RESIDUAL                
            WINTER = $9+$10+$11                     
            YEAR = $16
          
            print $3,SUMMER,WINTER,YEAR
            
            RESIDUAL = $14+$15
           
           }
           
           if ($3==2012)
           {
              
              SUMMER=MISSVAL
              YEAR=MISSVAL
              
              print $3,SUMMER,WINTER,YEAR
              
              RESIDUAL = $14+$15
                   
           }
         
           
  
       



           }' tmp3.d > filtered_data/TEST.dat            # save in output file





rm tmp1.d tmp2.d tmp3.d

