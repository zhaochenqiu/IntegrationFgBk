function [re_labelimg re_numlabels re_labels]= segmentImg_rand(img,num);


[row_img column_img byte_img] = size(img);
[ximg yimg] = getPosImg(img);

colorTransform = makecform('srgb2lab');
img = applycform(uint8(img), colorTransform);
img = double(img);

data =  reshape(img,row_img*column_img,byte_img);
xdata = reshape(ximg,row_img*column_img,1);
ydata = reshape(yimg,row_img*column_img,1);

data = [data xdata ydata];

nordata = normalRowData(data);
% weights = [1.0 1.0 1.0 1.0 1.0];


center_x = round(rand(num,1)*row_img);
center_y = round(rand(num,1)*column_img);

center_labels = 0:num;
center_labels = center_labels';

center_clr = zeros(num,3);

for i = 1:num
    posx = center_x(i);
    posy = center_y(i);

    posx = max([1 posx]);
    posy = max([1 posy]);

    posx = min([posx column_img]);
    posy = min([posy row_img]);

    center_x(i) = posx;
    center_y(i) = posy;

    center_clr(i,:) = img(posy,posx,:);
end

center_data = [center_clr center_x center_y];
center_data = normalRowData(center_data);
[row_t column_t] = size(nordata);


labels = zeros(row_t,1);


for i = 1:row_t
    entrydata = nordata(i,:);

    tempdata = center_data;

    for j = 1:column_t;
        tempdata(:,j) = abs(tempdata(:,j) - entrydata(j));
    end

    distance = mean(tempdata,2);

    pos = find(distance == min(distance));
    pos = pos(1);

    labels(i) = center_labels(pos);
end

labelimg = reshape(labels,row_img,column_img);

re_labelimg     = labelimg;
re_numlabels    = num;
re_labels       = labels;
