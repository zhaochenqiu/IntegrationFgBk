function result = subnoise(img)



result = img;
deal = double(img);
[row column num] = size(deal);

for i=2:row-1
    for j=2:column-1
     
        list=[deal(i-1,j-1) deal(i-1,j) deal(i-1,j+1) deal(i,j-1) deal(i,j) deal(i,j+1) deal(i+1,j-1) deal(i+1,j) deal(i+1,j+1)];  
        temp = sort(list);
        value = temp(5);
        for q = 1:num
            result(i,j,q) = value;
        end
    end
end