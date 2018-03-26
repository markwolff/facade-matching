close all
clear all

% in_x = -29.4404;
% in_y = 276.0519;
% in_z = -28.8673;

% in_x = 155.513959698139;
% in_y = 673.152471813917;
% in_z = -23.265788755562;
% 
% in_x = 160.513959698139;
% in_y = 683.152471813917;
% in_z = -25.265788755562;
city = 'sf';
camera_poses = [GTPathManager(city,'original_aerial', 0,0,0,0,0), 'camera_poses.xml'];
% aerial_image_num  = 636;
tCPoses = xml2struct(camera_poses);
matches = [];
%UTMoffset2imcoords(-30.511,483.453,-29.5418,41,tCPoses,1);
% 
% for i = 7 : 7
%     disp(i)
%     im_coords = UTMoffset2imcoords(in_x, in_y, in_z, i, tCPoses, 1);
%     if im_coords(2) > 0 && im_coords(2) <= 5616 && im_coords(1) > 0 && im_coords(1) <= 3744
%         temp.img_num = i;
%         temp.img_coords = im_coords;
%         matches = [matches; temp];
%     end
% end

%return
% Open/Read camera parameter files
sv_ip_file = fopen(sprintf('S:/cpacArch/shared/data/UrbanScene/data/street_view/%s/release/%s_0/image_pose.txt', city, city));

headerSpec = '%s %s %s %s %s %s %s %s %s %s %s %s';
formatSpec = '%d %d %d %f %f %f %f %f %f %f %f';

sv_ip_header = textscan(sv_ip_file, headerSpec, 1);
for i = 1 : 164
    curr_sv_ip_block = textscan(sv_ip_file, formatSpec, 1936*9);%1936*9);
end
% aerial_image_num = 636;
% I = imread(sprintf('../recur/data/nyc/%s', tCPoses.ImageMetaData.ImagePoses.Pose{aerial_image_num+1}.Attributes.Filename));
% figure, imshow(rot90(rot90(I)));
% hold on
i = 0;
in_x = curr_sv_ip_block{5}(1)
in_y = curr_sv_ip_block{6}(1)
in_z = curr_sv_ip_block{7}(1)
match_set = 20;
for i = 4 : 9999
    im_coords = UTMoffset2imcoords(city,in_x, in_y, in_z, i, tCPoses, 0)
    if im_coords(2) > 0 && im_coords(2) <= 5616 && im_coords(1) > 0 && im_coords(1) <= 3744 && ((str2num(tCPoses.ImageMetaData.ImagePoses.Pose{i}.Attributes.ViewDirX)) <= 999999)
        clear I
        I = imread(GTPathManager(city,'original_aerial', 0,0,i,0,1));
        figure(1), imshow(rot90(rot90(I)));
        tCPoses.ImageMetaData.ImagePoses.Pose{i}.Attributes
        hold on
        plot(im_coords(2),im_coords(1), 'r*')
        disp(i)
        hold off
        if input('Is Valid?')
            figure(1), AA = imcrop(rot90(rot90(I)));
            imwrite(AA, sprintf('C:/Users/mrw5329/Desktop/%s_%d.png', city, match_set));
            return
        end
    end
end
return
i = 626;
I = imread(GTPathManager(city,'original_aerial', 0,0,i,0,1));
figure(1), imshow(((I)));
hold on
while(ftell(sv_ip_file) ~= -1)
    in_x = curr_sv_ip_block{5}(1);
    in_y = curr_sv_ip_block{6}(1);
    in_z = curr_sv_ip_block{7}(1);
    
    im_coords = UTMoffset2imcoords(in_x, in_y, in_z, i, tCPoses, 0);
    if im_coords(2) > 0 && im_coords(2) <= 5616 && im_coords(1) > 0 && im_coords(1) <= 3744
        temp.img_num = i;
        temp.img_coords = im_coords;
        matches = [matches; temp];
        pause(.01)
        plot(im_coords(2),im_coords(1), 'r*')
    end
%     i = i + 1;
%     if i == 60
%         keyboard
%     end
    curr_sv_ip_block = textscan(sv_ip_file, formatSpec, 1936*9);%1936*9);
end
