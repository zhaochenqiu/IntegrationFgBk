function [re_map re_map_single] = getMapRange_multi(img_tmp,img_tar,label_list,H_list,label_img,range,H_error)

if nargin == 5
    range = 2;
end

[row_img column_img byte_img] = size(img_tar);

re_map          = zeros(row_img,column_img,2) - 1;
re_map_single   = zeros(row_img,column_img,2) - 1;

for i = 1:row_img
    for j = 1:column_img
        value = img_tmp(i,j,:);

        label = label_img(i,j) + 1;

        try
            H = H_list{label};
        catch
            H = H_error;
            % disp('there is a error in getMapRange_multi, H_error')
        end
        
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
            matrix = abs(matrix - value);

            minvalue = min(min(matrix));

            [r c] = find(matrix == minvalue);
            r = r(1);
            c = c(1);

            mapx = left + c - 1;
            mapy = top + r - 1;

            re_map(i,j,1) = mapx;
            re_map(i,j,2) = mapy;

            re_map_single(i,j,1) = posx;
            re_map_single(i,j,2) = posy;
        end
    end
    % displayMatrixImage(1,1,1,tempimg)
end


