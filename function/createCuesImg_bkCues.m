function re_img = createCuesImg(fgcues,bkcues,index)

[row_img column_img byte_img] = size(fgcues);

tempimg = zeros(row_img,column_img);

global g_fgValue g_bkValue;

bkcuesimg = createBkCuesImg(fgcues,bkcues,g_bkValue);
bkcuesimg(index) = g_bkValue;


fgcuesimg = fgcues;
index = fgcuesimg == 255;
fgcuesimg(index) = g_fgValue;

re_img = zeros(row_img,column_img,2);

re_img(:,:,1) = fgcuesimg;
re_img(:,:,2) = bkcuesimg;
