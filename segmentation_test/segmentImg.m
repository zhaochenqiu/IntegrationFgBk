function re_img = segmentImg(img,list)

[row_img column_img byte_img] = size(img);

[row_t column_t] = size(list);

re_img = zeros(row_img,column_img);

len = row_t;

if len < column_t
    len = column_t;
end

labels_list = 1:1:len;


for i = 1:row_img
    for j = 1:column_img
        value = img(i,j);
        sublist = abs(list - value);

        pos = find(sublist == min(sublist));
        pos = pos(1);

        label = labels_list(pos);


        re_img(i,j) = label;
    end
end



