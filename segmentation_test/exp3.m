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

nordata = data;

[row_t column_t] = size(data);

for i = 1:column_t
    tempdata = nordata(:,i);

    value = max(tempdata);

    tempdata = tempdata/value;

    nordata(:,i) = tempdata;
end


num_cluster = 2;

[cluster_idx, cluster_center] = kmeans(nordata,num_cluster,'distance','sqEuclidean', 'Replicates',10);

labelimg = reshape(cluster_idx,row_img,column_img);

global g_displayMatrixImage;
g_displayMatrixImage = 1;
figure
displayMatrixImage(1,1,2,img,labelimg*50)


