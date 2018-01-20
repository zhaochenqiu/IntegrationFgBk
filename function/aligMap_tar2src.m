function re_img = aligMap_tar2src(img,map)

[row_img column_img byte_img] = size(img);

re_img = zeros(row_img,column_img,byte_img) - 1;

for i = 1:row_img
    for j = 1:column_img
        mapx = map(i,j,1);
        mapy = map(i,j,2);

        if mapy ~= -1 & mapx ~= -1
            re_img(i,j,:) = img(mapy,mapx,:);
%            re_img(mapy,mapx,:) = img(i,j,:);
        end
    end
end

