function re_img = mergeImg(template,img)

[row_tmp column_tmp byte_tmp] = size(template);
[row_img column_img byte_img] = size(img);

% the mask of img is red color
indexr = img(:,:,1) == 255;
indexg = img(:,:,2) == 0;
indexb = img(:,:,3) == 0;

index = indexr & indexg & indexb;
index = ~index;

for i = 1:byte_img
    tempimg = template(:,:,i);
    curimg = img(:,:,i);

    tempimg(index) = curimg(index);

    template(:,:,i) = tempimg;
end

re_img = template;
