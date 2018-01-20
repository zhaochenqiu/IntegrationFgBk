function [re_ximg re_yimg] = getPosImg(img)

[row_img column_img byte_img] = size(img);

re_ximg = zeros(row_img,column_img);
re_yimg = zeros(row_img,column_img);

for i = 1:row_img
    for j = 1:column_img
        re_ximg(i,j) = j;
        re_yimg(i,j) = i;
    end
end
