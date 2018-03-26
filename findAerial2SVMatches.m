clear all
close all

camera_poses = '../recur/data/nyc/camera_poses.xml';

tCPoses = xml2struct(camera_poses);
matches = [];
I = imread('../recur/data/nyc/image0000041.png');
figure, imshow(I);
[x, y] = getpts
close all
% [1558593.78950476
% 7874921.1003746
% 2187.95862239335]
% x = 2187.95862239335 * x;
% y = 2187.95862239335 * y;
% z = 2187.95862239335;
% x = 3998.5;
% y = 2714.5;
[loc, matches] = imcoords2LL(y, x, 41, tCPoses, 1)
