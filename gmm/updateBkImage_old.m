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
tempmus(:,:,1) = image;
tempmus(:,:,2) = image;
tempmus(:,:,3) = image;


global update_mus update_sig update_wei;
% update_mus = 0.95;
% update_sig = 0.95;
% update_wei = 1.05;

re_mus = mus;
re_mus(index_match) = mus(index_match)*update_mus + tempmus(index_match)*(1 - update_mus);

tempsigma = sigmas < compare;
finmatch = tempsigma & index_match;
re_sigmas = sigmas;
re_sigmas(finmatch) = sigmas(finmatch)*update_sig + compare(finmatch)*(1 - update_sig);



for i = 1:row
    for j = 1:column
        
        pos = 1;
        judge = 100;
        for q = 1:byte
            if judge > weight(i,j,q)
                pos = q;
                judge = weight(i,j,q);
            end
        end
        
        if index_match(i,j,pos) == 0
            re_mus(i,j,pos) = image(i,j);
            sigmas(i,j,pos) = 8;
            weight(i,j,pos) = update_wei - 1;
        end
    end
end

re_weight = weight;
re_weight(index_match) = weight(index_match) * update_wei;


for i = 1:row          % 权值归一化有问题
    for j = 1:column
        value = 0;
        
        for q = 1:byte
            value = value + re_weight(i,j,q);
        end
        
        if value == 0   % 基本不会出现，还是加个判断好一些
            value = 1;
        end
        
        for q = 1:byte
            re_weight(i,j,q) = re_weight(i,j,q) / value;
        end

    end
end
