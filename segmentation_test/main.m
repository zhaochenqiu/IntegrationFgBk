clear all
close all
clc

run('../config/config_tool');
img = double(imread('cars1_01.jpg'));

[row_img column_img byte_img] = size(img);


grayimg = grayImage(img);



data_list = reshape(grayimg,row_img*column_img,1);

imghistogram = hist(data_list,1:255);

fgcolor = [100 101 140];

color = [255 0 0
		180 180 180
		0 0 255
		240 70 240];

hist = imghistogram;
[row_hist column_hist] = size(hist);

num = 8;
length = round(column_hist/num);

mark = findPeak_plus(hist,length);


[scale1 histimg1] = histogram2image_plus(hist);

[scale2 histimg2] = histogram2image_plus(hist,fgcolor);

[scale3 histimg3] = histogram2image_plus(hist,fgcolor,mark);

[scale4 histimg4] = histogram2image_plus(hist,fgcolor,mark,color);

% [scale5 histimg5] = histogram2image_plus(hist,fgcolor,mark,color,0.1);

global g_displayMatrixImage;
g_displayMatrixImage = 1;
figure
displayMatrixImage(1,2,3,img,grayimg,histimg1,histimg2,histimg3,histimg4);

% g_displayMatrixImage = 1;
% figure
% displayMatrixImage(1,1,5,histimg1,histimg2,histimg3,histimg4,histimg5);
