function re_map = getMap_tar2src(img_src,img_tar,label_list,H_list,label_img,range,H_error)

% function [re_map re_map_fg] = getMapRange_multi_model2img(grayimg_cur,modelimg,label_list,H_list,label_img,range,H_error)

%  img_src = H*img_tar

if nargin == 5
    range = 2;
end

[row_img column_img byte_img] = size(img_src);

re_map = zeros(row_img,column_img,2) - 1;

for i = 1:row_img
    for j = 1:column_img
        value = img_tar(i,j);
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

            matrix = img_src(top:bottom,left:right,:);

            %if sum(sum(matrix)) > 0
                matrix = abs(matrix - value);

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

                % img_src(mapy,mapx) = -1;

                re_map(i,j,1) = mapx;
                re_map(i,j,2) = mapy;
            %end
        end
    end
end

