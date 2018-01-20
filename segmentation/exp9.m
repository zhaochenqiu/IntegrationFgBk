clear all
close all
clc


addpath('../../common_c/');
addpath('../../common/');

image = double(imread('d:/dataset/FBMS_Trainingset/Trainingset/horses01/horses01_0200.jpg'));


template = [1 2 1
			2 8 2
			1 2 1];

[row_img column_img byte_img] = size(image);

convimg = zeros(row_img,column_img,byte_img);

convolution_c(convimg, image, template);




matlabels = segmentation_kmeans(convimg);

showimage = convimg;
maskimage = zeros(row_img,column_img);
allimage = showimage - showimage;

maxlabels = max(max(matlabels));

figure
imshow(uint8(matlabels*5))



global g_displayMatrixImage 
g_displayMatrixImage = 1;

figure
for i = 1:maxlabels
	label = i;
	index = matlabels ~= label;

	rimage = convimg(:,:,1);
	gimage = convimg(:,:,2);
	bimage = convimg(:,:,3);

	rimage(index) = 0;
	gimage(index) = 0;
	bimage(index) = 0;

	showimage(:,:,1) = rimage;
	showimage(:,:,2) = gimage;
	showimage(:,:,3) = bimage;

	index = ~index;
	maskimage = maskimage - maskimage;
	maskimage(index) = 255;
	

	pixelnum = sum(sum(matlabels == label));
	pixelnum

	allimage = allimage + showimage;

	displayMatrixImage(1,1,3,maskimage,showimage,allimage)

	input('pause')
end

