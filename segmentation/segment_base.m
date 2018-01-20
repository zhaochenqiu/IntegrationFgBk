function [re_labels re_cluster1 re_cluster2] = segment_base(data,labels,index)

num_cluster = 2;

[cluster_idx, cluster_center] = kmeans(data,num_cluster,'distance','sqEuclidean', 'Replicates',5);


re_labels = labels - labels;
re_labels(index) = cluster_idx;


index1 = cluster_idx == 1;
index2 = cluster_idx == 2;

re_cluster1 = data(index1,:);
re_cluster2 = data(index2,:);
