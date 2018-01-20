function [re_H re_src re_tar re_index] = getHomography_ransac(src,tar,range,maxloop)

% tar = H*src

if nargin == 3
    maxloop = 100;
end

num = size(src,2);

if num < 6
    re_H = zeros(3,3);
    re_src = zeros(1,num);
    re_tar = zeros(1,num);
    re_index = zeros(1,num) > 255;;
else
    for t = 1:maxloop
        subset = vl_colsubset(1:num,4);

        A = [];

        for i = subset
            A = cat(1, A, kron(src(:,i)', vl_hat(tar(:,i))));
        end

        [U,S,V] = svd(A);
        H{t} = reshape(V(:,9),3,3);

        % score homography
        tar_ = H{t}*src;

        du = tar_(1,:)./tar_(3,:) - tar(1,:)./tar(3,:);
        dv = tar_(2,:)./tar_(3,:) - tar(2,:)./tar(3,:);
        ok{t} = (du.*du + dv.*dv) <  range;

        score(t) = sum(ok{t}) ;
    end

    [score, best] = max(score);
    H = H{best};
    ok = ok{best};

    re_H = H;
    re_src = src(:,ok);
    re_tar = tar(:,ok);
    re_index = ok;
end
