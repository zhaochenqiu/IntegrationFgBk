clear all
close all
clc


addpath('../../common_c/');
addpath('../../common/');


%he = imread('d:/dataset/FBMS_Trainingset/Trainingset/horses01/horses01_0200.jpg');
he = imread('d:/dataset/FBMS_Trainingset/Trainingset/horses01/horses01_0200.jpg');

	 
cform = makecform('srgb2lab');
lab_he = applycform(he,cform);



ab = double(he);

[nrows ncols nbyte] = size(ab);


ab = reshape(ab,nrows*ncols,nbyte);

nColors = 2;
% repeat the clustering 3 times to avoid local minima
[cluster_idx, cluster_center] = kmeans(ab,nColors,'distance','sqEuclidean', ...
                                      'Replicates',5);

pixel_labels = reshape(cluster_idx,nrows,ncols);


segmented_images = cell(1,nColors);
rgb_label = repmat(pixel_labels,[1 1 3]);



for k = 1:nColors
    color = he;
    color(rgb_label ~= k) = 0;
    segmented_images{k} = color;
end
figure
imshow(segmented_images{1}), title('objects in cluster 1');

figure
imshow(segmented_images{2}), title('objects in cluster 2');
