function re_bkimg = updateBkImg(img_cur,fgimg,bkimg)

[row_img column_img byte_img] = size(img_cur);

re_bkimg = zeros(row_img,column_img,byte_img);
