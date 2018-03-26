function cost_matrix = CalcMotifCost(street, aerial, pstreet, paerial)
patch_size = 32;
patch_size = patch_size/2 - 1;

gabor(:,:,1) = gabor_fn(1, .5, 0, 1, 0 );
gabor(:,:,2) = gabor_fn(1, .5, 0, 1, pi/4 );
gabor(:,:,3) = gabor_fn(1, .5, 0, 1, pi/2 );
gabor(:,:,4) = gabor_fn(1, .5, 0, 1, 3*pi/4 );

N = size(street, 1);
pstreet = rgb2gray(pstreet);
paerial = rgb2gray(paerial);

ps(:,:,1) = conv2(double(pstreet), double(gabor(:,:,1)), 'same');
ps(:,:,2) = conv2(double(pstreet), double(gabor(:,:,2)), 'same');
ps(:,:,3) = conv2(double(pstreet), double(gabor(:,:,3)), 'same');
ps(:,:,4) = conv2(double(pstreet), double(gabor(:,:,4)), 'same');
pa(:,:,1) = conv2(double(paerial), double(gabor(:,:,1)), 'same');
pa(:,:,2) = conv2(double(paerial), double(gabor(:,:,2)), 'same');
pa(:,:,3) = conv2(double(paerial), double(gabor(:,:,3)), 'same');
pa(:,:,4) = conv2(double(paerial), double(gabor(:,:,4)), 'same');
ps = mean(ps,3);
pa = mean(pa,3);

for i = 1 : size(street,1)
    new_rect_street = [street(i,2)-patch_size, street(i,1)-patch_size, 32, 32];
    new_rect_aerial = [aerial(i,2)-patch_size, aerial(i,1)-patch_size, 32, 32];
    new_rect_street(new_rect_street < 1) = 1;
    new_rect_aerial(new_rect_aerial < 1) = 1;
    if new_rect_street(1)+32 > 120
        new_rect_street(1) = 120-32;
    end
    if new_rect_street(2)+32 > 80
        new_rect_street(2) = 80-32;
    end
    if new_rect_aerial(1)+32 > 120
        new_rect_aerial(1) = 120-32;
    end
    if new_rect_aerial(2)+32 > 80
        new_rect_aerial(2) = 80-32;
    end
    
    spatch = imcrop(ps, new_rect_street);
    apatch = imcrop(pa, new_rect_aerial);
    
    shist(:,i) = spatch(:);
    ahist(:,i) = apatch(:);
end
    
cost_matrix = ObtainCostMatrix(shist, ahist);


end


function cost_matrix = ObtainCostMatrix(street, aerial)
    N = size(street,2);
    cost_matrix = zeros(N,N);
    for i = 1 : N
        for j = 1 : N
            mat1 = street(:,i);
            mat2 = aerial(:,j);
            cost_matrix(i,j) = sum(sum(((mat1 - mat2).^2)./(mat1+mat2)));
        end
    end
    cost_matrix = cost_matrix - min(min(cost_matrix));
    cost_matrix = cost_matrix / max(max(cost_matrix));
%     cost_matrix = cost_matrix/max(max(cost_matrix));
end