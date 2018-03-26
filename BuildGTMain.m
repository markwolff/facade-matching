function res = BuildGTMain()
close all
clear all
% return
% load nyc_00_00_1
addpath('export_fig');
tform = [];
sv_median_patch = [];
% %% Temp code
%     for i = 344 : 346
%         figure(1), imshow(uint8(median_patches(:,:,:,i+1)));
%         export_fig(sprintf('C:/users/mrw5329/Desktop/motif_%03d.png', i+1));
%     end
%     return

    close all
    clear all
    city = 'nyc';
    match_set = 9;
    set = 0;
    segment = 0;
    median_patches = [];
    belonging_img = [];
%     currdir = cd;
%     image_num = 626;
%     
%     load(sprintf('../im%d.mat',image_num));
%     I = imread(GTPathManager('nyc','original_aerial',0,0,626,0,1));
%     I = imrotate(I,180);
%     figure(1), imshow(I);
%     hold on
%     
    %% 1. Get valid lattices for each detected facade
%     for i = 1 : length(A)
%         pts = 8*A(i).corners([1:end 1],:);
%         plot(pts(:,1),pts(:,2),'r','linewidth',2);
%         % Crop each lattice and save in temp directory
%         rect = pts2rect(8*A(i).corners);
%         B = imrotate(imcrop(I,rect), 180);
%         imwrite(B, GTPathManager('nyc','aerial_lattice_crops',0,0,image_num,i,1));
%         figure(2), imshow(B);
%         A(i).score
%         pause(.001);
%     end
%     close all
%     pause(.01);
%     
%     cd('C:/Users/mrw5329/Documents/TransSymBased_ACCV10_Park64bJCbu');
%     BatchAll(GTPathManager('nyc','aerial_lattice_proposals',0,0,image_num,0,0), GTPathManager('nyc','aerial_lattice_info',0,0,0,0,0), GTPathManager('nyc','aerial_lattice_crops',0,0,image_num,0,0));
%     cd(currdir);
%     pwd
    
%     %% 2. Find GPS coordinate of each valid lattice
%     for i = 1 : length(A)
%         load(GTPathManager('nyc','aerial_lattice_info', 0, 0, image_num, i, 1));
%         if numel(lats) == 0
%             continue
%         else
%             flag_sums = zeros(size(flags));
%             for j = 1 : length(lats)
%                 flag_sums(j) = sum(sum(flags{j}));
%             end
%             [~,max_flag] = max(flag_sums);
%             lat = lats{max_flag};
%             flag = flags{max_flag};
%             pt = A(i).corners(1,:) + flippoint(EstimateBottomLocation(flag, lat), pts2rect(8*A(i).corners));
%             [matches ,LL] = getLLMatches(image_num, pt);
%             disp(LL);
%         end
%     end
    
    
    
    %% 4. Build output of valid lattices
    warp_pts = [[1;1],  [1;80], [120;1],[120;80]];
    for img_num = 0:200
        for cam_num = 0:8
            disp([img_num, cam_num]);
            try
                load(GTPathManager(city, 'lattice_info', set, segment, img_num, cam_num, 1));
            catch
                continue
            end
            if(length(lats) > 0)
                I = imread(GTPathManager(city, 'highres_street', set, segment, img_num, cam_num, 1));
            end
            temp_sv = lattice_matching(GTPathManager(city, 'highres_street', set, segment, img_num, cam_num, 1),0);
            sv_median_patch = [sv_median_patch, temp_sv];
            for lat_num = 1 : length(lats)
                figure(1), clf, imshow(I);
                fillLatticeFromCell(lats{lat_num}, [0 0 1], zeros(size(flags{lat_num})), flags{lat_num}, 3, 5);
                lat = lats{lat_num};
                flag = flags{lat_num};
                while(sum(lat{1,1}) > sum(lat{1,end}) || sum(lat{1,1}) > sum(lat{end,end}) || sum(lat{1,1}) > sum(lat{end,1}))
                    lat = rot90(lat);
                    flag = rot90(flag);
                end
                
                if(lat{1,end}(1) > lat{end,1}(1))
                    lat = flipud(lat);
                    flag = flipud(flag);
                end
                
                while(sum(lat{1,1}) > sum(lat{1,end}) || sum(lat{1,1}) > sum(lat{end,end}) || sum(lat{1,1}) > sum(lat{end,1}))
                    lat = rot90(lat);
                    flag = rot90(flag);
                end
                if ~isValid(lat)
                    continue
                end
                [II, JJ] = find(flag);
                max_I = max(II);
                max_J = max(JJ(II == max_I));
                
                min_I = min(II);
                min_J = min(JJ(II == min_I));
                patches = [];
                patch_cnt = 1;
                for lat_row = 1 : size(flag,1)-1
                    for lat_col = 1 : size(flag,2)-1
                        temp_mat = flag(lat_row : lat_row+1, lat_col : lat_col+1);
                        if(sum(temp_mat(:)) >= 3)
                            try
                                patches(:,:,:,patch_cnt) = build_patch(I, 5*[lat{lat_row, lat_col}, lat{lat_row, lat_col+1}, lat{lat_row+1, lat_col}, lat{lat_row+1, lat_col+1}], warp_pts);
                                patch_cnt = patch_cnt + 1;
                                disp('Success!');
                            catch
                                disp('Failed!');
                            end
                        end
                    end
                end
                if ndims(patches) > 3
                    if length(belonging_img) == 0
                        median_patches(:,:,:,1) = median(patches, 4);
                    else
                        median_patches(:,:,:,end+1) = median(patches, 4);
                    end
                    belonging_img{end+1} = sprintf('%04d_%02d_%02d', img_num, cam_num, lat_num);
                    fprintf('size = %d %d\n',size(median_patches,4), length(belonging_img));
                else
                    continue
                end
                
            end
        end
    end
    
   aerial_patch = build_aerial_patch(city, match_set);
   save nyc_00_00_2
