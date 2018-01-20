function [re_labelimg re_num re_labels] = segmentImg_bin(img,num,label_list)

[row_img column_img byte_img] = size(img);
[ximg yimg] = getPosImg(img);


data =  reshape(img,row_img*column_img,byte_img);
xdata = reshape(ximg,row_img*column_img,1);
ydata = reshape(yimg,row_img*column_img,1);

data = [data xdata ydata];

nordata = normalRowData(data);


[row_t column_t] = size(nordata);

if nargin == 2
    label_list = zeros(row_t,1);
end

for i = 1:num
    label_list = segmentBinary(nordata,label_list);
end

re_labelimg = reshape(label_list,row_img,column_img);
re_num      = 2^num;
re_labels   = label_list;
