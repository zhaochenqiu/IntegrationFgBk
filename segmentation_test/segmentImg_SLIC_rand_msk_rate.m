function [re_labelimg re_numlabels] = segmentImg_SLIC_rand_msk_rate(img,rate,maskimg,factor,scale)

if nargin == 4
    scale = 4;
end

[row_img column_img byte_img] = size(img);

len = row_img*column_img;

fglist = reshape(maskimg,len,1);

pos = find(fglist == 255);


global segment_minnum;

if ~exist('segment_minnum','var') 
    segment_minnum = 8;
end

num = round(sum(sum(fglist == 255))*rate + 0.5);

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

[labelimg, numlabels] = slicmex_q(uint8(img),num,factor,seedIndices,scale);

re_labelimg     = labelimg;
re_numlabels    = numlabels;
