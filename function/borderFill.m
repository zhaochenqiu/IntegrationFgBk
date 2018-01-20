function re_img = borderFill(img,value,range)

if nargin == 2
    range = 10;
end

[row_img column_img byte_img] = size(img);

indeximg = zeros(row_img,column_img) + 255;

indeximg(range:row_img - range + 1,range:column_img - range + 1) = 0;

index = indeximg == 255;

re_img = img;
for i = 1:byte_img
    tempimg = re_img(:,:,i);
    tempimg(index) = value;
    re_img(:,:,i) = tempimg;
end
