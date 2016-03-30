function [ output_args ] = correlation_test(file1,var1,file2,var2 )


% This function calculates the correlation field of two reanalysis 
% variables. Testing this against cdo to see if the two methods agree.
% i.e. test the output of this function against that of:
%
% cdo -b 32 timcor file1 file2 
%
% file1,file2 are the locations of the two reanalysis files (strings)
% var1,var2 are the reanalysis variable names. e.g. 'temp','pres' 
%
% file1 and file2 must have the same grid and number of time steps
%
% 
% AUTHOR: Lachlan Stoney

data1=ncread(file1,var1);
data2=ncread(file2,var2);

y=ncread(file1,'lat');
x=ncread(file1,'lon');
t=ncread(file1,'time');

%R=ones(numel(x),numel(y))*NaN;

for i=1:numel(x);                       % go through each x,y coordinate 
    for j=1:numel(y);
   
        
        series1 = data1(i,j,:);
        series1 = reshape(series1,numel(t),1);
        
        series2 = data2(i,j,:);
        series2 = reshape(series2,numel(t),1);
        
        r=corrcoef(series1,series2,'rows','complete');
      
        
        R(i,j)=r(1,2);
        
    end
end


contourf(x,y,R',100,'linestyle','none')
colorbar

end


