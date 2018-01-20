clear all
close all
clc

run('../config/config_tool');


img = double(imread('people05_0027.jpg'));
% img = double(imread('cars1_01.jpg'));
% img = double(imread('cats03_0080.jpg'));

[row_img column_img byte_img] = size(img);



num_multi = 56;
num_factor = 10;

len = row_img*column_img;

seedIndices = zeros(row_img*column_img,1);
center = round(rand(num_multi,1)*len);


for i = 1:num_multi
    value = center(i);
    value = min([value len]);
    value = max([value 1]);

    seedIndices(i) = value;
end



[labelimg, numlabels] = slicmex_q(uint8(img),num_multi,num_factor,seedIndices);


colorimg = colorLabelImg(labelimg);

global g_displayMatrixImage;
g_displayMatrixImage = 1;
figure
displayMatrixImage(1,1,3,img,labelimg,colorimg)
