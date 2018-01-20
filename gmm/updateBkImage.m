function [re_mus re_sigmas re_weight] = updateBkImage(image,mus,sigmas,weight,compare)


[row column byte] = size(mus);
compare = zeros(row,column,byte);

for i = 1:byte
    compare(:,:,i) = abs(image - mus(:,:,i));
end

global gmm_uprate;

index_match = compare < (gmm_uprate + sigmas);
index_unmatch = ~index_match;

tempmus = mus;
for i = 1:byte
    tempmus(:,:,i) = image;
end

%tempmus(:,:,2) = image;
%tempmus(:,:,3) = image;


global update_mus update_sig update_wei;


re_mus = mus;
re_mus(index_match) = mus(index_match)*update_mus + tempmus(index_match)*(1 - update_mus);

tempsigma = sigmas < compare;
finmatch = tempsigma & index_match;
re_sigmas = sigmas;
re_sigmas(finmatch) = sigmas(finmatch)*update_sig + compare(finmatch)*(1 - update_sig);


judgemap = sum(index_match,3);

[row_img column_img byte_img] = size(mus);


re_weight = weight;

entry_updateBkImage(double([update_wei row_img column_img byte_img]), ...
                    weight, ...
                    re_mus, ...
                    re_sigmas, ...
                    re_weight, ...
                    judgemap, ...
                    image);

%{



for i = 1:row
    for j = 1:column
        if judgemap(i,j) == 0
            pos = 1;
            judge = 100;
            for q = 1:byte
                if judge > weight(i,j,q)
                    pos = q;
                    judge = weight(i,j,q);
                end
            end
        
            re_mus(i,j,pos) = image(i,j);
            re_sigmas(i,j,pos) = 8;
            re_weight(i,j,pos) = update_wei - 1;
        end
    end
end
%}


re_weight(index_match) = weight(index_match) * update_wei;



allweights = sum(re_weight,3);
index = allweights == 0;
allweights(index) = 1;

for i = 1:byte
    re_weight(:,:,i) = re_weight(:,:,i) ./ allweights;
end

