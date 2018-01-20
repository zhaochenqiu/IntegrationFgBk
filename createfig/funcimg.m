function re_img = funcimg(img);

[row_img column_img byte_img] = size(img);

re_img = zeros(row_img,column_img,3);

if byte_img == 3
    re_img = img;
else
    for i = 1:3
        re_img(:,:,i) = img;
    end
end

