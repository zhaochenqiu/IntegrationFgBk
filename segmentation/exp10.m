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

convimg = zeros(row_img,column_imgbyte_img);
convolution_c(convimg, image, template);

matlabels = segmentation_kmeans(convimg);

maxlabel = max(max(matlabels));

colors = rand(maxlabel,3)*255;
showimage = convimg;
allimage = zeros(row_img,column_img,byte_img);

global g_displayMatrixImage 
g_displayMatrixImage = 1;

figure
for i = 1:maxlabel
	label = i;

	color = colors(i,:);

	index = matlabels == label;

	rimage = convimg(:,:,1)*0.5 + color(1)*0.5;
	gimage = convimg(:,:,2)*0.5 + color(2)*0.5;
	bimage = convimg(:,:,3)*0.5 + color(3)*0.5;

	index = ~index;

	rimage(index) = 0;
	gimage(index) = 0;
	bimage(index) = 0;

	showimage(:,:,1) = rimage;
	showimage(:,:,2) = gimage;
	showimage(:,:,3) = bimage;
	

	allimage = allimage + showimage;

end

g_displayMatrixImage = 1;
figure
displayMatrixImage(1,1,1,allimage)
