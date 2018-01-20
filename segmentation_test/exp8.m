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
labels1 = segmentMax(nordata,label_list);
time1 = toc;

tic
labels2 = segmentMax(nordata,labels1);
time2 = toc;

tic
labels3 = segmentMax(nordata,labels2);
time3 = toc;

tic
labels4 = segmentMax(nordata,labels3);
time4 = toc;

tic
labels5 = segmentMax(nordata,labels4);
time5 = toc;

tic
labels6 = segmentMax(nordata,labels5);
time6 = toc;

tic
labels7 = segmentMax(nordata,labels6);
time7 = toc;

tic
labels8 = segmentMax(nordata,labels7);
time8 = toc;

tic
labels9 = segmentMax(nordata,labels8);
time9 = toc;

labels10 = segmentMax(nordata,labels9);
labels11 = segmentMax(nordata,labels10);





labelimg1 = reshape(labels1,row_img,column_img);
labelimg2 = reshape(labels2,row_img,column_img);
labelimg3 = reshape(labels3,row_img,column_img);
labelimg4 = reshape(labels4,row_img,column_img);
labelimg5 = reshape(labels5,row_img,column_img);
labelimg6 = reshape(labels6,row_img,column_img);
labelimg7 = reshape(labels7,row_img,column_img);
labelimg8 = reshape(labels8,row_img,column_img);
labelimg9 = reshape(labels9,row_img,column_img);
labelimg10 = reshape(labels10,row_img,column_img);
labelimg11 = reshape(labels11,row_img,column_img);








colorimg1 = colorLabelImg(labelimg1,colors);
colorimg2 = colorLabelImg(labelimg2,colors);
colorimg3 = colorLabelImg(labelimg3,colors);
colorimg4 = colorLabelImg(labelimg4,colors);
colorimg5 = colorLabelImg(labelimg5,colors);
colorimg6 = colorLabelImg(labelimg6,colors);
colorimg7 = colorLabelImg(labelimg7,colors);
colorimg8 = colorLabelImg(labelimg8,colors);
colorimg9 = colorLabelImg(labelimg9,colors);
colorimg10 = colorLabelImg(labelimg10,colors);
colorimg11 = colorLabelImg(labelimg11,colors);








[time1 time2 time3 time4 time5 time6 time7 time8]

global g_displayMatrixImage;
g_displayMatrixImage = 1;
figure
displayMatrixImage(1,2,3,img,colorimg4,colorimg7,colorimg8,colorimg9,colorimg11)

% displayMatrixImage(1,2,4,img,colorimg1,colorimg2,colorimg3,colorimg4,colorimg5,colorimg6,colorimg7)
% displayMatrixImage(1,2,2,img,labelimg1*25,labelimg2*25,labelimg3*25)
