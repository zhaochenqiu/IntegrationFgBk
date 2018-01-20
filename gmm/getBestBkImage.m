function re_image = getBestBkImage(mus,weight)

[row column byte] = size(mus);

re_image = zeros(row,column);

for i = 1:row
    for j = 1:column
        
        judge = 0;
        pos = 1;
        
        for q = 1:byte
            if weight(i,j,q) > judge
                pos = q;
                judge = weight(i,j,q);
            end
        end
        
        re_image(i,j) = mus(i,j,pos);
    end
end