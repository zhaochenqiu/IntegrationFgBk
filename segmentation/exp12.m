clear all
close all
clc

addpath('../../common_c/');
addpath('../../common/');


image = double(imread('test.png'));

figure
imshow(uint8(image))


grayimg = grayImage(image);

[row_img column_img byte_img] = size(image);

rate_gas = 0.2;
threshold_objcnt = 64;


splitimage = image;
objmask		= zeros(row_img,column_img);
objimage	= zeros(row_img,column_img,byte_img);

judgemask = zeros(row_img,column_img);

length = row_img * column_img;

stack1 = zeros(length,2);
stack2 = zeros(length,2);

imginfo = zeros(1,3);
posinfo = zeros(1,5);


count = 0;
threshold_const = 2;

posr = 1;
posc = column_img;

% fillFlood(splitimage,objimage,judgemask,objmask,[posr posc],rate_gas,threshold_const,stack1,stack2,imginfo,posinfo);

fillFlood(splitimage,objimage,judgemask,objmask,[posr posc],stack1,stack2,imginfo,posinfo);


global g_displayMatrixImage
g_displayMatrixImage = 1;
figure
displayMatrixImage(1,1,3,objimage,judgemask,objmask)




