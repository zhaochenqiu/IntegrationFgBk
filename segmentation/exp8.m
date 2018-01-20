clc


addpath('../../common_c/');
addpath('../../common/');

image = double(imread('d:/dataset/FBMS_Trainingset/Trainingset/horses01/horses01_0190.jpg'));

global g_displayMatrixImage 
g_displayMatrixImage = 1;
figure
displayMatrixImage(1,1,1,image)

[row_img column_img byte_img] = size(image);

image_list = reshape(image,row_img*column_img,byte_img);

len_img = row_img*column_img;

all_labels = [];





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
labels = zeros(len_img,1);
index = labels == 0;

[labels_clu image_list1 image_list2] = segment_base(image_list,labels,index);
all_labels = [all_labels labels_clu];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
index1 = labels_clu == 1;
index2 = labels_clu == 2;

[labels_clu1 image_list1_1 image_list1_2] = segment_base(image_list1,labels,index1);
[labels_clu2 image_list2_1 image_list2_2] = segment_base(image_list2,labels,index2);

templabels = labels_clu1 + labels_clu2;


all_labels = [all_labels templabels];
all_idx = all_labels;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
index1_1 = labels_clu1 == 1;
index1_2 = labels_clu1 == 2;
index2_1 = labels_clu2 == 1;
index2_2 = labels_clu2 == 2;

[labels_clu1_1 image_list1_1_1 image_list1_1_2] = segment_base(image_list1_1,labels,index1_1);
[labels_clu1_2 image_list1_2_1 image_list1_2_2] = segment_base(image_list1_2,labels,index1_2);
[labels_clu2_1 image_list2_1_1 image_list2_1_2] = segment_base(image_list2_1,labels,index2_1);
[labels_clu2_2 image_list2_2_1 image_list2_2_2] = segment_base(image_list2_2,labels,index2_2);

templabels = labels_clu1_1 + labels_clu1_2 + labels_clu2_1 + labels_clu2_2;


all_labels = [all_labels templabels];
all_idx = all_labels;



segmented_images = cell(1,2^3);

count = 1;
for i = 1:2
	for j = 1:2
		for q = 1:2
			index1 = all_idx(:,1) == i;
			index2 = all_idx(:,2) == j;
			index3 = all_idx(:,3) == q;

			index = index1 & index2 & index3;
			index = ~index;

			showimage = image_list;
			showimage(index,:) = 0;
			showimage = reshape(showimage,row_img,column_img,byte_img);
			segmented_images{count} = showimage;
			count = count + 1;
		end
	end

end

g_displayMatrixImage = 1;
figure

displayMatrixImage(1,2,4,segmented_images{1},segmented_images{2},segmented_images{3},segmented_images{4},segmented_images{5},segmented_images{6},segmented_images{7},segmented_images{8})


