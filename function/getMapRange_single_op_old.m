function re_map = getMapRange_single(img_tmp,img_tar,H,range)

if nargin == 3
    range = 2;
end

[row_img column_img byte_img] = size(img_tar);

% 这个函数和aligmentImg_zcq 相似，img_tmp 用来做范围对比的.
% 逻辑是将img_tar 变成 img_tmp

re_map = zeros(row_img,column_img,2) - 1;


for i = 1:row_img
    for j = 1:column_img
        value = img_tmp(i,j,:);

        pos = [j i 1]';
        pos_ = H*pos;

        posx = pos_(1,1)/pos_(3,1);
        posy = pos_(2,1)/pos_(3,1);

        posx = round(posx);
        posy = round(posy);

        if posx > 0 & posx < column_img + 1 & posy > 0 & posy < row_img + 1
            re_map(i,j,1) = posx;
            re_map(i,j,2) = posy;
        end
    end
end


mapRange_c(img_tmp,img_tar,re_map,range);

