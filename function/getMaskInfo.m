function [re_left re_top re_right re_bottom] = getMaskInfo(mask);

[row_img column_img byte_img] = size(mask);

pos_r = round(row_img/2);
pos_c = round(column_img/2);

pos_x = find(mask(pos_r,:) == 255);
pos_y = find(mask(:,pos_c) == 255);

re_left    = min(pos_x);
re_right   = max(pos_x);
re_top     = min(pos_y);
re_bottom  = max(pos_y);
