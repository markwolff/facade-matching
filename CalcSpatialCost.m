function cost_matrix = CalcSpatialCost(street, aerial)
    cost_matrix = ObtainCostMatrix(street,aerial);
end

function cost_matrix = ObtainCostMatrix(street, aerial)
    N = size(street, 1);
    cost_matrix = zeros(N);
    for i = 1 : N
        for j = 1 : N
            dist_vec = abs(street(i,:) - aerial(j,:)); 
            cost_matrix(i,j) = norm(dist_vec)/norm([80,120]);
        end
    end
end