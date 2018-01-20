function re_label = segmentBinary(data,labels)

maxlabel = max(labels);

for i = 0:maxlabel
    labels = clusterLabelData(data,labels,i);
end

re_label = labels;
