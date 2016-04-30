# This scripts reads and filters the rain data for Eucla (.csv format)
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







ln -s original_data/IDCJAC0001_011003_Data1.csv tmp2.d      # input file, monthly data 1

ln -s original_data/IDCJAC0001_011003_Data12.csv tmp3.d      # input file, monthly data 2


############   FILTER DAILY RAINFALL DATA ################################





############   FILTER MONTHLY RAINFALL DATA ################################

awk -F"," -v MISSVAL=NaN '                    # define missing value

         
          
          NR < 2  { next }                     # ignore first row of input file
          
          
          BEGIN {
          
          #m=0
          residual=MISSVAL
          }
     
     
          
          {
             
            if ($4=="null")
            {                   
              january=MISSVAL
              m=m+1
            }
            else
            {
              january=$4
            }  
 
            if ($5=="null")
            {                   
              february=MISSVAL
              m=m+1
            }
            else
            {
              february=$5
            }  

 
            if ($6=="null")
            {                   
              march=MISSVAL
              m=m+1
            }
            else
            {
              march=$6
            }  

 
            if ($7=="null")
            {                   
              april=MISSVAL
              m=m+1
            }
            else
            {
              april=$7
            }  

 
            if ($8=="null")
            {                   
              may=MISSVAL
              m=m+1
            }
            else
            {
              may=$8
            }  

 
            if ($9=="null")
            {                   
              june=MISSVAL
              m=m+1
            }
            else
            {
              june=$9
            }  

 
            if ($10=="null")
            {                   
              july=MISSVAL
              m=m+1
            }
            else
            {
              july=$10
            }  

 
            if ($11=="null")
            {                   
              august=MISSVAL
              m=m+1
            }
            else
            {
              august=$11
            }  

 
            if ($12=="null")
            {                   
              september=MISSVAL
              m=m+1
            }
            else
            {
              september=$12
            }  

 
            if ($13=="null")
            {                   
              october=MISSVAL
              m=m+1
            }
            else
            {
              october=$13
            }  

 
            if ($14=="null")
            {                   
              november=MISSVAL
              m=m+1
            }
            else
            {
              november=$14
            }  

 
            if ($15=="null")
            {                   
              december=MISSVAL
              m=m+1
            }
            else
            {
              december=$15
            }  
            
            
                    
            if (substr($16,1,4) == "null")
            {                   
              yearly=MISSVAL                       
            }
            else
            {
              yearly=$16  
            }
         

          if ($3>2016)
          { 
            print $3,01,january
            print $3,02,february
            print $3,03,march
            print $3,04,april
            print $3,05,may
            print $3,06,june
            print $3,07,july
            print $3,08,august
            print $3,09,september
            print $3,10,october
            print $3,11,november
            print $3,12,december                                            
          }  
           
           
          if ($3==19277)
          {
            print 1928,01,MISSVAL
            print 1928,02,MISSVAL
            print 1928,03,MISSVAL
            print 1928,04,MISSVAL
            print 1928,05,MISSVAL
            print 1928,06,MISSVAL
            print 1928,07,MISSVAL
            print 1928,08,MISSVAL
            print 1928,09,MISSVAL
            print 1928,10,MISSVAL
            print 1928,11,MISSVAL
            print 1928,12,MISSVAL
            m=m+12            
          } 
         
  
          
          
          if (($3>1875) && ($3<2016))
          {
          
          
            if ( (residual >= 0) && (january >= 0) && (february >= 0) && (march >= 0) )
            {
               #summer = november+december+january+february+march
               summer = residual+january+february+march
            }
            else
            {
               summer = MISSVAL
            }
          
            if ( (november >= 0) && (december >= 0) )
            {
               residual=november+december
            }
            else
            {
              residual=MISSVAL
            }       
          
            if ( (june >= 0) && (july >= 0) && (august >= 0) )
            {
               
               winter=june+july+august
            }
            else
            {
               winter = MISSVAL
            }
          
          
        
          
            print $3,summer,winter,yearly
            #print $3,summer
          }
      
          
          if ($3==1927)
          {
            #print 1928,MISSVAL
            print 1928,MISSVAL,MISSVAL,MISSVAL
            residual=MISSVAL
          }
      
      
           }' tmp3.d > filtered_data/TEST.dat             # save in output file

rm tmp*.d



