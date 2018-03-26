close all


city = 'sf';
addpath('./export_fig/');
set = 0;
segment = 0;

for img_num = 182 : 1000
    for cam_num = 0  : 7
        disp([img_num, cam_num]);
        load(GTPathManager(city, 'lattice_info', set, segment, img_num, cam_num, 1));
        if(length(lats) > 0)
            I = imread(GTPathManager(city, 'highres_street', set, segment, img_num, cam_num, 1));
        end
        for lat_num = 1 : length(lats)
            figure(1), clf, imshow(I), hold on;
            fillLatticeFromCell(lats{lat_num}, [0 0 1], zeros(size(flags{lat_num})), flags{lat_num}, 8, 5);
            
            %% Check for input
            lattice_group = input('Enter match grouping (0 if invalid)\n');
            
            %% Output based on input
            if lattice_group > 0
                export_fig(GTPathManager(city, 'facade_match_sets_street_image', set, segment, img_num, cam_num, 1, lattice_group));
                lat = lats{lat_num};
                flag = flags{lat_num};
                save(GTPathManager(city, 'facade_match_sets_street_lats', set, segment, img_num, cam_num, 1, lattice_group), 'lat', 'flag');
            end
            
        end
        
        
    end
end