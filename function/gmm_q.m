function [re_mus re_sigmas re_weights re_similar re_bestimg] = gmm_q(grayimg,mus,sigmas,weights) 

[row_mus column_mus byte_mus] = size(mus);
[row_sig column_sig byte_sig] = size(sigmas);
[row_wei column_wei byte_wei] = size(weights);

[row_img column_img byte_img] = size(grayimg);

bknum = 3;

% 暂时使用灰度图
if row_mus == 0
	mus		= zeros(row_img,column_img,bknum);
	sigmas	= zeros(row_img,column_img,bknum);
	weights = zeros(row_img,column_img,bknum);

	mus(:,:,1)		= grayimg;
	sigmas(:,:,1)	= 8;
	weights(:,:,1)	= 1;
end

rand_left = -2;
rand_right = 2;
rand_top = -2;
rand_bottom = 2;

re_similar = zeros(row_img,column_img);
ifmatchimg = zeros(row_img,column_img);
re_bestimg = zeros(row_img,column_img);


re_mus = mus;
re_sigmas = sigmas;
re_weights = weights;

rate_mus = 0.99;
rate_sig = 0.99;


for posr = 1:row_img
	for posc = 1:column_img
		for posb = 1:bknum
			
			musvalue = mus(posr,posc,posb);
			sigvalue = sigmas(posr,posc,posb) + 10;
			weivalue = weights(posr,posc,posb);
			imgvalue = grayimg(posr,posc);

			subvalue = abs(imgvalue - musvalue);

			if subvalue < sigvalue
				% matching
				ifmatchimg(posr,posc) = 1;

				% get the similar
				re_similar(posr,posc) = re_similar(posr,posc) +	weivalue;

				% update the background
				re_mus(posr,posc,posb)		= re_mus(posr,posc,posb)*rate_mus	 + imgvalue*(1 - rate_mus);
				re_sigmas(posr,posc,posb)	= re_sigmas(posr,posc,posb)*rate_sig + subvalue*(1 - rate_sig); 
				re_weights(posr,posc,posb)  = re_weights(posr,posc,posb) + 1;
			end
		end
	end
end


for posr = 1:row_img
	for posc = 1:column_img
		if ifmatchimg(posr,posc) == 0
			imgvalue = grayimg(posr,posc);

			list = weights(posr,posc,:);
			poslist = find(list == min(list));
			pos = poslist(1);

			% replace the background	
			re_mus(posr,posc,pos)		= imgvalue;
			re_sigmas(posr,posc,pos)	= 8;
			re_weights(posr,posc,pos)	= 1;	
		end
	end
end


for posr = 1:row_img
	for posc = 1:column_img
		weilist = weights(posr,posc,:);
		poslist = find(max(weilist) == weilist);
		pos = poslist(1);
		imgvalue = mus(posr,posc,pos);
	
		re_bestimg(posr,posc) = imgvalue;
	end
end

allweights = sum(weights,3);
re_similar = re_similar ./ allweights;

