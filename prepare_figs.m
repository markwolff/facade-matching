%% Gabor

%%

% close all
% clear all
% load nyc_00_00_1
clear set
I1 = uint8(median_patches(:,:,:,260));
I_LAB = rgb2lab(I1);

L = I_LAB(:,:,1);
A = I_LAB(:,:,2);
B = I_LAB(:,:,3);

histl = hist(L(:), 40);
hista = hist(A(:), 40);
histb = hist(B(:), 40);

figure(1), bar(histl,'r');
set(gcf,'Color', 'w');
axis off
export_fig('C:/Users/mrw5329/Documents/494H_progress_reports/CVPR2016/graphics/feature_flowcharts/hist_L.svg');

figure(2), bar(hista,'r');
set(gcf,'Color', 'w');
axis off
export_fig('C:/Users/mrw5329/Documents/494H_progress_reports/CVPR2016/graphics/feature_flowcharts/hist_A.png');

figure(3), bar(histb,'r');
set(gcf,'Color', 'w');
axis off
export_fig('C:/Users/mrw5329/Documents/494H_progress_reports/CVPR2016/graphics/feature_flowcharts/hist_B.png');


% I = rgb2gray(uint8(I));
% figure(1), imshow(uint8(I));
% export_fig('C:/Users/mrw5329/Documents/494H_progress_reports/CVPR2016/graphics/feature_flowcharts/motif_original.png');
return
I2 = edge(I, 'sobel', .028);
figure(2), imagesc(I2), colormap gray;

[vals_row, vals_col] = find(I2);
vecs = randperm(length(vals_row), 400);

vals_row = vals_row(vecs);
vals_col = vals_col(vecs);

figure(3), clf,plot(vals_col, 121-vals_row, 'k.', 'MarkerSize', 25);
hold on
plot(vals_col(200), 121-vals_row(200), 'r.', 'MarkerSize', 35);
axis off


% I2 = edge();
% 
% 
% figure, imagesc(uint8(rgb2gray(uint8(I))));
% colormap gray