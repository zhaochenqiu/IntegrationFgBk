function [re_fgimg re_model re_index] = getFgCues(grayimg_cur,bkimg,model,H_full)



% load the algorithms parameter
global g_rangeAligFg g_rangeAligBk;

% XXX change the code from here
map = getMapRange_single_op(grayimg_cur,bkimg,H_full,g_rangeAligFg);


mus = model{1};
sigmas = model{2};
weights = model{3};


[row_t column_t byte_t] = size(mus);

temp_mus        = mus;
temp_sigmas     = sigmas;
temp_weights    = weights;

mus     = zeros(row_t,column_t,byte_t) - 1;
sigmas  = zeros(row_t,column_t,byte_t) - 1;
weights = zeros(row_t,column_t,byte_t) - 1;

aligmentImg_byMap_c(temp_mus,       mus,    map);
aligmentImg_byMap_c(temp_sigmas,    sigmas, map);
aligmentImg_byMap_c(temp_weights,   weights,map);


index = map(:,:,1) < 0;
re_index = index;


% threshold = 0.3;
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
