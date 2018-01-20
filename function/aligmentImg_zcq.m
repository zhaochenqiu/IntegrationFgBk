function re_img = aligmentImg_zcq(img_tar,H)

[row_img column_img byte_img] = size(img_tar);

% 这个地方的逻辑要搞清楚 
% img_tar = img_src*H

% 逻辑是把img_tar 校正到 img_src， 就是从img_tar中取像素

re_img = zeros(row_img,column_img,byte_img) - 1;

for i = 1:row_img
    for j = 1:column_img
        pos = [j i 1]';
        pos_ = H*pos;

        posx = pos_(1,1)/pos_(3,1);
        posy = pos_(2,1)/pos_(3,1);

        posx = round(posx);
        posy = round(posy);

        if posx > 0 & posx < column_img + 1 & posy > 0 & posy < row_img + 1
            re_img(i,j,:) = img_tar(posy,posx,:);
        end
    end
end
