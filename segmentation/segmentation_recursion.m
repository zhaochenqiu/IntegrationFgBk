function [re_labels re_num] = segmentation_recursion(image_list,labels,num,threshold)

varlist = var(image_list,0,1);
maxvar = max(varlist);

if maxvar < threshold
	re_labels = labels;
	re_num = num;
else
	index = labels == num;

	[labels_clu image_list1 image_list2] = segment_base(image_list,labels,index);

	index1 = labels_clu == 1;
	index2 = labels_clu == 2;

	num = num + 1;
	labels(index1) = num;
	[labels num] = segmentation_recursion(image_list1,labels,num,threshold);


	num = num + 1;
	labels(index2) = num;
	[labels num] = segmentation_recursion(image_list2,labels,num,threshold);

	re_labels = labels;
	re_num = num;
end


