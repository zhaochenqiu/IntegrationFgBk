clear all
close all
clc

run('../config/config_tool');

files = importdata('video_list.txt');

[row column] = size(files);

videoimg = [];


for i = 1:row
    img = double(imread(files{i}));

    [row_t column_t byte_t] = size(img);
    borderimg = zeros(10,600,byte_t) + 255;

    simg = scaleImage_byWidth(img,600);

    videoimg = [videoimg ; borderimg ; simg];

    [i row]
end

imwrite(uint8(videoimg),'videoimg.png')



files = importdata('truth_list.txt');

[row column] = size(files);

truthimg = [];


for i = 1:row
    img = double(imread(files{i}));

    [row_t column_t byte_t] = size(img);
    borderimg = zeros(10,600,byte_t) + 255;

    simg = scaleImage_byWidth(img,600);

    truthimg = [truthimg  ; borderimg ;  simg];

    [i row]
end

imwrite(uint8(truthimg),'truthimg.png')



files = importdata('soaf_list.txt');

[row column] = size(files);

soafimg = [];


for i = 1:row
    img = double(imread(files{i}));

    [row_t column_t byte_t] = size(img);
    borderimg = zeros(10,600,byte_t) + 255;

    simg = scaleImage_byWidth(img,600);

    soafimg = [soafimg  ; borderimg ;  simg];

    [i row]
end

imwrite(uint8(soafimg),'soafimg.png')




files = importdata('soaf_list1.txt');

[row column] = size(files);

soafimg1 = [];


for i = 1:row
    img = double(imread(files{i}));

    [row_t column_t byte_t] = size(img);
    borderimg = zeros(10,600,byte_t) + 255;

    simg = scaleImage_byWidth(img,600);

    soafimg1 = [soafimg1  ; borderimg ;  simg];

    [i row]
end

imwrite(uint8(soafimg1),'soafimg1.png')



files = importdata('MST_list.txt');

[row column] = size(files);

mstimg = [];

for i = 1:row
    img = double(imread(files{i}))*255;

    [row_t column_t byte_t] = size(img);
    borderimg = zeros(10,600,byte_t) + 255;

    simg = scaleImage_byWidth(img,600);

    mstimg = [mstimg  ; borderimg ;  simg];

    [i row]
end

imwrite(uint8(mstimg),'mstimg.png')

input('temp')


files = importdata('RMoG_list.txt');

[row column] = size(files);

rmogimg = [];


for i = 1:row
    img = double(imread(files{i}));

    [row_t column_t byte_t] = size(img);
    borderimg = zeros(10,600,byte_t) + 255;

    simg = scaleImage_byWidth(img,600);

    rmogimg = [rmogimg  ; borderimg ;  simg];

    [i row]
end

imwrite(uint8(rmogimg),'rmogimg.png')





files = importdata('IMoG_list.txt');

[row column] = size(files);

imogimg = [];


for i = 1:row
    img = double(imread(files{i}));

    [row_t column_t byte_t] = size(img);
    borderimg = zeros(10,600,byte_t) + 255;

    simg = scaleImage_byWidth(img,600);

    imogimg = [imogimg  ; borderimg ;  simg];

    [i row]
end

imwrite(uint8(imogimg),'imogimg.png')





files = importdata('ViBe+_list.txt');

[row column] = size(files);

vibepimg = [];


for i = 1:row
    img = double(imread(files{i}));

    [row_t column_t byte_t] = size(img);
    borderimg = zeros(10,600,byte_t) + 255;

    simg = scaleImage_byWidth(img,600);

    vibepimg = [vibepimg  ; borderimg ;  simg];

    [i row]
end

imwrite(uint8(vibepimg),'vibepimg.png')





files = importdata('RECTGAUSS_list.txt');

[row column] = size(files);

rectgaussimg = [];


for i = 1:row
    img = double(imread(files{i}));

    [row_t column_t byte_t] = size(img);
    borderimg = zeros(10,600,byte_t) + 255;

    simg = scaleImage_byWidth(img,600);

    rectgaussimg = [rectgaussimg  ; borderimg ;  simg];

    [i row]
end

imwrite(uint8(rectgaussimg),'rectgaussimg.png')




files = importdata('multilayer_list.txt');

[row column] = size(files);

multilayerimg = [];


for i = 1:row
    img = double(imread(files{i}));

    [row_t column_t byte_t] = size(img);
    borderimg = zeros(10,600,byte_t) + 255;

    simg = scaleImage_byWidth(img,600);

    multilayerimg = [multilayerimg  ; borderimg ;  simg];

    [i row]
end

imwrite(uint8(multilayerimg),'multilayerimg.png')





files = importdata('multicue_list.txt');

[row column] = size(files);

multicueimg = [];


for i = 1:row
    img = double(imread(files{i}));

    [row_t column_t byte_t] = size(img);
    borderimg = zeros(10,600,byte_t) + 255;

    simg = scaleImage_byWidth(img,600);

    multicueimg = [multicueimg  ; borderimg ;  simg];

    [i row]
end

imwrite(uint8(multicueimg),'multicueimg.png')


videoimg = funcimg(videoimg);
truthimg = funcimg(truthimg);
soafimg  = funcimg(soafimg);
soafimg1 = funcimg(soafimg1);
mstimg   = funcimg(mstimg);
rmogimg  = funcimg(rmogimg);
imogimg  = funcimg(imogimg);
vibepimg = funcimg(vibepimg);
rectgaussimg    = funcimg(rectgaussimg);
multilayerimg   = funcimg(multilayerimg);
multicueimg     = funcimg(multicueimg);


[row_t column_t byte_t] = size(videoimg);
borderimg = zeros(row_t,10,3) + 255;


finimg = videoimg;
finimg = [finimg borderimg truthimg];
finimg = [finimg borderimg soafimg];
finimg = [finimg borderimg soafimg1];
finimg = [finimg borderimg mstimg];
finimg = [finimg borderimg rmogimg];
finimg = [finimg borderimg imogimg];
finimg = [finimg borderimg vibepimg];
finimg = [finimg borderimg rectgaussimg];
finimg = [finimg borderimg multilayerimg];
finimg = [finimg borderimg multicue];

imwrite(uint8(finimg),'finimg.png')
