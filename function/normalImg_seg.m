function re_img = normalImg_seg(img,num_multi,num_factor)

[row_img column_img byte_img] = size(img);

[labels_img, numlabels] = slicmex(uint8(img),num_multi,num_factor);

avgimg = zeros(row_img,column_img,byte_img);


for i = 0:numlabels
    for j = 1:3
        rimg = img(:,:,j);
        tempimg = avgimg(:,:,j);
        index = labels_img == i;

        num = sum(sum(index));
        value = sum(sum(rimg(index))) + 0;

        if num == 0
            num = j;
        end

        value = value/num;

        tempimg(index) = value;
        avgimg(:,:,j) = tempimg;
    end
end


re_img = avgimg;
