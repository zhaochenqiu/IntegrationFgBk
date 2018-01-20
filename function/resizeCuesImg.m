function re_img = resizeCuesImg(cuesimg)

[row_img column_img byte_img] = size(cuesimg);

re_img = zeros(row_img,column_img,3);

cuesimg = abs(cuesimg);

maxvalue = max(max(max(cuesimg)));

rate = 255/maxvalue;


re_img(:,:,1) = cuesimg(:,:,1);
re_img(:,:,2) = cuesimg(:,:,2);


re_img = re_img*rate;
