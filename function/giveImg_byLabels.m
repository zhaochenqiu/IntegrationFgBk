function re_img = giveImg_byLabels(img,tar,labels_img,label)

[row_img column_img byte_img]= size(img);

index = label == labels_img;
re_img = img;

for i = 1:byte_img
    tempimg = img(:,:,i);
    temptar = tar(:,:,i);

    tempimg(index) = temptar(index);
    re_img(:,:,i) = tempimg;
end
