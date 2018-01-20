function re_similar = subImg2Similar_2(img,fgimage,subimage,numlabels) 

if nargin == 3
	numlabels = 200;
end

[row_img column_img byte_img] = size(img);


oldsubimage = subimage;

splitimg = uint8(img);

global g_factor;

objects = getSuperPixel_SLIC(splitimg,numlabels,g_factor);


[row_obj column_obj] = size(objects);

index = fgimage == 100;
subimage(index) = -255;




%{
displayMatrixImage(1,1,2,subimage,fgimage)
input('pause')
%}

re_similar = zeros(row_img,column_img) - 1;

for i = 1:column_obj
	label = i;

	objdata = objects{label};

	objmask = objdata{2};
	objinfo = objdata{3};
	objrect = objinfo(1:4);
	objcount = objinfo(5);

	left	= objrect(1);
	top		= objrect(2);
	right	= objrect(3);
	bottom	= objrect(4);

	index	= objmask == 255;
	index   = ~index;

	tempimg = subimage(top:bottom,left:right);
	tempimg(index) = 0;
	sumvalue = sum(sum(tempimg));

	index	= ~index;

	tempimg	= re_similar(top:bottom,left:right);
	similar	 = sumvalue/objcount;
	tempimg(index) = similar;
	re_similar(top:bottom,left:right) = tempimg;


%	showSchedule(i,column_obj,'subImg2Similar');


%	similar
%	displayMatrixImage(1,1,3,re_similar,objmask,subimage)
end