%    res1 = GTFeatureManager(median_patches, 'edge', aerial_patch);
%    res2 = GTFeatureManager(median_patches, 'color', aerial_patch);
%    figure, plot(res1, res2, 'r*');
    for x = 1 : length(median_patches)
        cost(x) = CalcMotifCost(median_patches(:,:,:,x), aerial_patch);
    end
    
    scores = otherMethods(sv_median_patch, match_set, city, aerial_patch);
   keyboard
   
   
end 

function scores = otherMethods(sv_median_patch, match_set, city,aerial)
%% Read in aerial stuff
I1 = imread(GTPathManager(city, 'aerial_facade', 0,0,match_set,0,1));
load(GTPathManager(city, 'aerial_facade_lat_info', 0, 0, match_set, 0, 1));
aerial_lats = lats{1};
aerial_flags = flags{1};

%% SIFT (only comment if running bice)
[vpts1, f1] = vl_sift(rgb2gray(I1));

%% ROOT SIFT (comment if not using root sift)
% f1 = f1./repmat(max(f1,2), [size(f1,1), 1]);
% f1 = sqrt(f1);
% 
% %% S4 (comment if not using s4)
% f1 = selfsim(rgb2gray(I1), vpts1);
% 
% 
% %% Bice (comment if not using bice)
% imwrite(aerial,'aerial.png');
% system(sprintf('bice.exe -ma -i aerial.png -o aerial.txt'));
% F = fopen('aerial.txt');
% temp = textscan(F, '%d %d\n');
% num_pts = temp{1};
% dimen = temp{2};
% for i = 1 : num_pts
%     textscan(F, '%f %f %f %f %f %f');
%     for j = 1 : dimen
%         temp = textscan(F, '%d');
%         f1(j,i) = temp{1};
%     end
% end
% fclose(F);



%% Do SV stuff
for i = 1 : length(sv_median_patch)
    for j = 1 : length(sv_median_patch(i).lat_info)
        I2 = (imread(sv_median_patch(i).path));
%         I2 = imresize(I2, .2);
        dom_lats{1} = sv_median_patch(i).lat_info(j).unwarped_lattice;
