function re_model = updateModel_BGSp(img,fgimg,model,subfgimg,bestbkimg)

[row_img column_img byte_img] = size(img);

bkimg = model{1};

tmpimg = morphologyImage(fgimg,2,1);
index = tmpimg == 255;
tempindex = subfgimg == 255;
index = index|tempindex;
index = ~index;

% update the background part
for i = 1:byte_img
    tempimg1 = img(:,:,i);
    tempimg2 = bkimg(:,:,i);

    tempimg2(index) = tempimg1(index);

    bkimg(:,:,i) = tempimg2;
end

% update the foreground part
index = ~index;
for i = 1:byte_img
    tempimg1 = bestbkimg(:,:,i);
    tempimg2 = bkimg(:,:,i);

    tempimg2(index) = tempimg1(index);

    bkimg(:,:,i) = tempimg2;
end


re_model = {bkimg};
