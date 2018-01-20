function re_img = getMaskImg(img,mask)

[row_img column_img byte_img] = size(img);

index_r = mask(:,:,1) == 255;
index_g = mask(:,:,2) == 0;
index_b = mask(:,:,3) == 0;

index = index_r & index_g & index_b;

tempimg = img(:,:,1);
size(index)

rimg = tempimg(index);

[row_t column_t byte_t] = size(rimg);

re_img = zeros(row_t,column_t,byte_img);

for i = 1:byte_img
    tempimg = img(:,:,i);
    re_img(:,:,i) = tempimg(index);
end

