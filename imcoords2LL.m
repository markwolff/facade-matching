function [A, matches] = imcoords2LL(in_x, in_y, aerial_image_num, tCPoses, display_result,SVPath)

% in_lat = 40.725891;
% in_lng = -74.008384;
% in_x = -29.4404;
% in_y = 276.0519;
% in_z = -28.8673;
% aerial_image_num = 27;

meta_file = fopen(sprintf('%smetadata.txt', SVPath));
sv_ip_file = fopen(sprintf('%simage_pose.txt',SVPath));

metadata = textscan(meta_file, '%s %s %s %s');
bbox_min_lat = str2double(metadata{2}{1});
bbox_max_lat = str2double(metadata{2}{2});
bbox_min_lng = str2double(metadata{2}{3});
bbox_max_lng = str2double(metadata{2}{4});

origin = [str2double(metadata{3}{7}), str2double(metadata{4}{7})];
z1 = utmzone(origin); % 18T for NYC

[ellipsoid,estr] = utmgeoid(z1);
utmstruct = defaultm('utm'); 
utmstruct.zone = z1; 
utmstruct.geoid = ellipsoid; 
utmstruct = defaultm(utmstruct);
[origin_utm(1), origin_utm(2), origin_utm(3)] = mfwdtran(utmstruct, origin(1), origin(2));
[camera_utm(1), camera_utm(2), camera_utm(3)] = mfwdtran(utmstruct, str2double(tCPoses.ImageMetaData.ImagePoses.Pose{aerial_image_num+1}.Attributes.Latitude), str2double(tCPoses.ImageMetaData.ImagePoses.Pose{aerial_image_num+1}.Attributes.Longitude));


bbox_min_x = str2double(metadata{2}{8});
bbox_max_x = str2double(metadata{2}{9});
bbox_min_y = str2double(metadata{2}{10});
bbox_max_y = str2double(metadata{2}{11});

lat_per_meter = (bbox_max_lat - bbox_min_lat) / (bbox_max_y - bbox_min_y);
lng_per_meter = (bbox_max_lng - bbox_min_lng) / (bbox_max_x - bbox_min_x);

headerSpec = '%s %s %s %s %s %s %s %s %s %s %s %s';
formatSpec = '%d %d %d %f %f %f %f %f %f %f %f';

sv_ip_header = textscan(sv_ip_file, headerSpec, 1);
curr_sv_ip_block = textscan(sv_ip_file, formatSpec, 1936*9);%1936*9);

camera_utm(3) = str2double(tCPoses.ImageMetaData.ImagePoses.Pose{aerial_image_num+1}.Attributes.Altitude);

C_y = -1*(origin_utm(2) - camera_utm(2));
C_x = -1*(origin_utm(1) - camera_utm(1));
C_z = -1*(28.8673  - camera_utm(3));

C = [1 0 0 C_x;
     0 1 0 C_y;
     0 0 1 C_z;
     0 0 0 1
    ];
X_rot = ...
    [str2double(tCPoses.ImageMetaData.ImagePoses.Pose{aerial_image_num+1}.Attributes.CamUpX),
     str2double(tCPoses.ImageMetaData.ImagePoses.Pose{aerial_image_num+1}.Attributes.CamUpY),
     str2double(tCPoses.ImageMetaData.ImagePoses.Pose{aerial_image_num+1}.Attributes.CamUpZ)
    ];

Z_rot = ...
    [str2double(tCPoses.ImageMetaData.ImagePoses.Pose{aerial_image_num+1}.Attributes.ViewDirX),
     str2double(tCPoses.ImageMetaData.ImagePoses.Pose{aerial_image_num+1}.Attributes.ViewDirY),
     str2double(tCPoses.ImageMetaData.ImagePoses.Pose{aerial_image_num+1}.Attributes.ViewDirZ)
    ];

Y_rot = cross(X_rot, Z_rot);

R = [X_rot', 0;
     Y_rot', 0;
     Z_rot', 0;
     0 0 0 1
    ];

cal_num = str2double(tCPoses.ImageMetaData.ImagePoses.Pose{aerial_image_num+1}.Attributes.CalNum);
o_x = str2double(tCPoses.ImageMetaData.CameraCalibration.Camera{cal_num+1}.Attributes.CY);
o_y = str2double(tCPoses.ImageMetaData.CameraCalibration.Camera{cal_num+1}.Attributes.CX);

f = str2double(tCPoses.ImageMetaData.CameraCalibration.Camera{cal_num+1}.Attributes.FocalLengthPixels);

P = ...
    [1/f 0 -o_x/f 0;
     0 1/f -o_y/f 0;
     0 0 1 0;
     0 0 0 1
    ];
matrix_total = C*R'*P;
D_o = (curr_sv_ip_block{7}(1)-matrix_total(3,4))/(matrix_total(3,1:3)*[in_x; in_y; 1]);
A = (C)*R'*P*([D_o*in_x; D_o*in_y; D_o; 1]);
matches = [];
if display_result == 0
    return
end
for i = 1 : 366
    
    curr_sv_ip_block = textscan(sv_ip_file, formatSpec, 1936*9);%1936*9);
    curr_loc(1) = curr_sv_ip_block{5}(1);
    curr_loc(2) = curr_sv_ip_block{6}(1);
    curr_loc(3) = curr_sv_ip_block{7}(1);
    disp( sqrt(sum((curr_loc(:) - A(1:3)).^2)));
    if sqrt(sum((curr_loc(:) - A(1:3)).^2)) < 99999999
        matches{end+1}.img_num = i
        matches{end}.coords = curr_loc;
        matches{end}.dist = sqrt(sum((curr_loc(:) - A(1:3)).^2));
    end
end

end
