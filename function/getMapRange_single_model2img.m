function re_map = getMapRange_single_model2img(grayimg_cur,modelimg,H,range)

if nargin == 3
    range = 2;
end

[row_img column_img byte_img] = size(grayimg_cur);

% 这个函数和aligmentImg_zcq 相似，img_tmp 用来做范围对比的.
% 逻辑是将img_tar 变成 img_tmp

re_map = zeros(row_img,column_img,2) - 1;

for i = 1:row_img
    for j = 1:column_img
        value = modelimg(i,j,:);

        pos = [j i 1]';
        pos_ = H*pos;

        posx = pos_(1,1)/pos_(3,1);
        posy = pos_(2,1)/pos_(3,1);

        posx = round(posx);
        posy = round(posy);

        if posx > 0 & posx < column_img + 1 & posy > 0 & posy < row_img + 1
             left    = posx - range;
            top     = posy - range;
            right   = posx + range;
            bottom  = posy + range;

            left    = max([1 left]);
            top     = max([1 top]);
            right   = min([right column_img]);
            bottom  = min([bottom row_img]);

            matrix = grayimg_cur(top:bottom,left:right,:);
            matrix = abs(matrix - value);

            minvalue = min(min(matrix));

            [r c] = find(matrix == minvalue);
            r = r(1);
            c = c(1);

            mapx = left + c - 1;
            mapy = top + r - 1;

            re_map(i,j,1) = mapx;
            re_map(i,j,2) = mapy;
        end
    end
end
