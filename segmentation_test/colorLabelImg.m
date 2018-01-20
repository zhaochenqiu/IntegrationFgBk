function re_img = colorLabelImg(labelimg,colors)

[row_img column_img byte_img] = size(labelimg);
maxnum = max(max(labelimg));

if nargin == 1
    colors = rand(maxnum + 3,3) * 255;
end

re_img = zeros(row_img,column_img,3);

for i = 0:maxnum
    tempindex = labelimg == i;
    tempcolor = colors(i + 1,:);

    tempimg = re_img(:,:,1);
    tempimg(tempindex) = tempcolor(1);
    re_img(:,:,1) = tempimg;

    tempimg = re_img(:,:,2);
    tempimg(tempindex) = tempcolor(2);
    re_img(:,:,2) = tempimg;

    tempimg = re_img(:,:,3);
    tempimg(tempindex) = tempcolor(3);
    re_img(:,:,3) = tempimg;
end
