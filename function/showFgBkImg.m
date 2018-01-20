function re_showimg = showFgBkImg(simimg,fgcolor,bkcolor)

if nargin == 1
    fgcolor = [0 0 255];
    bkcolor = [255 0 0];
end

[row_img column_img byte_img] = size(simimg);

maxvalue = abs(max(max(max(simimg))));
minvalue = abs(min(min(min(simimg))));


if maxvalue == 0
    maxvalue = 1;
end

if minvalue == 0
    minvalue = 1;
end


re_showimg = zeros(row_img,column_img,3);

for i = 1:row_img
    for j = 1:column_img
        value = simimg(i,j);
        
        if value < 0
            rate = abs(value)/minvalue;
            colorvalue = bkcolor*rate;

            re_showimg(i,j,:) = colorvalue;
        else
            rate = abs(value)/maxvalue;
            colorvalue = fgcolor*rate;

            re_showimg(i,j,:) = colorvalue;
        end
    end
end
