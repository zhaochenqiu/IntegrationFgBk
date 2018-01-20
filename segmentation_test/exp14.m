clear all
close all
clc

run('../config/config_tool');


img = double(imread('people05_0027.jpg'));
% img = double(imread('cars1_01.jpg'));
% img = double(imread('cats03_0080.jpg'));

[row_img column_img byte_img] = size(img);

colorTransform = makecform('srgb2lab');
lab = applycform(uint8(img), colorTransform);

lab = double(lab);

L_Image = lab(:, :, 1);  % Extract the L image.
A_Image = lab(:, :, 2);  % Extract the A image.
B_Image = lab(:, :, 3);  % Extract the B image.


global g_displayMatrixImage;
g_displayMatrixImage = 1;
displayMatrixImage(1,1,3,L_Image,A_Image,B_Image)

figure
imshow(lab);


input('pause')
[ximg yimg] = getPosImg(img);


data =  reshape(img,row_img*column_img,byte_img);
xdata = reshape(ximg,row_img*column_img,1);
ydata = reshape(yimg,row_img*column_img,1);

data = [data xdata ydata];

nordata = normalRowData(data);

num = 4000;

center_x = round(rand(num,1)*row_img);
center_y = round(rand(num,1)*column_img);

center_labels = 0:num;
center_labels = center_labels';

center_clr = zeros(num,3);

for i = 1:num
    posx = center_x(i);
    posy = center_y(i);

    posx = max([1 posx]);
    posy = max([1 posy]);

    posx = min([posx column_img]);
    posy = min([posy row_img]);

    center_x(i) = posx;
    center_y(j) = posy;

    center_clr(i,:) = img(posy,posx,:);
end

center_data = [center_clr center_x center_y];

center_data = normalRowData(center_data);

[row_t column_t] = size(nordata);

labels = zeros(row_t,1);


for i = 1:row_t
    entrydata = nordata(i,:);

    tempdata = center_data;

    for j = 1:column_t;
        tempdata(:,j) = abs(tempdata(:,j) - entrydata(j));
    end

    distance = mean(tempdata,2);

    pos = find(distance == min(distance));
    pos = pos(1);

    labels(i) = center_labels(pos);
end

labelimg = reshape(labels,row_img,column_img);


colorimg = colorLabelImg(labelimg);

global g_displayMatrixImage;
g_displayMatrixImage = 1;
figure
displayMatrixImage(1,1,3,img,labelimg,colorimg)
