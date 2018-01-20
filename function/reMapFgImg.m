function re_model = reMapFgImg(img_cur,model,oldmodel,simimg,H_full)

global threshold_remap;

fgimg = thresholdImage(simimg,threshold_remap*255);

[row_img column_img byte_img] = size(fgimg);

mus     = model{1};
sigmas  = model{2};
weights = model{3};

oldmus     = oldmodel{1};
oldsigmas  = oldmodel{2};
oldweights = oldmodel{3};

map = getMapNative_single(oldmus,H_full);

newmus         = aligmentImg_byMap(oldmus,map);
newsigmas      = aligmentImg_byMap(oldsigmas,map);
newweights     = aligmentImg_byMap(oldweights,map);

for i = 1:row_img
    for j = 1:column_img
        if fgimg(i,j) == 255;
            mus(i,j,:)      = newmus(i,j,:);
            sigmas(i,j,:)   = newsigmas(i,j,:);
            weights(i,j,:)  = newweights(i,j,:);
        end
    end
end

[mus sigmas weights] = reInitiaModel(img_cur,mus,sigmas,weights);

re_model = {mus,sigmas,weights};
