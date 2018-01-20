clear all
close all
clc

run('../config/config_tool');

img = double(imread('soafimg.png'));

index = img == 255;
img(index) = 0;

fgimg = doubleThreshold(img,0.7*255,0.3*255,8);

fgimg(index) = 255;

imwrite(fgimg,'result.png');