%         I2 = imcrop(I2, [1 1 max([dom_lats{end}{1,1}(1), dom_lats{end}{1,1}(2) dom_lats{end}{1,end}(1), dom_lats{end}{1,end}(2) dom_lats{end}{end,1}(1), dom_lats{end}{end,1}(2) dom_lats{end}{end,end}(1), dom_lats{end}{end,end}(2)]) max([dom_lats{end}{1,1}(1), dom_lats{end}{1,1}(2) dom_lats{end}{1,end}(1), dom_lats{end}{1,end}(2) dom_lats{end}{end,1}(1), dom_lats{end}{end,1}(2) dom_lats{end}{end,end}(1), dom_lats{end}{end,end}(2)]) ]);
        I2_gray = rgb2gray(I2);
        I2_gray = imwarp(I2_gray, sv_median_patch(i).lat_info(j).tform);
%         I2 = imwarp(I2, sv_median_patch(i).lat_info(j).tform);
        
       %% SIFT
        [vpts2, f2] = vl_sift(I2_gray);
        bounds = [dom_lats{1}{1,1}(1), dom_lats{1}{1,1}(2);
            dom_lats{1}{1,end}(1), dom_lats{1}{1,end}(2);
            dom_lats{1}{end,1}(1), dom_lats{1}{end,1}(2);
            dom_lats{1}{end,end}(1), dom_lats{1}{end,end}(2);
            ];
        in = inpolygon(vpts2(:,2), vpts2(:,1), bounds(:,2), bounds(:,1));
        vpts2  = vpts2(in,:);
         
        %% Root SIFT
%         f2 = f2./repmat(max(f2,2), [size(f2,1), 1]);
%         f2 = sqrt(f2);
%         %% S4
%         f2 = selfsim(rgb2gray(I1), vpts2);
%         
%         %% Bice
%         imwrite(sv_median_patch.patch(i), 'street.png');
%         system(sprintf('bice.exe -ma -i street.png -o street.txt'));
%         F = fopen('street.txt');
%         temp = textscan(F, '%d %d\n');
%         num_pts = temp{1};
%         dimen = temp{2};
%         for i = 1 : num_pts
%             textscan(F, '%f %f %f %f %f %f');
%             for j = 1 : dimen
%                 temp = textscan(F, '%d ');
%                 f2(j,i) = temp{1};
%             end
%         end
%         fclose(F);
        
        
        %% Matching
       indexPairs = matchFeatures(f1, f2,'MatchThreshold', 10,'MaxRatio', .8 ) ;
       matchedPoints1 = f1(indexPairs(:, 1));
       matchedPoints2 = f2(indexPairs(:, 2));
       scoreSet(i,j) = mean(sqrt(sum(((matchedPoints1 - matchedPoints2).^2),2)));
    end
    scores(i) = min(scoreSet(i,:));
end

end

function valid = isValid(lat)

    vert_vec = 5*lat{1,end} - 5*lat{1,1};
    horz_vec = 5*lat{end,1} - 5*lat{1,1};
    vert_angle = atand(vert_vec(2)/vert_vec(1))
    horz_angle = atand(horz_vec(2)/horz_vec(1))
    lat{1,1}(2)
    valid = (abs((abs(vert_angle) - 90)) < 10 && abs(horz_angle) < 35) && lat{1,1}(2) < 800/5
    
    

end

function vector = getCorrectVectors(city, match_set, belonging_img)

vector = [];
for i = 1 : length(belonging_img)
    temp = textscan(belonging_img{i}, '%04d_%02d_%02d');
    img_num = temp{1};
    cam_num = temp{2};
    if exist(GTPathManager(city, 'match_set_img', 0,0, img_num, cam_num, 1, match_set)) || exist(GTPathManager(city, 'match_set_img', 0,0, img_num, cam_num, 1,10));
        vector = [vector, i];
    end
end

end

