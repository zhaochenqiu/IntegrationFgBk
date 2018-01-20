function re_rate = getAliRate(img_cur,H_full)

[row_img column_img byte_img] = size(img_cur);

srcpos = [1 1 1]';
tarpos = H_full*srcpos;
tarpos(1) = tarpos(1)/tarpos(3);
tarpos(2) = tarpos(2)/tarpos(3);
sublen = abs(srcpos - tarpos);
renum = sublen(1)*sublen(2);
imnum = row_img*column_img;
temprate = renum/imnum;

re_rate = temprate;
