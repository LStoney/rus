



ln -s original_data/IDCJAC0009_011008_1800_Data.csv tmp1.d      # input file, daily data






############   FILTER DAILY RAINFALL DATA ################################


awk -F"," -v MISSVAL=-999 '                    # define missing value

        
         
          NR < 2  { next }                     # ignore first row of input file

          BEGIN{
          
          count=0
          }

          { 
           
       
           
           if ( substr($8,1,1) == "Y" )        # if data is verified...
           {
              VERIFIED = 1
           }  
           else
           {
              VERIFIED = 0
           }
           
           
           
                             # select summer data between 1979 and 2016
                             
           if (   ($3 > 1998) && ($3 < 2016) && ( ($4>10) || ($4<4) ) && (VERIFIED==1) )
           {  
             if ($6>=5)
             {
               count=count+1
               print count,$3,$4,$5,$6,$7,VERIFIED
             }
        
           }
           
           
           
           }' tmp1.d > filtered_data/high_rainfall_days.txt             # save in output file
           
           


rm tmp1.d


