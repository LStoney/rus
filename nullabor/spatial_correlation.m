function [] = spatial_correlation(rain_file,ncep_file,type,var)

% This function calculates the spatial correlations between the rainfall
% data at one station (Mundrabilla) and gridded SST or MSLP data. The
% output is a geographical grid of correlation coefficients. 
%
% INPUTS:
% 
% rain_file - path of filtered rainfall data (string)
%             e.g. 'mundrabilla/filtered_data/jan_filtered.dat'
%             or
%             'mundrabilla/filtered_data/summer_winter_yearly_filtered.dat'
%
% ncep_file - path of modified gridded data. e.g.
%            '../NCEP/SST/month_1SST.nc' or '../ERSST/summer_ersst.nc'   
%             misleading variable name: doesn't have to be ncep data!
%
% type - 'monthly','yearly','summer','winter'  -goes in plot title
%
% var - variable in ncep file (e.g. 'mslp','sst','skt','olr','ulwrf')
%     - use 'skt' if opening ncep sst data. 'slp' for ncep1 slp data.
%     - 'mslp' for ncep2 mslp data.
%
% (Please see LOG.odt for info on the filtered/modified data files)
%
% The lengths of rain_file and ncep_file must be equal. MAKE SURE THE 
% YEARS/MONTHS IN THE TWO FILES MATCH!
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
lag=1;             
%lines=35430:35795;
%lines=35430:37621; 
%lines=(35430+lag):(37621+lag);
%lines=35735:35885;

%lines=47:114;          % 1948-2015 MSLP1 / ULRF
%lines=48:114;          % 1949-2015 summer


% OLR
%lines=75:112;


%For ERSST and HADSST
lines=1:114;            %1902-2015  ,all months, yearly, winter
%lines=2:114;             %1903-2015, summer data




% ###### IMPORTANT ##########
% P=2 for summer data, P=3 for monthly data  or winter data, P=4 for yearly
% data. If reading the file daily_filtered.dat, then P=4 for daily
% rainfall,P=5 for only summer daily rainfall.

P=3;
m1rain=monthly_data1(:,P);             % extract rainfall amounts, read Pth position in dat file
rain=m1rain(lines);
years=m1year(lines);






% ****************  Optional test with NINO3.4 data *********************

% i.e this replaces rainfall time series with NINO3.4 time series. 
% This reads the data from the file /rus/nina43.data
% Use 1950-2015
%{
ninodata=importdata('../nina34.data');
years=ninodata(:,1);
M=12;   % M=2 (Jan)....M=13 (Dec)
m1rain=ninodata(:,M);
%rain=m1rain(32:68);    % if using ncep data
%years=years(32:68);

% if using ERSST data
rain=m1rain(3:68);
years=years(3:68);
% Need to edit code to read only these dates of the gridded data as well.
% i.e. at line 116 t=t(49:114) and line 174 field(i,j,49:114)
%}
% ***********************************************************************




button = questdlg('Have you set the correct values of ''P'' and ''lines'' ?');
if (strcmp(button,'Yes')==0)
    return
end



% OPEN GRIDDED DATA
% Again, 'ncep_file' is a misleading variable name. ncep_file can refer
% to any gridded dataset (e.g ersst)

field=ncread(ncep_file,var);
y=ncread(ncep_file,'lat');
%y=ncread(ncep_file,'latitude');
x=ncread(ncep_file,'lon');
%x=ncread(ncep_file,'longitude')
t=ncread(ncep_file,'time');
%t=t(49:114);



ncep_size=size(field);
ncep_size=ncep_size(3);
rain_size=numel(rain);




format long
fprintf('\n\n using the following years and rainfall amounts...\n\n')
fprintf('\n\n rain years // reanalysis years  //  rainfall')
%[years,1800+((t/24)/365),rain]
[years,1800+(t/365),rain]        %ersst






% **************** CALCULATE CORRELATIONS **********************

