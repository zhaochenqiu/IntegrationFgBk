%======================================================================
%SLIC demo
% Copyright (C) 2015 Ecole Polytechnique Federale de Lausanne
% File created by Radhakrishna Achanta
% Please also read the copyright notice in the file slicmex.c 
%======================================================================
%Input parameters are:
%[1] 8 bit images (color or grayscale)
%[2] Number of required superpixels (optional, default is 200)
%[3] Compactness factor (optional, default is 10)
%
%Ouputs are:
%[1] labels (in raster scan order)
%[2] number of labels in the image (same as the number of returned
%superpixels
%
%NOTES:
%[1] number of returned superpixels may be different from the input
%number of superpixels.
%[2] you must compile the C file using mex slicmex.c before using the code
%below
%======================================================================
%img = imread('someimage.jpg');


clear all
close all
clc

addpath('../../../common_c/');
addpath('../../../common/');


% img = imread('bee.jpg');

img = imread('E:/dataset/FBMS_Trainingset/Trainingset/horses01/horses01_0190.jpg');




[labels, numlabels] = slicmex(img,100,5);%numlabels is the same as number of superpixels
imagesc(labels);

global g_displayMatrixImage 
g_displayMatrixImage = 1;
figure
displayMatrixImage(1,1,1,labels)

maxlabel = max(max(labels));
showimg = img;

g_displayMatrixImage = 1;
figure
for i = 1:maxlabel
	label = i;

	index = labels ~= label;
	rimg = img(:,:,1);
	gimg = img(:,:,2);
	bimg = img(:,:,3);

	rimg(index) = 0;
	gimg(index) = 0;
	bimg(index) = 0;

	showimg(:,:,1) = rimg;
	showimg(:,:,2) = gimg;
	showimg(:,:,3) = bimg;

	displayMatrixImage(1,1,1,showimg)
	input('pause')
end

