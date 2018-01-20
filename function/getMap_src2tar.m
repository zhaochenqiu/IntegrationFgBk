function re_map = getMap_src2tar(img_src,img_tar,label_list,H_list,label_img,range,H_error)
% function [re_map re_map_fg] = getMapRange_multi_model2img(grayimg_cur,modelimg,label_list,H_list,label_img,range,H_error)

% img_tar = H*img_src

if nargin == 5
    range = 2;
end

[row_img column_img byte_img] = size(img_src);

re_map = zeros(row_img,column_img,2) - 1;


for i = 1:row_img
    for j = 1:column_img
        value_src = img_src(i,j);

%        label = label_img(i,j) + 1;
        label = label_img(i,j) + 1;

        H = H_list{label};
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

            matrix = img_tar(top:bottom,left:right,:);
            matrix = abs(matrix - value_src);

            minvalue = min(min(matrix));

            [r c] = find(matrix == minvalue);


            [row_t column_t] = size(r);

            if row_t + column_t > 2
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % 方法一，找出最靠近的那个，缺点是运行时间太长
            % 测试得到，确实是因为相同像素值的点
            % [r c] = getCloseCenter(r,c,range);
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % 方法二,取中间位置的那个
                pos = round(row_t/2);
                r = r(pos);
                c = c(pos);
            end

            mapx = left + c - 1;
            mapy = top + r - 1;


            if re_map(mapy,mapx) == -1
                re_map(mapy,mapx,1) = j;
                re_map(mapy,mapx,2) = i;
            else
                oldj = re_map(mapy,mapx,1);
                oldi = re_map(mapy,mapx,2);

                oldsub = abs(img_src(oldi,oldj) - img_tar(mapy,mapx));
                newsub = abs(img_src(i,j) - img_tar(mapy,mapx));

                if newsub < oldsub
                    re_map(mapy,mapx,1) = j;
                    re_map(mapy,mapx,2) = i;
                end
            end
        end
    end
end
