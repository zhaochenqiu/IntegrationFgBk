function re_rate = getAligRate(H_full,img)

[row_img column_img byte_img] = size(img);

pos_lt = [1             1       1]';
pos_rt = [column_img    1       1]';
pos_lb = [1             row_img 1]';
pos_rb = [column_img    row_img 1]';


pos = [pos_lt pos_rt pos_lb pos_rb];


pos_ = H_full * pos;
pos_(1,:) = pos_(1,:) ./ pos_(3,:);
pos_(2,:) = pos_(2,:) ./ pos_(3,:);


pos_(3,:) = 1;


len =sum(sum(abs(pos - pos_)));
len = len/4;

re_rate = len/(row_img + column_img);

if isnan(re_rate)
    re_rate = 1;
end
