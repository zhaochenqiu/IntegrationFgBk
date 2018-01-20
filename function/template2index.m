function re_index = template2index(template)

[row column] = size(template);

matrix = zeros(row,column);

count = 1;

for j = 1:column
    for i = 1:row
        matrix(i,j) = count;
        count = count + 1;
    end
end

list1 = reshape(matrix,row*column,1);
list2 = reshape(template,row*column,1);

list = [list2 list1];

list = sortrows(list,-1);

re_index = list(:,2);