function patch = build_aerial_patch(city, match_set)

    warp_pts = [[1;1],  [1;80], [120;1],[120;80]];
    I = imread(GTPathManager(city, 'aerial_facade', 0,0,match_set,0,1));
    load(GTPathManager(city, 'aerial_facade_lat_info', 0, 0, match_set, 0, 1));
    for lat_num = 5%length(lats)
                figure(1), clf, imshow(I);
                fillLatticeFromCell(lats{lat_num}, [0 0 1], zeros(size(flags{lat_num})), flags{lat_num}, 3, 1);
                lat = lats{lat_num};
                flag = flags{lat_num};
                
                while(sum(lat{1,1}) > sum(lat{1,end}) || sum(lat{1,1}) > sum(lat{end,end}) || sum(lat{1,1}) > sum(lat{end,1}))
                    lat = rot90(lat);
                    flag = rot90(flag);
                end
                
                if(lat{1,end}(1) > lat{end,1})
                    lat = flipud(lat);
                    flag = flipud(flag);
                end
                
                while(sum(lat{1,1}) > sum(lat{1,end}) || sum(lat{1,1}) > sum(lat{end,end}) || sum(lat{1,1}) > sum(lat{end,1}))
                    lat = rot90(lat);
                    flag = rot90(flag);
                end
                
                patches = [];
                patch_cnt = 1;
                size(flag)
                for lat_row = 1 : size(flag,1)-1
                    for lat_col = 1 : size(flag,2)-1
                        temp_mat = flag(lat_row : lat_row+1, lat_col : lat_col+1);
                        if(sum(temp_mat(:)) >= 3)
                            try
                                patches(:,:,:,patch_cnt) = build_patch(I, [lat{lat_row, lat_col}, lat{lat_row, lat_col+1}, lat{lat_row+1, lat_col}, lat{lat_row+1, lat_col+1}], warp_pts);
                                patch_cnt = patch_cnt + 1;
                                disp('Success!');
                            catch
                                disp('Failed!');
                            end
                        end
                    end
                end
                
                
    end
    patch = median(patches, 4);
end

function patch = build_patch(I, in_pts, out_pts)
    patch = zeros(80, 120,3);
    tform{end+1} = estimateGeometricTransform(out_pts', in_pts', 'projective');
    in_map_cols = 1 : 120;
    in_map_cols = repmat(in_map_cols, [80 1]);
    in_map_rows = 1 : 80;
    in_map_rows = repmat(in_map_rows', [1 120]);
    
    out_map_rows = zeros(size(in_map_rows));
    out_map_cols = zeros(size(in_map_cols));

    for i = 1 : size(out_map_rows, 1)
        for j = 1 : size(out_map_rows, 2)
            temp_pt = [in_map_cols(i,j) in_map_rows(i,j) 1]*tform{end}.T;
            temp_pt = temp_pt/temp_pt(3);
            out_map_rows(i,j) = round(temp_pt(1));
            out_map_cols(i,j) = round(temp_pt(2));
            patch(i,j,:) = I(round(temp_pt(2)), round(temp_pt(1)),:);
            
        end
    end

end

function [matches, LL] = getLLMatches(image_num, pt)

    camera_poses = GTPathManager('nyc','camera_poses',0,0,0,0,1);
    tCPoses = xml2struct(camera_poses);
    curr_dir = cd;
    path_params = GTPathManager('nyc','street_params_dir', 0, 0, 0, 0, 0);
    cd(GTPathManager('a','MATLABPath',0,0,0,0,0));
    [LL, matches] = imcoords2LL(pt(1), pt(2), image_num, tCPoses, 0, path_params);
    cd(curr_dir);

end


function pt_out = flippoint(pt, rect)

    pt_out = [rect(1) + rect(3) - pt(1), rect(2) + rect(3) - pt(2)];

end

function pt = EstimateBottomLocation(flag, lattice)
    
    lattice = lattice(flag == 1);
    lattice_new = zeros(length(lattice),2);
    for i = 1 : length(lattice)
        a = lattice{i}(1);
        b = lattice{i}(2);
        lattice_new(i, :) = [a b];
    end
    lattice = lattice_new;
    clear lattice_new
    a = max(lattice(:,1));
    b = mean(lattice(:,2));
    pt = [a b];

end
    

