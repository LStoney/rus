function [] = spatial_correlation(rain_file,ncep_file,type,var)

% This function calculates the spatial correlations between the rainfall
% data at one station (Mundrabilla) and gridded SST or MSLP data. The
% output is a geographical grid of correlation coefficients. 
%
% INPUTS:
% 
% rain_file - path of filtered rainfall data (string)
%             e.g. 'mundrabilla/filtered_data/jan_filtered.dat'
%
% ncep_file - path of modified gridded data. e.g.
%            '../NCEP/SST/month_1SST.nc' or '../ERSST/summer_ersst.nc'   
%             misleading variable name: doesn't have to be ncep data!
%
% type - 'monthly','yearly','summer','winter'  -goes in plot title
%
% var - variable in ncep file (e.g. 'mslp','sst','skt')
%
% (Please see LOG.odt for info on the filtered/modified data files)
%
% The lengths of rain_file and ncep_file must be equal. 
%
%
% Author: Lachlan Stoney    lgstoney@student.unimelb.edu.au







monthly_data1=importdata(rain_file);       % read filtered monthly data
m1year=monthly_data1(:,1);              % extract year info


% read only these lines/dates of the rainfall data

% FOR NCEP

%lines=78:113;                       %1979-2014   (for yearly,aug-dec)                                    
%lines=79:114;                       %1980-2015    (for summer)
%lines=78:114;                          %1979-2015 (for jan-july)

% daily NCEP
%lines=35430:35795;
%lines=35430:37621; 
%lines=35735:35885;

%ERSST and HADSST

lines=1:114;            %1902-2015  ,all months, yearly
%lines=2:114;             %1903-2015, summer

% ###### IMPORTANT ##########
% P=2 for summer data, P=3 for monthly data /winter, P=4 for yearly/daily data!!!!!
P=3;
m1rain=monthly_data1(:,P);             % extract rainfall amounts, read Pth position in dat file
rain=m1rain(lines);
years=m1year(lines);




% Optional test with NINO3.4 data
% i.e replace rainfall time series with NINO3.4 time series. Need to 

%{
ninodata=importdata('../nina34.data');
years=ninodata(:,1);
M=2;   % M=2 (Jan)....M=13 (Dec)
m1rain=ninodata(:,M);
%rain=m1rain(32:68);
%years=years(32:68);

% for ersst
%rain=m1rain(3:68);
%years=years(3:68);
%}



button = questdlg('Have you set the correct values of ''P'' and ''lines'' ?');

if (strcmp(button,'Yes')==0)
    return
end



% OPEN GRIDDED DATA
% Again, 'ncep_file' is a misleading variable name. ncep_file can refer
% to any gridded dataset (e.g ersst)

field=ncread(ncep_file,var)+10000;
y=ncread(ncep_file,'lat');
%y=ncread(ncep_file,'latitude');
x=ncread(ncep_file,'lon');
%x=ncread(ncep_file,'longitude')
t=ncread(ncep_file,'time');
%t=t(305:455);

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



format long
fprintf('\n\n using the following years and rainfall amounts...\n\n')
fprintf('\n\n rain years // reanalysis years  //  rainfall')
%[years,1800+((t/24)/365),rain]
[years,1800+(t/365),rain]






% **************** CALCULATE CORRELATIONS **********************

R=ones(numel(x),numel(y))*NaN;      % initialise correlation field
R2=R;                               % make a copy for later

for k=1:numel(t)               % Reformat missing values in rain data to matlab "NaN"
   
     if (rain(k) < 0)
        rain(k) = NaN ;
     end     
end

rain=nan_detrend(rain);            % detrend rain data
rain=filter([1,-1],1,rain);        % calculate first differences




for i=1:numel(x);                       % go through each x,y coordinate in gridded data
    for j=1:numel(y);
        
        field_time_series = field(i,j,:);      % extract time series at this location
        field_time_series = reshape(field_time_series,numel(t),1);
        
        N=0;
            
        for k=1:numel(t)                                 % Reformat missing values to matlab "NaN"
            if (field_time_series(k) <= 0)
                field_time_series(k) = NaN;        
            end                                      
        end
               
        
        field_time_series=nan_detrend(field_time_series);             % DETREND does this handle missing values correctly?
        field_time_series=filter([1,-1],1,field_time_series);      % FIRST DIFFERENCES
      
         % NOTE: first differencing and detrending may introduce negative numbers
        
            
            
               % CALCULATE CORRELATIONS AND P-VALUES
        
        %[r,p]=corrcoef(field_time_series,rain,'rows','pairwise');
        
        % Change the variable 'type' to reflect the correlation type.
        % e.g. 'Pearson','Spearman','Kendall'
        
        [r,p]=corr(field_time_series,rain,'rows','pairwise','type','Spearman');

        
        %P=p(1,2);            % p value / statistical significance
        PP=p;
        
        %R(i,j)=r(1,2);       % correlation coefficient       
        %R2(i,j)=r(1,2);      % copy
        
        R(i,j)=r;             
        R2(i,j)=r;           
        
        if (PP>0.05)          % only plot significant correlations
           R(i,j)=NaN; 
        end
        

       
        
        

    end
end


% ******************** PLOT DATA **********************

% Use package m_map for map projections,coastlines, etc.


% global plot, significant correlations only
figure()
contourf(x,y,R',20,'linestyle','none')
hold on
cb=colorbar;


% global plots, all correlations
figure()
contourf(x,y,R2',20,'linestyle','none')
hold on
cb=colorbar;


% Aus region, all corelations
figure()
m_proj('Hammer-Aitoff','lon',[50,210],'lat',[-50 10]);
m_coast('linewidth',1,'color','k');
m_grid;
hold on;
m_contourf(x,y,R2',20,'linestyle','none')
title(strcat(var,{' // '},type));
colorbar;

% Aus region, significant correlations only

figure()
m_proj('Hammer-Aitoff','lon',[50,210],'lat',[-50 10]);
m_coast('linewidth',1,'color','k');
m_grid;

hold on;
m_contourf(x,y,R',20,'linestyle','none')
title(strcat(var,{' // '},type));
hold on;
colorbar;




end

