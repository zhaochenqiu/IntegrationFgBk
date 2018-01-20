function [re_labelimg re_numlabels] = segmentImg_SLIC_rand(img,num,bkcues,factor,scale)

if nargin == 3
    scale = 4;
end

[row_img column_img byte_img] = size(img);

len = row_img*column_img;

seedIndices = zeros(row_img*column_img,1);
center = round(rand(num,1)*len);


for i = 1:num
    value = center(i);
    value = min([value len]);
    value = max([value 1]);

    seedIndices(i) = value;
end

[labelimg, numlabels] = slicmex_q(uint8(img),num,factor,seedIndices,scale);

re_labelimg     = labelimg;
re_numlabels    = numlabels;
