function re_img = getImg_byMask(img,mask)

[row_img column_img byte_img] = size(img);

pos_r = round(row_img/2);
pos_c = round(column_img/2);

pos_x = find(mask(pos_r,:) == 255);
pos_y = find(mask(:,pos_c) == 255);

left    = min(pos_x);
right   = max(pos_x);
top     = min(pos_y);
bottom  = min(pos_y);



