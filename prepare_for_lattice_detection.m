close all
clear all
for set = 0 : 20
    for segment = 0:5

%         set = 14;
%         segment = 0;

        %% Save Match Images


        original_dir = GTPathManager('nyc','original_street',set,segment,0,0,0);
        highres_save_dir = GTPathManager('nyc','highres_street',set,segment,0,0,0);
        save_dir =  GTPathManager('nyc','blurred_street',set,segment,0,0,0);

        lattice_proposals = GTPathManager('nyc','lattice_proposals', set, segment,0,0,0);
        lattice_output = GTPathManager('nyc','lattice_info', set, segment,0,0,0);

        filelist = dir(sprintf('%s*.jpg',save_dir));
        filelist = {filelist.name};

%         if input('Press 1 to start fresh directory\n')
        if 1 == 1
            try
                for i = 0 : 9999
                    for j = 0 : 7
                        if isempty(strmatch(sprintf('unstitched_%06d_%02d', i, j),filelist))
                            clear temp
                            fprintf('Undistorted image %06d_%02d not found, undistorting now...\n', i, j);
                            temp = undistort_image(imread(sprintf('%sunstitched_%06d_%02d.jpg',original_dir, i, j)),j, 1);
                            temp = uint8(temp);
                            imwrite(temp, sprintf('%sunstitched_%06d_%02d.jpg', highres_save_dir,i, j));
                            temp = imresize(temp, .2);
                            temp = imfilter(temp, fspecial('gaussian', 9, 1.1),'symmetric');
                            imwrite(temp, sprintf('%sunstitched_%06d_%02d.jpg', save_dir,i, j));
                        else
                            fprintf('Undistorted image %06d_%02d found! Copying...\n', i, j);
                            temp = imread(sprintf('%sunstitched_%06d_%02d.jpg',highres_save_dir, i, j));
                            temp = imresize(temp, .2);
                            temp = imfilter(temp, fspecial('gaussian', 9, 1.1), 'symmetric');
                            imwrite(temp,  sprintf('%sunstitched_%06d_%02d.jpg', save_dir, i, j));
                        end
                    end
                end
            catch
                disp('Error or finished...');
            end
        end
    end
end
return
%% Get Lattices
cd ../TransSymBased_ACCV10_Park64bJCbu/
BatchAll(lattice_proposals, lattice_output, save_dir);
