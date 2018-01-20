function re_img = aligMap_src2tar(img,map)

[row_img column_img byte_img] = size(img);

re_img = zeros(row_img,column_img,byte_img) - 1;

for i = 1:row_img
    for j = 1:column_img
        mapx = map(i,j,1);
        mapy = map(i,j,2);

        if mapy ~= -1 & mapx ~= -1
            re_img(i,j,:) = img(mapy,mapx,:);
        end
    end
end

