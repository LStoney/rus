% This script reads the rain data from Mundrabilla.
% The original data (in .csv format) must have been filtered already by the
% script rain_filter.sh - The present script reads the filtered data
%
% Author: Lachlan Stoney

% OPEN RAIN DATA

%cd ~/Desktop/rus/nullabor/mundrabilla/

daily_data=importdata('filtered_data/daily_filtered.dat');               % read filtered daily data
monthly_data1=importdata('filtered_data/monthly_filtered1.dat');       % read filtered monthly data





%  Test daily data


dyear=daily_data(:,1);             % extract year info
drain=daily_data(:,4);             % extract rainfall data

figure(1);
plot(drain);    
ylim([0 130]);
title('daily rainfall (mm)')


% Test monthyl data 

m1year=monthly_data1(:,1);             % extract year info
m1rain=monthly_data1(:,3);             % extract rainfall data


figure(2);
plot(m1rain);    
title('monthly rainfall (mm)')


