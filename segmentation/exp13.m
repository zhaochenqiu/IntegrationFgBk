clear all
close all
clc


addpath('../../common_c/');
addpath('../../common/');

image1 = double(imread('d:/dataset/FBMS_Trainingset/Trainingset/horses01/horses01_0200.jpg'));
image2 = double(imread('d:/dataset/FBMS_Trainingset/Trainingset/horses01/horses01_0190.jpg'));


template = [0 1 0
			1 4 1
			0 1 0];

[row_img1 column_img1 byte_img1] = size(image1);
[row_img2 column_img2 byte_img2] = size(image2);


convimg1 = zeros(row_img1,column_img1,byte_img1) + image1;
convimg2 = zeros(row_img2,column_img2,byte_img2) + image2;

convolution_c(convimg1, image1, template);
convolution_c(convimg2, image2, template);



matlabels1 = segmentation_kmeans(convimg1);
matlabels2 = segmentation_kmeans(convimg2);


clrimg1 = colorSegments(matlabels1,convimg1);
clrimg2 = colorSegments(matlabels2,convimg2);



global g_displayMatrixImage
g_displayMatrixImage = 1;
figure
displayMatrixImage(1,1,2,clrimg1,clrimg2)

objects1 = segments2superpixels(matlabels1,convimg1);
objects2 = segments2superpixels(matlabels2,convimg2);




