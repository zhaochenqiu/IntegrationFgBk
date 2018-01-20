function [pvalue nvalue] = balanceCues(fgcues,bkcues)


% fgcues ->palue
% bkcues ->nvalue

[row_info column_info]			= size(bkcues);
[row_img column_img byte_img]	= size(fgcues);


index = fgcues == 255;
fgnum = sum(sum(index));

bknum = 0;
for i = 1:row_info
	label	= i;
	data	= bkcues(label,:);

	x = data(1);
	y = data(2);
	scale = data(3);
	
	x = round(x);
	y = round(y);
	border = round(scale);

    bknum = bknum + border*border;
end

% maxnum = max([fgnum bknum]);
maxnum = fgnum;

pvalue = (maxnum/fgnum)*(255);
nvalue = (maxnum/bknum)*(-255);

if fgnum < 10
    pvalue = 255;
end

if bknum < 10
    nvalue = -255;
end
