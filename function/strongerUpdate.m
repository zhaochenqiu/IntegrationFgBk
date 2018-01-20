function re_model = strongerUpdate(img,model,norimg)

[row_img column_img byte_img] = size(img);

global template;
convimg = zeros(row_img,column_img,byte_img) + img;
convolution_c(convimg,img,template);
grayimg = grayImage(convimg);

global stronger_thr;
maskimg = thresholdImage(norimg,stronger_thr*255);

global num_model;

mus     = model{1};
sigmas  = model{2};
weights = model{3};

for i = 1:row_img
    for j = 1:column_img
        if maskimg(i,j) ~= 255
            for q = 1:num_model
                mus(i,j,q) = grayimg(i,j);
            end

            % input('pause in the update')
            %{
            pos     = 1;
            value   = weights(i,j,1);

            for q = 1:num_model
                if value < weights(i,j,q)
                    value = weights(i,j,q);
                    pos = q;
                end
            end

            mus(i,j,pos) = grayimg(i,j);
            %}
        end
    end
end

re_model = {mus,sigmas,weights};
