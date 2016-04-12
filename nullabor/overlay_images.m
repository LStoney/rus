% Read in and display image 1.
image1 = imread('plots/SST_correlation/updated/jan.png');
%imshow(image1);
%title('image1');
%[rows1 cols1 colors1] = size(image1);
% Read in and display image 1.
image2 = imread('plots/SST_correlation/updated/jan_sig.png');
%subplot(2,2, 2);
%imshow(image2);
%title('image2');

% Resize image 2 to be the same size as image 1.
%image3 = imresize(image2, [rows1 cols1]);
%subplot(2,2, 3);
%imshow(image3);
%title('image3');

figure()
% Display image 1.
%subplot(2,2, 4);
ih1=imagesc(image1);
hold on;
% Display image 2 on top of it.
ih2=imagesc(image3);
hold off;
axis image;
% Make image 3 50% transparent.
alpha(ih2, 0.6);
title('Blended images');
%set(gcf, 'Position', get(0, 'ScreenSize')); % Maximize figure. 