R=ones(numel(x),numel(y))*NaN;      % initialise correlation field
R2=R;                               % make a copy for later
AC=R;                               % intialise autocorrelation field

for k=1:numel(t)               % Reformat missing values in rain data to matlab "NaN"
   
     if (rain(k) < 0)
        rain(k) = NaN ;
     end     
end

%rain=nan_detrend(rain);            % detrend rain data
rain=filter([1,-1],1,rain);        % calculate first differences




for i=1:numel(x);                       % go through each x,y coordinate in gridded data
    for j=1:numel(y);
        
        field_time_series = field(i,j,:);      % extract time series at this location
        field_time_series = reshape(field_time_series,numel(t),1);
        
       
            
        for k=1:numel(t)                                 % Reformat missing values to matlab "NaN"
            if (field_time_series(k) <= 0)
                field_time_series(k) = NaN;        
            end                                      
        end
               
        
     
        
        %field_time_series=nan_detrend(field_time_series);             % DETREND does this handle missing values correctly?
        field_time_series=filter([1,-1],1,field_time_series);      % FIRST DIFFERENCES
      
        
            
        [G,H]=corr(field_time_series(1:end-1),field_time_series(2:end),'rows','pairwise','type','Spearman'); %autocorrelate gridded data
        
        if (G>0)
          AC(i,j)=G;     % keep positive autocorrelation values              
        end
        
        
               % CALCULATE CORRELATIONS AND P-VALUES
        
        
        
        % Change the variable 'type' to reflect the correlation type.
        % e.g. 'Pearson','Spearman','Kendall'
        
        [r,p]=corr(field_time_series,rain,'rows','pairwise','type','Spearman');

        
        PP=p;         % statistical p=value

        
        R(i,j)=r;    % correlation coefficient         
        R2(i,j)=r;           
        
        if (PP>=0.05)          % only plot significant correlations
           R(i,j)=NaN; 
        else
           %R2(i,j)=NaN;
        end
        

       
        
        

    end
end


% ******************** PLOT DATA **********************

% Use package m_map for map projections,coastlines, etc.



% TEST : global plot of autocorrelation coefficients 
figure(1)
contourf(x,y,AC',20,'linestyle','none')
hold on
cb=colorbar;
title('AUTOCORRELATION COEFFICIENTS')



% global plot, significant correlations only
figure(2)
contourf(x,y,R',20,'linestyle','none')
hold on
cb=colorbar;



% global plots, all correlations
figure(3)
h=contourf(x,y,R2',20,'linestyle','none');
hold on
cb=colorbar;




% Aus region, all corelations
figure(4);
m_proj('Hammer-Aitoff','lon',[50,210],'lat',[-50 10]);
m_coast('linewidth',1,'color','k');
m_grid;
hold on;
m_contourf(x,y,R2',20,'linestyle','none')
%title(strcat(var,{' // '},type));
colorbar;
[cmin cmax]=caxis;
saveas(figure(4),'TEST1.png')
%print('TEST1.png','-dpng','-r300');



% Aus region, significant correlations only

figure(5);
m_proj('Hammer-Aitoff','lon',[50,210],'lat',[-50 10]);
m_coast('linewidth',1,'color','k');
m_grid;
hold on;
m_contourf(x,y,R',20,'linestyle','none');
title(strcat(var,{' // '},type,{' // p<0.05'}));
colorbar;
caxis([cmin cmax]);
saveas(figure(5),'TEST2.png')
%print('TEST2.png','-dpng','-r300');











% overlayed images - insignificant correlations greyed out
%
figure(6)
image1=imread('TEST1.png');
image2=imread('TEST2.png');
[rows1 cols1 colors1] = size(image1);
ih1=imagesc(image1);
hold on;
ih2=imagesc(image2);
hold off;
alpha(ih2, 0.2);
axis equal
ylim([200 700])
%}

end

