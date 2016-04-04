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


% read only these lines/dates of the rainfall data
%lines=78:113;                       %1979-2014   (for yearly,aug-dec)                                    
%lines=79:114;                       %1980-2015    (for summer)
lines=78:114;                          %1979-2015 (for jan-july)



% ###### IMPORTANT ##########
% P=2 for summer data, P=3 for monthly data, P=4 for yearly data!!!!!
P=3;

m1rain=monthly_data1(:,P);             % extract rainfall data, read Pth position in dat file
rain=m1rain(lines);
years=m1year(lines);




% Optional test with NINO3.4 data
% Test with january ncep data
%
ninodata=importdata('../nina34.data');
years=ninodata(:,1);
M=2;   % M=2 (Jan)....M=13 (Dec)
m1rain=ninodata(:,M);
rain=m1rain(32:68);
years=years(32:68);
%}



button = questdlg('Have you set the correct values of ''P'' and ''lines'' ?');

if (strcmp(button,'Yes')==0)
    return
end



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

size(years)
size(t)
size(rain)


format long
fprintf('\n\n using the following years and rainfall amounts...\n\n')
fprintf('\n\n rain years // reanalysis years  //  rainfall')
[years,1800+((t/24)/365),rain]







% **************** CALCULATE CORRELATIONS **********************

R=ones(numel(x),numel(y))*NaN;

for k=1:numel(t)               % Reformat missing values to matlab "NaN"
   
     if (rain(k) < 0)
        rain(k) = NaN ;
     end     
end

rain=nan_detrend(rain);
rain=filter([1,-1],1,rain);




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
               
        
        field_time_series=nan_detrend(field_time_series);             % DETREND does this handle missing values correctly?
        field_time_series=filter([1,-1],1,field_time_series);      % FIRST DIFFERENCE
      
         % NOTE: first differencing and detrending may introduce negative numbers
        
            
            
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

%{
figure()
contourf(x,y,R2',20,'linestyle','none')
hold on
cb=colorbar;
c=axis;
cmin=c(1,1);
cmax=c(1,2);
%}

figure()
m_proj('Hammer-Aitoff','lon',[50,210],'lat',[-50 10]);
m_coast('linewidth',1,'color','k');
m_grid;
hold on;
m_contourf(x,y,R2',20,'linestyle','none')
title(strcat(var,{' // '},type));
colorbar;
%caxis([-0.8 0.8]);

figure()
m_proj('Hammer-Aitoff','lon',[50,210],'lat',[-50 10]);
m_coast('linewidth',1,'color','k');
m_grid;

hold on;
m_contourf(x,y,R',20,'linestyle','none')
title(strcat(var,{' // '},type));
hold on;
colorbar;
%caxis([-1 1]);
%}



end

