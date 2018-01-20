function showimg = addPointInfo(fgimage,objinfo,pvalue,nvalue,threshold_rate)

if nargin == 2
	pvalue = 255;
	nvalue = -255;
	threshold_rate = 0.5;
end

[row_info column_info]			= size(objinfo);
[row_img column_img byte_img]	= size(fgimage);



showimg = double(fgimage);
%showimg = zeros(row_img,column_img);


%{
if byte_img == 3
	showimg = showimg + fgimage;
else
	for i = 1:3
		showimg(:,:,i) = showimg(:,:,i) + fgimage;
	end
end
%}

for i = 1:row_info
	label	= i;
	data	= objinfo(label,:);

	x = data(1);
	y = data(2);
	scale = data(3);
	
	x = round(x);
	y = round(y);
	border = round(scale);


	left	= x - border;
	right	= x + border;
	top		= y - border;
	bottom	= y + border;

	posr = y;
	posc = x;

	left	= max([1 left]);
	top		= max([1 top]);
	right	= min([column_img right]);
	bottom	= min([row_img bottom]);



	posr	= max([1 posr]);
	posr	= min([row_img posr]);

	posc	= max([1 posc]);
	posc	= min([column_img posc]);



	tempimg = fgimage(top:bottom,left:right,1);
	index = tempimg == 255;
	fgnum = sum(sum(index));
	allnum = (bottom - top + 1)*(right - left + 1);
	fgrate = fgnum/allnum;


	if fgrate > threshold_rate
		showimg(posr,posc,1) = showimg(posr,posc,1) + pvalue*border;
	else
		showimg(posr,posc,1) = showimg(posr,posc,1) + nvalue*border;
	end
end
