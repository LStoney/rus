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
% type - 'monthly','yearly','summer','winter'
%
% var - variable in ncep file (e.g. 'mslp')

% Author: Lachlan Stoney







monthly_data1=importdata(rain_file);       % read filtered monthly data
m1year=monthly_data1(:,1);              % extract year info

%lines=78:113;                       %1979-2014   (for yearly, 
                                   
lines=79:114;                       %1980-2015    (for summer)




% ###### IMPORTANT ##########
% P=2 for summer data, P=3 for monthly data, P=4 for yearly data!!!!!

P=2;


m1rain=monthly_data1(:,P);             % extract rainfall data, read Pth position in dat file
m1rain=m1rain(lines);

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
rain_size=numel(m1rain);

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






% **************** CALCULATE CORRELATIONS **********************

R=ones(numel(x),numel(y))*NaN;

large_rain = ones(numel(x),numel(y),numel(t))*NaN;

for i=1:numel(x);                       % go through each x,y coordinate in ncep data
    for j=1:numel(y);
        
        field_time_series = field(i,j,:);
        field_time_series = reshape(field_time_series,numel(t),1);
        
        %field_time_series=detrend(field_time_series);             % DETREND does this handle missing values correctly?
        %field_time_series=filter([1,-1],1,field_time_series);      % FIRST DIFFERENCE
        
        for k=1:numel(t)                              
            
         
            
                                               % Reformat missing values to matlab "NaN"
            if (field_time_series(k) <= 0)
                field_time_series(k) = NaN;                
            end
            if (m1rain(k) < 0)
                m1rain(k) = NaN;
            end
            
            
            
        end
        
        
                                                 % calculate correlations
        
        %r=corrcoef(field_time_series,m1rain,'rows','complete');
        r=corrcoef(field_time_series,m1rain,'rows','pairwise');
        
        R(i,j)=r(1,2);
        
        


    end
end

figure(1)
contourf(x,y,R',20,'linestyle','none')
colorbar

figure(2)
m_proj('mercator');
m_coast;
m_grid;

hold on;
m_contourf(x,y,R',20,'linestyle','none')

x
y
end

