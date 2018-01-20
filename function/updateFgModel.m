function re_model = updateFgModel(img_cur,model,fgmodel,thrimg,H_full)

% load the algorithms parameter
global template num_multi num_factor threshold_dis threshold_disbk;

% define the parameter
[row_img column_img byte_img] = size(img_cur);

% captured the background model
mus     = model{1};
sigmas  = model{2};
weights = model{3};

fgmus     = fgmodel{1};
fgsigmas  = fgmodel{2};
fgweights = fgmodel{3};



% capturing the sift features
convimg_cur = zeros(row_img,column_img,byte_img) + img_cur;
convolution_c(convimg_cur,img_cur,template);

bkimg       = getBestBkImage(mus,weights);
grayimg_pre = bkimg;
grayimg_cur = grayImage(convimg_cur);
% grayimg_cur = grayImage_fake(convimg_cur);

global range_fgr;
map = getMapRange_single_op(grayimg_cur,bkimg,H_full,range_fgr);


fgmus         = aligmentImg_byMap(fgmus,map);
fgsigmas      = aligmentImg_byMap(fgsigmas,map);
fgweights     = aligmentImg_byMap(fgweights,map);


[mus sigmas weights] = reInitiaModel(img_cur,mus,sigmas,weights);

global threshold_gmm;

[compare fgimg similary] = getFgImage(grayimg_cur,mus,sigmas,weights,threshold_gmm);

[mus sigmas weights] = updateBkImage(grayimg_cur,mus,sigmas,weights,compare);


for i = 1:row_img
    for j = 1:column_img
        if thrimg(i,j) == 255;
            mus(i,j,:)      = fgmus(i,j,:);
            sigmas(i,j,:)   = fgsigmas(i,j,:);
            weights(i,j,:)  = fgweights(i,j,:);
        end
    end
end

re_model    = {mus,sigmas,weights};
