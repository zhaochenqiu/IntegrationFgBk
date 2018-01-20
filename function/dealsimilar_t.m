function re_similar = dealSimilar(similar) 

maxvalue = max(max(similar));
maxvalue = 255;

index = similar < 0;
re_similar = similar;
re_similar(index) = 0;

if maxvalue == 0
	maxvalue = 1;
end

re_similar = re_similar / maxvalue;
