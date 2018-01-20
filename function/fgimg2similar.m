function re_similar = fgimg2similar(fgimg,labelimg)

[row_img column_img byte_img] = size(fgimg);

maxlabel = max(max(labelimg));

re_similar = zeros(row_img,column_img);

for i = 0:maxlabel
    index = labelimg == i;
%    num = sum(sum(labelimg(index)));
    num = sum(sum(index));
    num = max([num 1]);

    sumvalue = 0 + sum(sum(fgimg(index)));
    value = sumvalue/num;

    re_similar(index) = value;
end
