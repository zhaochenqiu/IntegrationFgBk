function [re_labelimg re_numlabels] = segmentImg_SLIC_rand_msk(img,num,maskimg,factor,scale)

if nargin == 4
    scale = 4;
end

[row_img column_img byte_img] = size(img);

len = row_img*column_img;

fglist = reshape(maskimg,len,1);

pos = find(fglist == 255);


center = [];


if min(size(pos)) == 0
    len = row_img*column_img;

    center = round(rand(num,1)*len);
else
    lenpos = max(size(pos));

    index = round(rand(num,1)*lenpos);
    tempindex = index < 1;
    index(tempindex) = 1;
    tempindex = index > lenpos;
    index(tempindex) = lenpos;

    center = pos(index);
end


len = row_img*column_img;

seedIndices = zeros(row_img*column_img,1);

center = unique(center);

num = max(size(center));

for i = 1:num
    value = center(i);
    value = min([value len]);
    value = max([value 1]);

    seedIndices(i) = value;
end

labelimg = zeros(row_img,column_img);
numlabels = 1;

try
[labelimg, numlabels] = slicmex_q(uint8(img),num,factor,seedIndices,scale);
catch
    disp('there is a error in segmentImg_SLIC_rand_msk');
    labelimg = zeros(row_img,column_img);
    numlabels = 1;
    input('press any key to continue!');
end

re_labelimg     = labelimg;
re_numlabels    = numlabels;
