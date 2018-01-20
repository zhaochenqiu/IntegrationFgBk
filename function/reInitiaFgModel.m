function [re_mus re_sigmas re_weights] = reInitiaFgModel(img_cur,mus,sigmas,weights)

[row_img column_img byte_img] = size(img_cur);


if byte_img == 1
    grayimg_cur = img_cur;
else
    global template;

    %convimg_cur = zeros(row_img,column_img,byte_img) + img_cur;
    %convolution_c(convimg_cur,img_cur,template);
    convimg_cur = imfilter(img_cur,template);


    grayimg_cur = grayImage(convimg_cur);
end

bkimg = getBestBkImage(mus,weights);
% index = bkimg < 0;

[row_img column_img byte_img] = size(bkimg);

for i = 1:row_img
    for j = 1:column_img
        if bkimg(i,j) < 1
            % empty point need completed by neighborhoods

            posr = i;
            posc = j;

            range = 1;
            judge = 0;

            value = 0;

            while judge == 0
                left    = posc - range;
                right   = posc + range;
                top     = posr - range;
                bottom  = posr + range;

                left    = max([1 left]);
                right   = min([column_img right]);
                top     = max([1 top]);
                bottom  = min([row_img bottom]);

                matrix  = bkimg(top:bottom,left:right);

                index   = matrix > 0;

                judge = sum(sum(index));
                value = sum(sum(matrix(index)));

                range = range + 1;
            end

            mus(i,j,1) = round(value/judge);
            sigmas(i,j,1) = 10;
            weights(i,j,1) = 1;

            mus(i,j,2) = 0;
            sigmas(i,j,2) = 0;
            weights(i,j,2) = 0;

            mus(i,j,3) = 0;
            sigmas(i,j,3) = 0;
            weights(i,j,3) = 0;
        end
    end
end

re_mus = mus;
re_sigmas = sigmas;
re_weights = weights;
