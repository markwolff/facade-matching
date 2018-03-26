close all
clear all

aerial_num = 1;
street_num = 1;

imfolder = 'images/';
aerial_path = sprintf('%saerial_%02d.jpg',imfolder,aerial_num);
street_path = sprintf('%sstreet_%02d_%02d.jpg',imfolder,aerial_num,street_num);


street = imread(street_path);
aerial = imread(aerial_path);

street = imresize(street, [80 120]);
aerial = imresize(aerial, [80 120]);



cost = CalcMotifCost(street, aerial);