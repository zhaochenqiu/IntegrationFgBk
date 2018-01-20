function re_img = re_aligmentImg_byMap(img,map)

[row_img column_img byte_img] = size(img);

re_img = zeros(row_img,column_img,byte_img);

for i = 1:row_img
    for j = 1:column_img
        mapx = map(i,j,1);
        mapy = map(i,j,2);

        if mapy ~= -1 & mapx ~= -1
            re_img(mapy,mapx,:) = img(i,j,:);
        end
    end
end

