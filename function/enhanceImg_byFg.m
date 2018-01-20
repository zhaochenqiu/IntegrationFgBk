function re_img = enhanceImg_byFg(img,fgimg)

template = [-1 -2 -1
            -2  13 -2
            -1 -2 -1];

%template = template/sum(sum(template));

convimg = imfilter(img,template);


%{

global g_displayMatrixImage;
g_displayMatrixImage = 1;
figure
displayMatrixImage(1,1,2,img,convimg)
input('afaf')
%}
re_img = img;
index = fgimg == 255;

[row_img column_img byte_img] = size(img);

for i = 1:byte_img
    tempimg1 = re_img(:,:,i);
    tempimg2 = convimg(:,:,i);

    tempimg1(index) = tempimg2(index);

    re_img(:,:,i) = tempimg1;
end

