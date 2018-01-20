function re_cuesimg = files2cuesimg(img_cues)

[row_img column_img byte_img] = size(img_cues);

rimg = img_cues(:,:,1);
gimg = img_cues(:,:,2);
bimg = img_cues(:,:,3);

maxvalue = max(max(rimg));

if maxvalue == 0
    maxvalue = 1;
end

rate = 255/maxvalue;

re_cuesimg = zeros(row_img,column_img,2);
re_cuesimg(:,:,1) = img_cues(:,:,1);
re_cuesimg(:,:,2) = -img_cues(:,:,2);

re_cuesimg = re_cuesimg*rate;
