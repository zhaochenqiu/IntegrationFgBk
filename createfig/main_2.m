clear all
close all
clc


files = importdata('temp.txt');

[row column] = size(files);

finimg = [];

for i = 1:row
    filename = files{i};
    img = double(imread(filename));

    img = funcimg(img);

    [row_t column_t byte_t] = size(img);

    borderimg = zeros(row_t,10,byte_t) + 255;

    finimg = [finimg img borderimg];
end

imwrite(uint8(finimg),'allfinimg.png')
