function [] = spatial_correlation(rain_file,ncep_file,type,var)

% This function calculates the spatial correlation field between NCEP
% reanalysis data and rainfall data from one station (Mundrabilla).
% The user specifies the input files, which can be monthly,seasonal,
% or yearly data. 
%
% INPUTS:
% 
% rain_file - path of filtered rainfall data (string)
% ncep_file - path of filtered ncep reanalysis file (string)
%
% examples....
%
% type - 'monthly','yearly','summer','winter'  ******currently does nothing!
%
% var - variable in ncep file (e.g. 'mslp')

% Author: Lachlan Stoney







monthly_data1=importdata(rain_file);       % read filtered monthly data
m1year=monthly_data1(:,1);              % extract year info

lines=78:113;                       %1979-2014   (for yearly,                                    
%lines=79:114;                       %1980-2015    (for summer)
%lines=78:114                          %1979-2015 (for jan,



% ###### IMPORTANT ##########
% P=2 for summer data, P=3 for monthly data, P=4 for yearly data!!!!!

P=3;


m1rain=monthly_data1(:,P);             % extract rainfall data, read Pth position in dat file
rain=m1rain(lines);
years=m1year(lines);


fprintf('\n\n ??? Have you set P=3 for monthly data,P=4 for yearly data, etc. ????\n\n')
% ############################




% OPEN NCEP DATA

field=ncread(ncep_file,var);
y=ncread(ncep_file,'lat');
x=ncread(ncep_file,'lon');
t=ncread(ncep_file,'time');


% make sure length of rain data record matches size of ncep data

ncep_size=size(field);
ncep_size=ncep_size(3);
rain_size=numel(rain);

if (ncep_size == rain_size)
    fprintf('length of ncep data record matches length of rain record...\n\n')
else
    fprintf('WARNING: length of ncep data record does not match length of rain record...\n\n')
end

%L=379;
L=36;


if (rain_size == L);
     fprintf('length of rain record matches Jan1984 - July2015 period...\n\n ');
else
     fprintf('WARNING: length of rain record does not match Jan1984 - July2015 period...\n\n')
end    

fprintf('\n\n using the following years and rainfall amounts...\n\n')
[years,rain]







% **************** CALCULATE CORRELATIONS **********************

R=ones(numel(x),numel(y))*NaN;

for k=1:numel(t)               % Reformat missing values to matlab "NaN"
   
     if (rain(k) < 0)
        rain(k) = NaN ;
     end     
end

rain=filter([1,-1],1,rain);
%rain=detrend(rain);



for i=1:numel(x);                       % go through each x,y coordinate in ncep data
    for j=1:numel(y);
        
        field_time_series = field(i,j,:);
        field_time_series = reshape(field_time_series,numel(t),1);
        
        N=0;
            
        for k=1:numel(t)                                 % Reformat missing values to matlab "NaN"
            if (field_time_series(k) <= 0)
                field_time_series(k) = NaN;        
            end                                      
        end
               
        
        %field_time_series=detrend(field_time_series);             % DETREND does this handle missing values correctly?
        field_time_series=filter([1,-1],1,field_time_series);      % FIRST DIFFERENCE
        
     
        
            
            
                                                 % calculate correlations
        
        %r=corrcoef(field_time_series,m1rain,'rows','complete');
        [r,p]=corrcoef(field_time_series,rain,'rows','pairwise');
        
        P=p(1,2);            % p value / statistical significance
        
        R(i,j)=r(1,2);       % correlation coefficient
        R2(i,j)=r(1,2);      % copy
        
        if (P>0.05)          % only plot significant correlations
           R(i,j)=NaN; 
        end
        


    end
end


figure(1)
contourf(x,y,R2',20,'linestyle','none')
colorbar

%
figure(2)
m_proj('Hammer-Aitoff','lon',[50,210],'lat',[-50 10]);
m_coast('linewidth',1,'color','k');
m_grid;

hold on;
m_contourf(x,y,R',20,'linestyle','none')
hold on;
%m_contourf(x,y,R',20,'linestyle','none')
colorbar
%}


end

