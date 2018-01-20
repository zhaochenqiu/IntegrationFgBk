function re_similar = fgimage2similar_plus(img,fgimage,num)

[row_img column_img byte_img] = size(img);

re_similar = zeros(row_img,column_img);


[ximg yimg] = getPosImg(img);

data  = reshape(img,row_img*column_img,byte_img);
xdata = reshape(ximg,row_img*column_img,1);
ydata = reshape(yimg,row_img*column_img,1);

data = [data xdata ydata];

nordata = normalRowData(data);

[row_t column_t] = size(nordata);

label_list = zeros(row_t,1);


for i = 1:num
    label_list = segmentBinary(nordata,label_list);

    labels_img = reshape(label_list,row_img,column_img);

    fillsimilar = fgimg2similar(fgimage,labels_img);

    re_similar = re_similar + fillsimilar;
end

re_similar = re_similar/num;
