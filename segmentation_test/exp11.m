clear all
close all
clc

run('../config/config_tool');


img = double(imread('people05_0027.jpg'));
% img = double(imread('cars1_01.jpg'));
% img = double(imread('cats03_0080.jpg'));

tic
[labelimg num labels] = segmentImg_bin(img,4);
time = toc

colorimg = colorLabelImg(labelimg);

global g_displayMatrixImage;
g_displayMatrixImage = 1;
figure
displayMatrixImage(1,1,3,img,labelimg,colorimg)
