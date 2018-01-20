function re_img = clearTemplateImg(img,labelimg,label,color)

if nargin == 3
    color = [-1 -1 -1];
end

[row_img column_img byte_img] = size(img);

if byte_img == 1
    byte_img = 3;
    re_img = zeros(row_img,column_img,3);
    for i = 1:byte_img
        re_img(:,:,i) = img;
    end
    img = re_img;
else
    re_img = img;
end


index = labelimg == label;
index = ~index;
for i = 1:byte_img
    tempimg = img(:,:,i);

    tempimg(index) = color(i);

    re_img(:,:,i) = tempimg;
end
