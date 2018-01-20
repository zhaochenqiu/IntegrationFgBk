function re_image = fillSimilarImage(similarimage)

[row column byte] = size(similarimage);

if byte ~= 1
	disp('error: in the fullSimilarImage, byte is not 1');
end


similarimage_left = similarimage;

for tempi = 2:row - 1
	for tempj = 2:column - 1
		i = tempi;
		j = tempj;

		if similarimage_left(i,j) == -1
			matrix = similarimage_left(i - 1:i + 1,j - 1:j + 1);

			index = matrix ~= -1;
			numvalue = sum(sum(index));
			sumvalue = sum(sum(matrix(index)));

			if numvalue == 0
				disp('error: in the fillSimilarImage, the numvalue = 0');
				numvalue = 1;
			end

			similar = sumvalue/numvalue;

			similarimage_left(i,j) = similar;
		end
	end
end


similarimage_right = similarimage;

for tempi = 2:row - 1
	for tempj = 2:column - 1
		i = tempi;
		j = column - tempj + 1;

		if similarimage_right(i,j) == -1
			matrix = similarimage_right(i - 1:i + 1,j - 1:j + 1);

			index = matrix ~= -1;
			numvalue = sum(sum(index));
			sumvalue = sum(sum(matrix(index)));

			if numvalue == 0
				disp('error: in the fillSimilarImage, the numvalue = 0');
				numvalue = 1;
			end

			similar = sumvalue/numvalue;

			similarimage_right(i,j) = similar;
		end
	end
end



%{
similarimage_top = similarimage;

for tempi = 2:row - 1
	for tempj = 2:column - 1
		i = row - tempi + 1;
		j = tempj;

		if similarimage_top(i,j) == -1
			matrix = similarimage_top(i - 1:i + 1,j - 1:j + 1);

			index = matrix ~= -1;
			numvalue = sum(sum(index));
			sumvalue = sum(sum(matrix(index)));

			if numvalue == 0
				disp('error: in the fillSimilarImage, the numvalue = 0');
				numvalue = 1;
			end

			similar = sumvalue/numvalue;

			similarimage_top(i,j) = similar;
		end
	end
end


similarimage_bottom = similarimage;

for tempi = 2:row - 1
	for tempj = 2:column - 1
		i = row - tempi + 1;
		j = column - tempj + 1;

		if similarimage_bottom(i,j) == -1
			matrix = similarimage_bottom(i - 1:i + 1,j - 1:j + 1);

			index = matrix ~= -1;
			numvalue = sum(sum(index));
			sumvalue = sum(sum(matrix(index)));

			if numvalue == 0
				disp('error: in the fillSimilarImage, the numvalue = 0');
				numvalue = 1;
			end

			similar = sumvalue/numvalue;

			similarimage_bottom(i,j) = similar;
		end
	end
end

re_image = (similarimage_left + similarimage_right + similarimage_top + similarimage_bottom) * 0.25;

%}

re_image = (similarimage_left + similarimage_right)*0.5;
