function [re_labelimg re_numlabels] = segmentImg_SLIC_rand_fg(img,num,fgcues,factor,scale)

if nargin == 4
    scale = 4;
end

[row_img column_img byte_img] = size(img);

len = row_img*column_img;

fglist = reshape(fgcues,len,1);

pos = find(fglist == 255);


center = [];


if min(size(pos)) == 0
    len = row_img*column_img;

    center = round(rand(num,1)*len);
else
    lenpos = max(size(pos));

    index = round(rand(num,1)*lenpos);

    center = pos(index);
end


len = row_img*column_img;

seedIndices = zeros(row_img*column_img,1);

for i = 1:num
    value = center(i);
    value = min([value len]);
    value = max([value 1]);

    seedIndices(i) = value;
end

[labelimg, numlabels] = slicmex_q(uint8(img),num,factor,seedIndices,scale);

re_labelimg     = labelimg;
re_numlabels    = numlabels;
