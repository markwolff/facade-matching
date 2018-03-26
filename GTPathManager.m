function s = GTPathManager(city, type, set, segment, imId, imId2, isfile, imId3)
    
    s = [];
    visuPath = '';
    origAerialImgPath = 'S:/cpacArch/shared/data/UrbanScene/data/aerial_imagery/';
    customStreetImgPath = 'S:/cpacArch/mrw539/FacadeMatchingProject/';
    origStreetImgPath = 'S:/cpacArch/shared/data/UrbanScene/data/street_view/';
    MATLABPath = 'C:/Users/mrw5329/Documents/MATLAB/';

      
    if strcmp(type, 'original_aerial')
        s = sprintf('%s%s/image%07d.png',origAerialImgPath,city,imId);
        
    elseif strcmp(type, 'MATLABPath')
        s = sprintf('%splaceholder', MATLABPath);
        
    elseif strcmp(type, 'aerial_crops')
        s = 'S:/cpacArch/mrw539/FacadeMatchingProject/match_sets/aerial/aerial_facade/placeholder.abc';
    elseif strcmp(type, 'aerial_facade')
        s = sprintf('%smatch_sets/aerial/%s/%s_%04d.png', customStreetImgPath, type, city, imId);
    elseif strcmp(type, 'aerial_facade_lats')
        s = sprintf('%smatch_sets/aerial/%s/%s_%04d.png', customStreetImgPath, type, city, imId);
    elseif strcmp(type, 'aerial_facade_lat_info')
        s = sprintf('%smatch_sets/aerial/%s/lats_%s_%04d.mat', customStreetImgPath, type, city, imId);
    elseif strcmp(type, 'aerial_facade_lat_proposals')
        s = sprintf('%smatch_sets/aerial/%s/lats_%s_%04d.mat', customStreetImgPath, type, city, imId);
    elseif strcmp(type, 'match_set_img')
        s = sprintf('%smatch_sets/%s/%d/%02d_%02d_%06d_%02d.png', customStreetImgPath, city, imId3,set, segment, imId, imId2);
        
    elseif strcmp(type, 'street_params_dir')
        s = sprintf('%s%s/release/%s_%d/placeholder', origStreetImgPath, city, city, set);
    elseif strcmp(type, 'camera_poses')
        s = sprintf('%s%s/camera_poses.xml',origAerialImgPath, city);
        
    elseif strcmp(type, 'aerial_lattice_info')
        s = sprintf('%s%s/aerial_lattice_info/lats_im%03d_%03d.mat',customStreetImgPath,city,imId, imId2);

    elseif strcmp(type, 'aerial_lattice_crops')
        s = sprintf('%s%s/aerial_lattice_crops/im%03d/im%03d_%03d.png',customStreetImgPath,city,imId,imId, imId2);
        
    elseif strcmp(type, 'aerial_lattice_proposals')
        s = sprintf('%s%s/aerial_lattice_proposals/im%03d/im%03d_%03d.png',customStreetImgPath,city,imId,imId, imId2);
        
    elseif strcmp(type, 'original_street')
        s = sprintf('%s%s/release/%s_%d/segment_%02d/unstitched_%06d_%02d.jpg', origStreetImgPath, city,city,set, segment,imId, imId2);
        
    elseif strcmp(type, 'highres_street')
        s = sprintf('%s%s/%s_%d/segment_%02d/highres_street/unstitched_%06d_%02d.jpg', customStreetImgPath, city,city,set, segment,imId, imId2);
         
    elseif strcmp(type, 'blurred_street')
        s = sprintf('%s%s/%s_%d/segment_%02d/blurred_street/unstitched_%06d_%02d.jpg', customStreetImgPath, city,city,set, segment,imId, imId2);
            
    elseif strcmp(type, 'lattice_proposals')
        s = sprintf('%s%s/%s_%d/segment_%02d/lattice_proposals/unstitched_%06d_%02d.jpg', customStreetImgPath, city,city,set, segment,imId, imId2);
            
    elseif strcmp(type, 'lattice_info')
        s = sprintf('%s%s/%s_%d/segment_%02d/mexFinal/lats_unstitched_%06d_%02d.mat', customStreetImgPath, city,city,set, segment,imId, imId2);
                
    elseif strcmp(type, 'lattice_highres_pictures')
        s = sprintf('%s%s/%s_%d/segment_%02d/lattice_proposals/unstitched_%06d_%02d.jpg', customStreetImgPath, city,city,set, segment,imId, imId2);        

    elseif strcmp(type, 'facade_match_sets_street_image')
        s = sprintf('%smatch_sets/%s/%d/%02d_%02d_%06d_%02d.png', customStreetImgPath, city,imId3,set, segment,imId, imId2);        

    elseif strcmp(type, 'facade_match_sets_street_lats')
        s = sprintf('%smatch_sets/%s/%d/%02d_%02d_%06d_%02d.mat', customStreetImgPath, city,imId3,set, segment,imId, imId2);
        
    elseif strcmp(type, 'facade_match_sets_aerial_image')
        s = sprintf('%smatch_sets/%s/%d/%02d_%02d_aerial.png', customStreetImgPath, city,imId3,set, segment);       

    elseif strcmp(type, 'facade_match_sets_aerial_lats')
        s = sprintf('%smatch_sets/%s/%d/%02d_%02d_aerial.mat', customStreetImgPath, city,imId3,set, segment);  
        
    else
        error('GTPathManager: INVALID DIRECTORY ID (%s)', type);
        return
    end
    
    directory = s(1:find(s=='/',1,'last'));
    if exist(directory,'dir') ~= 7
        mkdir(directory);
    end
    if ~isfile
        s = directory;
    end
    
end