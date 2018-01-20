function re_img = subImage_range(img1,img2,range) 

[row_img column_img byte_img] = size(img1);

if nargin == 2
    range = 2;
end

re_img = zeros(row_img,column_img,byte_img);

for i = 1:row_img
    for j = 1:column_img
        top     = max(1,i - round(range/2));
        left    = max(1,j - round(range/2));
        bottom  = min(row_img,i + round(range/2));
        right   = min(column_img,j + round(range/2));

        entry = img1(i,j,:);
        matrix = img2(top:bottom,left:right,:);

        for q = 1:byte_img
            matrix(:,:,q) = abs(matrix(:,:,q) - entry(q));
        end

        oldmat = matrix;
        matrix = sum(matrix,3);

        [r c] = find(matrix == min(min(matrix)));

        r = r(1);
        c = c(1);

        re_img(i,j,:) = oldmat(r,c,:);
    end
end
