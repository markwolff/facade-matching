function res = GTFeatureManager(patches, type, aerial_patch, vectors)

    if strcmp(type, 'edge')
        res = edge_NCC(patches, aerial_patch,vectors);
    elseif strcmp(type, 'color')
        res = color_IG(patches, aerial_patch,vectors);
    else
        error('GTFeatureManager: Invalid feature type: %s', type);
    end

end


function res = edge_NCC(patches, aerial_patch,vectors)
    res = zeros(1, size(patches,4));
    aerial_patch = (rgb2gray(uint8(round(aerial_patch))));
    [aerial_patch, ~] = imgradient((aerial_patch), 'Sobel');
    
    for i = 1 : size(patches, 4)
        patch = (rgb2gray(uint8(round(patches(:,:,:,i)))));
        [patch, ~] = imgradient(patch, 'Sobel');
        if patch == zeros(size(patch))
            continue
        end
        res(i) = max(max(normxcorr2(patch,[aerial_patch aerial_patch; aerial_patch aerial_patch])));
        
%         if any(i == vectors)
%             while res(i) < .7
%                 res(i) = res(i) * 1.5;
%             end
%         end
%         while res(i) > .95
%             res(i) = res(i) * .9;
%         end
    end
end

function res = color_IG(patches, aerial_patch, vectors)
    res = zeros(1, size(patches,4));
    aerial_LAB = rgb2lab(uint8(aerial_patch));
    aerial_L = reshape(aerial_LAB(:,:,1), 1, numel(aerial_LAB(:,:,1)));
    aerial_A = reshape(aerial_LAB(:,:,2), 1, numel(aerial_LAB(:,:,2)));
    aerial_B = reshape(aerial_LAB(:,:,3), 1, numel(aerial_LAB(:,:,3)));
    
    for i = 1 : size(patches, 4)
        patch_LAB = rgb2lab(uint8(patches(:,:,:,i)));
        patch_L = reshape(patch_LAB(:,:,1), 1, numel(patch_LAB(:,:,1)));
        patch_A = reshape(patch_LAB(:,:,2), 1, numel(patch_LAB(:,:,2)));
        patch_B = reshape(patch_LAB(:,:,3), 1, numel(patch_LAB(:,:,3)));
        
        patch_L = patch_L - mean([mean(patch_L - aerial_L), median(patch_L-aerial_L)]);
        patch_A = patch_A - mean([mean(patch_A - aerial_A), median(patch_A-aerial_A)]);
        patch_B = patch_B - mean([mean(patch_B - aerial_B), median(patch_B-aerial_B)]);
        
        hist_L = hist(patch_L, linspace(min([aerial_L, patch_L]), ...
        max([aerial_L, patch_L]), 100));
        hist_A = hist(patch_A, linspace(min([aerial_A, patch_A]), ...
        max([aerial_A, patch_A]), 100));
        hist_B = hist(patch_B, linspace(min([aerial_B, patch_B]), ...
        max([aerial_B, patch_B]), 100));
        
        aerial_hist_L = hist(aerial_L, linspace(min([aerial_L, patch_L]), ...
        max([aerial_L, patch_L]), 100));
        aerial_hist_A = hist(aerial_A, linspace(min([aerial_A, patch_A]), ...
        max([aerial_A, patch_A]), 100));
        aerial_hist_B = hist(aerial_B, linspace(min([aerial_B, patch_B]), ...
        max([aerial_B, patch_B]), 100));
        
        hist_L = hist_L/sum(hist_L);
        hist_A = hist_A/sum(hist_A);
        hist_B = hist_B/sum(hist_B);
        hist_L = hist_L - mean(hist_L);
        hist_A = hist_A - mean(hist_A);
        hist_B = hist_B - mean(hist_B);
        
        
        aerial_hist_L = aerial_hist_L/sum(aerial_hist_L);
        aerial_hist_A = aerial_hist_A/sum(aerial_hist_A);
        aerial_hist_B = aerial_hist_B/sum(aerial_hist_B);
        aerial_hist_L = aerial_hist_L - mean(aerial_hist_L);
        aerial_hist_A = aerial_hist_A - mean(aerial_hist_A);
        aerial_hist_B = aerial_hist_B - mean(aerial_hist_B);
        
        res(i) = res(i) + (sum((hist_L .* aerial_hist_L)/(std(hist_L)*std(aerial_hist_L))));
        res(i) = res(i) + (sum((hist_A .* aerial_hist_A)/(std(hist_A)*std(aerial_hist_A))));
        res(i) = res(i) + (sum((hist_B .* aerial_hist_B)/(std(hist_B)*std(aerial_hist_B))));
        
        res(i) = res(i)/300;
        
%         if any(i == vectors)
%             while res(i) < .5
%                 res(i) = res(i) * 1.5;
%             end
%         end
%         while res(i) > .85
%             res(i) = res(i) * .9;
%         end
        
    end
end