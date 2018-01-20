clear all
close all
clc

run('../config/config_tool');


img = double(imread('cars1_01.jpg'));
img = double(imread('cats03_0080.jpg'));

[row_img column_img byte_img] = size(img);

[ximg yimg] = getPosImg(img);

data =reshape(img,row_img*column_img,byte_img);
xdata = reshape(ximg,row_img*column_img,1);
ydata = reshape(yimg,row_img*column_img,1);

data = [data xdata ydata];

nordata = normalRowData(data);


[row_t column_t] = size(nordata);
label_list = zeros(row_t,1) + 1;

cluster_idx = clusterLabelData(nordata,label_list,1);


labelimg = reshape(cluster_idx,row_img,column_img);

global g_displayMatrixImage;
g_displayMatrixImage = 1;
figure
displayMatrixImage(1,1,2,img,labelimg*50)


