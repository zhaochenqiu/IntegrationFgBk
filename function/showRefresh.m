function re_showimg = showRefresh(img,maskimg)

[row_img column_img byte_img] = size(img);

re_showimg = zeros(row_img,column_img,byte_img);

bkcolor = [100 101 140];
fgcolor = [255 100 100];

rate = 0.5;

index_fg = maskimg == 255;
index_bk = maskimg ~= 255;

for i = 1:3
	tempimg = img(:,:,i);
	tempimg(index_fg) = tempimg(index_fg)*rate + (1 - rate)*fgcolor(i);
	tempimg(index_bk) = tempimg(index_bk)*rate + (1 - rate)*bkcolor(i);

	re_showimg(:,:,i) = tempimg;
end
