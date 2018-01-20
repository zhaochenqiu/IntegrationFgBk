clear all
close all
clc

run('../config/config_tool');


img = double(imread('people05_0027.jpg'));
% img = double(imread('cars1_01.jpg'));
% img = double(imread('cats03_0080.jpg'));

[row_img column_img byte_img] = size(img);

[ximg yimg] = getPosImg(img);

data =reshape(img,row_img*column_img,byte_img);
xdata = reshape(ximg,row_img*column_img,1);
ydata = reshape(yimg,row_img*column_img,1);

data = [data xdata ydata];

nordata = normalRowData(data);

% nordata(:,4) = nordata(:,4) * 1.1;
% nordata(:,5) = nordata(:,5) * 1.1;




colors = rand(1564,3)*255;


[row_t column_t] = size(nordata);
label_list = zeros(row_t,1) + 1;

tic
labels1 = segmentNum(nordata,label_list,32);
time1 = toc;

tic
labels2 = segmentNum(nordata,labels1,64);
time2 = toc;

tic
labels3 = segmentNum(nordata,labels2,128);
time3 = toc;

time4 = 0;



labelimg1 = reshape(labels1,row_img,column_img);
labelimg2 = reshape(labels2,row_img,column_img);
labelimg3 = reshape(labels3,row_img,column_img);





colorimg1 = colorLabelImg(labelimg1,colors);
colorimg2 = colorLabelImg(labelimg2,colors);
colorimg3 = colorLabelImg(labelimg3,colors);

[time1 time2 time3 time4]

global g_displayMatrixImage;
g_displayMatrixImage = 1;
figure
displayMatrixImage(1,2,2,img,colorimg1,colorimg2,colorimg3)
%displayMatrixImage(1,2,3,img,colorimg4,colorimg7,colorimg8,colorimg9,colorimg11)

% displayMatrixImage(1,2,4,img,colorimg1,colorimg2,colorimg3,colorimg4,colorimg5,colorimg6,colorimg7)
% displayMatrixImage(1,2,2,img,labelimg1*25,labelimg2*25,labelimg3*25)
