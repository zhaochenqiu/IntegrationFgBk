clear all
close all
clc

addpath('../../common_c/');
addpath('../../common/');

image = double(imread('d:/dataset/FBMS_Trainingset/Trainingset/horses01/horses01_0200.jpg'));



global g_displayMatrixImage 
g_displayMatrixImage = 1;
figure
displayMatrixImage(1,1,1,image)

[row_img column_img byte_img] = size(image);

image_list = reshape(image,row_img*column_img,byte_img);


num_cluster = 2;

[cluster_idx, cluster_center] = kmeans(image_list,num_cluster,'distance','sqEuclidean', 'Replicates',5);

all_idx = zeros(row_img*column_img,4);
all_idx(:,1) = cluster_idx;

temp_idx = zeros(row_img*column_img,1);


cluster_idx1 = cluster_idx == 1;
cluster_idx2 = cluster_idx == 2;


image_list1 = image_list(cluster_idx1,:);
image_list2 = image_list(cluster_idx2,:);

mean_list1 = cluster_center(1,:);
mean_list2 = cluster_center(2,:);

var(image_list1,0,1)
var(image_list2,0,1)


[cluster_idx_1, cluster_center_1] = kmeans(image_list1,num_cluster,'distance','sqEuclidean', 'Replicates',5);
[cluster_idx_2, cluster_center_2] = kmeans(image_list2,num_cluster,'distance','sqEuclidean', 'Replicates',5);


temp_idx(cluster_idx == 1) = cluster_idx_1;
temp_idx(cluster_idx == 2) = cluster_idx_2;
all_idx(:,2) = temp_idx;

segmented_images = cell(1,num_cluster^2);

count = 1;
for i = 1:2
	for j = 1:2
		index1 = all_idx(:,1) == i;
		index2 = all_idx(:,2) == j;

		index = index1 & index2;
		index = ~index;

		showimage = image_list;
		showimage(index,:) = 0;
		showimage = reshape(showimage,row_img,column_img,byte_img);
		segmented_images{count} = showimage;
		count = count + 1;
	end

end

g_displayMatrixImage = 1;
figure

displayMatrixImage(1,2,2,segmented_images{1},segmented_images{2},segmented_images{3},segmented_images{4})

