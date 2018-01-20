clear all
close all
clc

run('../config/config_tool');


img = double(imread('people05_0027.jpg'));
% img = double(imread('cars1_01.jpg'));
% img = double(imread('cats03_0080.jpg'));

tic
labelimg = segmentImg_rand(img,20);
time = toc;
time

colorimg = colorLabelImg(labelimg);

global g_displayMatrixImage;
g_displayMatrixImage = 1;
figure
displayMatrixImage(1,1,3,img,labelimg,colorimg)
