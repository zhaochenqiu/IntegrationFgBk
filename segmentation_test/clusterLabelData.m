function re_label = clusterLabelData(srcdata,label_list,label,num_cluster,num_iteration)

if nargin == 3
    num_cluster = 2;
    num_iteration = 10;
end

index = label_list == label;

re_label = label_list;

data = srcdata(index,:);

maxlabel = max(label_list);

[cluster_idx, cluster_center] = kmeans(data,num_cluster,'distance','sqEuclidean', 'Replicates',num_iteration);

label1 = label;
label2 = maxlabel + 1;


oldcluster_idx = cluster_idx;

tempindex = oldcluster_idx == 1;
cluster_idx(tempindex) = label1;
tempindex = oldcluster_idx == 2;
cluster_idx(tempindex) = label2;


tempindex = re_label == label;
re_label(tempindex) = cluster_idx;




