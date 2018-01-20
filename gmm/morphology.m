function re_image = morphology(image,mark)

[row column num] = size(image);

re_image = image;
matrix = zeros(3,3);

for i = 2:row - 1
    for j = 2:column - 1
        matrix(1,1) = image(i-1 ,j-1);
        matrix(2,1) = image(i   ,j-1);
        matrix(3,1) = image(i+1 ,j-1);
        
        matrix(1,2) = image(i-1 ,j);
        matrix(2,2) = image(i   ,j);
        matrix(3,2) = image(i+1 ,j);
        
        matrix(1,3) = image(i-1 ,j+1);
        matrix(2,3) = image(i   ,j+1);
        matrix(3,3) = image(i+1 ,j+1);
        
        judge = 0;
        for q1 = 1:3
            for q2 = 1:3
                if matrix(q1,q2) == 255
                    judge = judge + 1;
                end
            end
        end
        
        if judge > mark
            judge = 255;
        else
            judge = 0;
        end
        
        for q = 1:num
            re_image(i,j,q) = judge;
        end
    end
end