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

colors = rand(10,3)*255;


[row_t column_t] = size(nordata);
label_list = zeros(row_t,1) + 1;


cluster_idx1 = clusterLabelData(nordata,label_list,1);
cluster_idx2 = clusterLabelData(nordata,cluster_idx1,1);
cluster_idx3 = clusterLabelData(nordata,cluster_idx2,2);
cluster_idx4 = clusterLabelData(nordata,cluster_idx3,1);
cluster_idx5 = clusterLabelData(nordata,cluster_idx4,2);
cluster_idx6 = clusterLabelData(nordata,cluster_idx5,3);
cluster_idx7 = clusterLabelData(nordata,cluster_idx6,4);







labelimg1 = reshape(cluster_idx1,row_img,column_img);
labelimg2 = reshape(cluster_idx2,row_img,column_img);
labelimg3 = reshape(cluster_idx3,row_img,column_img);

labelimg6 = reshape(cluster_idx6,row_img,column_img);
labelimg7 = reshape(cluster_idx7,row_img,column_img);




colorimg1 = colorLabelImg(labelimg1,colors);
colorimg2 = colorLabelImg(labelimg2,colors);
colorimg3 = colorLabelImg(labelimg3,colors);

colorimg6 = colorLabelImg(labelimg6,colors);
colorimg7 = colorLabelImg(labelimg7,colors);





global g_displayMatrixImage;
g_displayMatrixImage = 1;
figure
displayMatrixImage(1,2,3,img,colorimg1,colorimg2,colorimg3,colorimg6,colorimg7)
% displayMatrixImage(1,2,2,img,labelimg1*25,labelimg2*25,labelimg3*25)


