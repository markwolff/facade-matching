function cost_matrix = CalcShapeContextCost(street_samps, aerial_samps)
%load sc_cost_test
N = size(street_samps, 1);
street_samps(:,1) = street_samps(:,1)/(80*sqrt(2));
street_samps(:,2) = street_samps(:,2)/(120*sqrt(2));

cost_matrix = zeros(size(street_samps,1));
for i = 1 : size(street_samps,1)
   pt = street_samps(i,:);
   other_vecs = 1 : N;
   other_vecs = other_vecs(other_vecs~=i);
   samps = street_samps(other_vecs,:);
   lp_hist_street(:,:,i) = LP_Histogram(pt, samps);
   lp_hist_street(:,:,i) = lp_hist_street(:,:,i)/sum(sum(lp_hist_street(:,:,i)));
end
for i = 1 : size(aerial_samps,1)
    pt = aerial_samps(i,:);
    other_vecs = 1 : N;
    other_vecs = other_vecs(other_vecs~=i);
    samps = aerial_samps(other_vecs,:);
    lp_hist_aerial(:,:,i) = LP_Histogram(pt, samps);
    lp_hist_aerial(:,:,i) = lp_hist_aerial(:,:,i)/sum(sum(lp_hist_aerial(:,:,i)));
end
    
cost_matrix = ObtainCostMatrix(lp_hist_street, lp_hist_aerial);

end

function cost_matrix = ObtainCostMatrix(street, aerial)
N = size(street,3);
cost_matrix = zeros(N,N);
for i = 1 : N
    for j = 1 : N
        mat1 = street(:,:,i)+.0001;
        mat1 = mat1/sum(sum(mat1));
        mat2 = aerial(:,:,j)+.0001;
        mat2 = mat2/sum(sum(mat2));
        cost_matrix(i,j) = sum(sum(((mat1 - mat2).^2)./((mat1+mat2))));
    end
end

% cost_matrix = cost_matrix/max(max(cost_matrix));

cost_matrix = cost_matrix/(7*7);
end

function lp_hist = LP_Histogram(pt, samps)
    r_theta = zeros(size(samps));
    pt = repmat(pt, size(samps, 1), 1);
    
    r_theta(:,1) = sqrt(sum((pt-samps).^2,2));
    r_theta(:,2) = atan2d((samps(:,1)-pt(:,1)),(samps(:,2)-pt(:,2)));
    edges{1} = logspace(-1, 0, 7);
    edges{2} = linspace(-180, 180, 7);
    edges{1} = edges{1} - edges{1}(1);
    edges{1}(end) = 1;
    lp_hist = hist3(r_theta,'Edges', edges);
    
    
end