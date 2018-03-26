function cost_matrix = CalcMotifCost(street, aerial, pstreet, paerial)
patch_size = 32;
patch_size = patch_size/2 - 1;

N = size(street, 1);
pstreet = rgb2lab(pstreet);
paerial = rgb2lab(paerial);
max1 = max(max([pstreet(:,:,1), paerial(:,:,1)]));
max2 = max(max([pstreet(:,:,2), paerial(:,:,2)]));
max3 = max(max([pstreet(:,:,3), paerial(:,:,3)]));
min1 = min(min([pstreet(:,:,1), paerial(:,:,1)]));
min2 = min(min([pstreet(:,:,2), paerial(:,:,2)]));
min3 = min(min([pstreet(:,:,3), paerial(:,:,3)]));

for i = 1 : size(street,1) 
    new_rect_street = [street(i,2)-patch_size, street(i,1)-patch_size, 32, 32];
    new_rect_aerial = [aerial(i,2)-patch_size, aerial(i,1)-patch_size, 32, 32];
 
    spatch = imcrop(pstreet, new_rect_street);
    apatch = imcrop(paerial, new_rect_aerial);
    
    shist(:,1,i) = sum(hist(spatch(:,:,1),linspace(min1,max1,8)),2);
    ahist(:,1,i) = sum(hist(apatch(:,:,1),linspace(min2,max2,8)),2);
    shist(:,2,i) = sum(hist(spatch(:,:,2),linspace(min3,max3,8)),2);
    ahist(:,2,i) = sum(hist(apatch(:,:,2),linspace(min1,max1,8)),2);
    shist(:,3,i) = sum(hist(spatch(:,:,3),linspace(min2,max2,8)),2);
    ahist(:,3,i) = sum(hist(apatch(:,:,3),linspace(min3,max3,8)),2);
    
    shist(:,1,i) = shist(:,1,i)/sum(shist(:,1,i));
    shist(:,2,i) = shist(:,2,i)/sum(shist(:,2,i));
    shist(:,3,i) = shist(:,3,i)/sum(shist(:,3,i));
    ahist(:,1,i) = ahist(:,1,i)/sum(ahist(:,1,i));
    ahist(:,2,i) = ahist(:,2,i)/sum(ahist(:,2,i));
    ahist(:,3,i) = ahist(:,3,i)/sum(ahist(:,3,i));
    
    
end
    
cost_matrix = ObtainCostMatrix(shist, ahist);


end



function cost_matrix = ObtainCostMatrix(street, aerial)
    N = size(street,3);
    cost_matrix = zeros(N,N);
    
    for i = 1 : N
        for j = 1 : N
            mat1 = street(:,:,i)+.001;
            mat2 = aerial(:,:,j)+.001;
%             figure(1), subplot(2,1,1), bar(mat1), subplot(2,1,2), bar(mat2);
%             cost_matrix(i,j) = sum(sum(((mat1 - mat2).^2)./(mat1+mat2+.1)));
            cost_matrix(i,j) = sum(sum(mat2.*abs(log(mat1)./log(mat2))));
            
        end
    end
%     cost_matrix = cost_matrix/3.0;
    cost_matrix = cost_matrix - min(min(cost_matrix));
    cost_matrix = cost_matrix / max(max(cost_matrix));
%     cost_matrix = 1 - exp(-1*cost_matrix);
end
