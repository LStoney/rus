% This script reads and plots some rainfall data and some netcdf data
% The original rain data (in .csv format) must have been filtered already by the
% script rain_filter.sh - The present script reads the filtered data in dat
% format
%
% Author: Lachlan Stoney lgstoney@student.unimelb.edu.au



% OPEN RAIN DATA


daily_data=importdata('mundrabilla/filtered_data/daily_filtered.dat');               % read filtered daily data
monthly_data=importdata('mundrabilla/filtered_data/jan_filtered.dat');       % read filtered monthly data



%  Plot daily data


dyear=daily_data(:,1);             % extract year info
drain=daily_data(:,4);             % extract rainfall data


figure(1);
plot(drain);    
ylim([0 130]);
title('daily rainfall (mm)')


% Plot monthly data 

myear=monthly_data(:,1);             % extract year info
mrain=monthly_data(:,3);             % extract rainfall data


figure(2);
plot(mrain);    
title('monthly rainfall (mm)')





% OPEN NETCDF DATA

netcdf_file='../ncep1/MSLP1/month_1slp.nc';

netcdf_data=ncread(netcdf_file,'slp');

y=ncread(netcdf_file,'lat');
x=ncread(netcdf_file,'lon');
t=ncread(netcdf_file,'time');

    

% plot first time point

time=11;
frame=netcdf_data(:,:,time);

figure();
contourf(x,y,frame',20,'linestyle','none');   % contour plot
c=colorbar;
xlabel('Longitude');
ylabel('Latitude');
ylabel(c,'Sea Level Pressure (hPa)');

% plot Region of Interest with coastline (this uses the custom package
% m_map)

figure()
m_proj('Hammer-Aitoff','lon',[50,210],'lat',[-50 10]);
m_coast('linewidth',1,'color','k');
m_grid;
hold on;
m_contourf(x,y,frame',20,'linestyle','none')
c=colorbar;
xlabel('Longitude');
ylabel('Latitude');
ylabel(c,'Sea Level Pressure (hPa)');


% calculate zonal means from netcdf data

band=zeros(numel(y));     % create empty matrix

for i=1:numel(y)         % loop through each latitude value
       
        band(i)=mean(netcdf_data(1:numel(x),i,time));   % calculate zonal means
       
end


figure();
plot(y,band)             % plot zonal means
ylim([980 1030])
ylabel('Zonal Mean Sea Level Pressure (hPa)');
xlabel('Latitude');
title( strcat('time=',num2str(time)) );
