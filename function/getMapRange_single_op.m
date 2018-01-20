function re_map = getMapRange_single(img_tmp,img_tar,H,range)

if nargin == 3
    range = 2;
end

[row_img column_img byte_img] = size(img_tar);

% 这个函数和aligmentImg_zcq 相似，img_tmp 用来做范围对比的.
% 逻辑是将img_tar 变成 img_tmp


% date:2017/5/30
% 这个函数经过极限优化了，原版的函数保留为 getMapRange_single_op_old.m

re_map = zeros(row_img,column_img,2) - 1;

for i = 1:row_img
    
    pos_list = zeros(3,column_img);
    pos_list(1,:) = 1:column_img;
    pos_list(2,:) = i;
    pos_list(3,:) = 1;

    pos_list_ = H*pos_list;

    posx_list = pos_list_(1,:) ./ pos_list_(3,:);
    posy_list = pos_list_(2,:) ./ pos_list_(3,:);

    posx_list = round(posx_list);
    posy_list = round(posy_list);

    %{
    for j = 1:column_img
        posx = posx_list(j);
        posy = posy_list(j);


        if posx > 0 & posx < column_img + 1 & posy > 0 & posy < row_img + 1
            re_map(i,j,1) = posx;
            re_map(i,j,2) = posy;
        end
    end
    %}

    entry_for_getMapRange_single_op(double([i row_img column_img]),posx_list,posy_list,re_map);
end

mapRange_c(img_tmp,img_tar,re_map,range);
