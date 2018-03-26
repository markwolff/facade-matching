function cost = CalcMotifCost(street, aerial)

cost = -1;

figure(1), subplot(1,2,1), imshow(aerial), xlabel('Aerial')
subplot(1,2,2), imshow(street), xlabel('Street')

%% Color Correction
pstreet = rgb2lab(street);
paerial = rgb2lab(aerial);

pstreet(:,:,1) = pstreet(:,:,1) - (mean(mean(pstreet(:,:,1))) - mean(mean(paerial(:,:,1))));
pstreet(:,:,2) = pstreet(:,:,2) - (mean(mean(pstreet(:,:,2))) - mean(mean(paerial(:,:,2))));
pstreet(:,:,3) = pstreet(:,:,3) - (mean(mean(pstreet(:,:,3))) - mean(mean(paerial(:,:,3))));

street = lab2rgb(pstreet);
aerial = lab2rgb(paerial);
figure(2), subplot(1,2,1), imshow(aerial), xlabel('Aerial')
subplot(1,2,2), imshow(street), xlabel('Street')


%% Obtain corresponding edge images
street_edge = edge(rgb2gray(street), 'sobel', .008);
aerial_edge = edge(rgb2gray(aerial), 'sobel', .008);

figure(3), subplot(1,2,1), imshow(aerial_edge), xlabel('Aerial')
subplot(1,2,2), imshow(street_edge), xlabel('Street')

%% Shift patches so that they are translationally identical
street_grad = imgradient(rgb2gray(street));
aerial_grad = imgradient(rgb2gray(aerial));

res = normxcorr2(aerial_grad, [street_grad street_grad; ...
    street_grad street_grad]);
maxValue = max(res(:));
[max_row max_col] = find(res == maxValue);
street_edge = circshift(street_edge, [max_row max_col]);

figure(4), subplot(1,2,1), imshow(aerial_edge), xlabel('Aerial')
subplot(1,2,2), imshow(street_edge), xlabel('Street')

%% Sample N=400 random points from edge image
N = 400;
[street_rows street_cols] = find(street_edge == 1);
[aerial_rows aerial_cols] = find(aerial_edge == 1);

street_samps = datasample([street_rows street_cols], N);
aerial_samps = datasample([aerial_rows aerial_cols], N);

%% Obtain cost matrix for shape context
sc_cost = CalcShapeContextCost(street_samps, aerial_samps);

%% Obtain cost matrix for color information gain
ig_cost = CalcColorCost(street_samps, aerial_samps, street, aerial);

%% Obtain cost matrix for texture difference
tex_cost = CalcTextureCost(street_samps, aerial_samps, street, aerial);

%% Obtain cost matrix for spatial difference
loc_cost = CalcSpatialCost(street_samps, aerial_samps);


%% Sum cost matrices and find optimal solution, return cost == minimal cost
all_cost = .95*((sc_cost+tex_cost+ig_cost)/3) + .05*loc_cost;
[assignment, cost] = munkres(all_cost);
cost = cost / N;
keyboard
end