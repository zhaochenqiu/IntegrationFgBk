function [re_fgimg re_model] = getBkModel(img_cur,model,H_full)



% load the algorithms parameter
global g_template num_multi num_factor threshold_dis g_disRscFgCues;

% define the parameter
[row_img column_img byte_img] = size(img_cur);

% captured the background model
mus     = model{1};
sigmas  = model{2};
weights = model{3};


% capturing the sift features
convimg_cur = imfilter(img_cur,g_template);

bkimg       = getBestBkImage(mus,weights);
grayimg_cur = grayImage(convimg_cur);



global g_rangeAligFg g_rangeAligBk;
% XXX change the code from here
map = getMapRange_single_op(grayimg_cur,bkimg,H_full,g_rangeAligBk);




mus_res     = abs(mus - mus) - 1;
sigmas_res  = abs(sigmas - sigmas) - 1;
weights_res = abs(weights - weights) - 1;

aligmentImg_byMap_c(mus,mus_res,map);
aligmentImg_byMap_c(sigmas,sigmas_res,map);
aligmentImg_byMap_c(weights,weights_res,map);

mus = mus_res;
sigmas = sigmas_res;
weights = weights_res;



index = map(:,:,1) < 0;


global g_gmmFgThreshold; 

[compare fgimg similary] = getFgImage(grayimg_cur,mus,sigmas,weights,g_gmmFgThreshold);

[mus sigmas weights] = updateBkImage(grayimg_cur,mus,sigmas,weights,compare);

fgimg(index) = 0;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[row_t column_t byte_t] = size(mus);

tempimg = mus(:,:,1);
tempimg(index) = grayimg_cur(index);
mus(:,:,1) = tempimg;

for i = 2:byte_t
    tempimg = mus(:,:,i);
    tempimg(index) = 0;
    mus(:,:,i) = tempimg;
end


tempimg = sigmas(:,:,1);
tempimg(index) = 10;
sigmas(:,:,1) = tempimg;

for i = 2:byte_t
    tempimg = sigmas(:,:,i);
    tempimg(index) = 0;
    sigmas(:,:,i) = tempimg;
end


tempimg = weights(:,:,1);
tempimg(index) = 1;
weights(:,:,1) = tempimg;

for i = 2:byte_t
    tempimg = weights(:,:,i);
    tempimg(index) = 0;
    weights(:,:,i) = tempimg;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

re_fgimg = fgimg;

re_model = {mus,sigmas,weights};

