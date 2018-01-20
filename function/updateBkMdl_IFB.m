function re_model = updateBkMdl_IFB(model,grayimg_cur,simimg)

global g_thrFgSeg g_thrBkUpd g_template;

index = simimg < g_thrBkUpd*255;

mus     = model{1};
sigmas  = model{2};
weights = model{3};

[row_t column_t byte_t] = size(mus);



%{
for i = 1:row_t
    for j = 1:column_t
        if index(i,j) == 1

            list = weights(i,j,:);
            pos = find(list == max(list));
            pos = pos(1);
            mus(i,j,pos) = grayimg_cur(i,j);
        end
    end
end
%}

entry_updateBkMdl_IFB(double([row_t column_t byte_t]),mus,weights,grayimg_cur,double(index));

re_model = {mus,sigmas,weights};
