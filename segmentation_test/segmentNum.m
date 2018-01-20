function re_label = segmentNum(data,labels,num)

maxlabel = max(labels);

if nargin == 2
    num = maxlabel;
end

store_dis = [];
store_lab = [];

for i = 0:maxlabel
    index = labels == i;
    tempdata = data(index,:);

    center = mean(tempdata,1);

    [row_t column_t] = size(tempdata);

    for j = 1:column_t
        tempdata(:,j) = abs(tempdata(:,j) - center(j));
    end

    sumvalue = sum(sum(tempdata));
    value = sumvalue/row_t;

    store_dis = [store_dis ; value];
    store_lab = [store_lab ; i];
end





for i = 0:num
    pos = find(store_dis == max(store_dis));
    pos = pos(1);
    clusterlab = store_lab(pos);

    labels = clusterLabelData(data,labels,clusterlab);


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % add the new cluster                                           %
    maxlabel = maxlabel + 1;
    store_lab = [store_lab ; maxlabel];

    index = labels == maxlabel;

    tempdata = data(index,:);

    center = mean(tempdata,1);

    [row_t column_t] = size(tempdata);

    
    for j = 1:column_t
        tempdata(:,j) = abs(tempdata(:,j) - center(j));
    end

    sumvalue = sum(sum(tempdata));
    value = sumvalue/row_t;

    store_dis = [store_dis ; value];                                %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % update the old cluster                                        %
    index = labels == clusterlab;

    tempdata = data(index,:);

    center = mean(tempdata,1);

    [row_t column_t] = size(tempdata);

    for j = 1:column_t
        tempdata(:,j) = abs(tempdata(:,j) - center(j));
    end

    sumvalue = sum(sum(tempdata));
    value = sumvalue/row_t;

    store_dis(pos) = value;                                         %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end

re_label = labels;
