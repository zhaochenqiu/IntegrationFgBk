clear all
close all
clc

run('../config/config_tool');
img = double(imread('cars1_01.jpg'));
img = double(imread('cats03_0080.jpg'));


[row_img column_img byte_img] = size(img);


grayimg = grayImage(img);



data_list = reshape(grayimg,row_img*column_img,1);

imghistogram = hist(data_list,1:256);

fgcolor = [100 101 140];

color = [255 0 0
		180 180 180
		0 0 255
		240 70 240];

color = [255 0 0
        0 255 0 
        0 0 255];

hist = imghistogram;
[row_hist column_hist] = size(hist);

num = 32;
length = round(column_hist/num);

mark = findPeak_plus(hist,length);

[scale histimg] = histogram2image_plus(hist,fgcolor,mark,color);

% [scale5 histimg5] = histogram2image_plus(hist,fgcolor,mark,color,0.1);

index = mark == 1;
list = 0:1:255;
value = list(index);

labelimg = segmentImg(grayimg,value);

norimg = zeros(row_img,column_img,byte_img);


norlabelimg = segments2labels(labelimg);




global g_displayMatrixImage;
g_displayMatrixImage = 1;
figure
displayMatrixImage(1,2,2,grayimg,histimg,labelimg*20,norlabelimg*4)


% g_displayMatrixImage = 1;
% figure
% displayMatrixImage(1,1,5,histimg1,histimg2,histimg3,histimg4,histimg5);
