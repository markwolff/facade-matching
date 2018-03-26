function im_coords = UTMoffset2imcoords(city,in_x, in_y, in_z, aerial_image_num, tCPoses, display_result)

% in_lat = 40.725891;
% in_lng = -74.008384;
% in_x = -29.4404;
% in_y = 276.0519;
% in_z = -28.8673;
% aerial_image_num = 27;

%% Open/Read camera parameter files
sprintf('%s%s',GTPathManager(city,'street_params_dir', 0,0,0,0,0),'metadata.txt')
meta_file = fopen(sprintf('%s%s',GTPathManager(city,'street_params_dir', 0,0,0,0,0),'metadata.txt'));
%sv_ip_file = fopen('../recur/data/nyc_0/image_pose.txt');
% keyboard
metadata = textscan(meta_file, '%s %s %s %s');

bbox_min_lat = str2double(metadata{2}{1});
bbox_max_lat = str2double(metadata{2}{2});
bbox_min_lng = str2double(metadata{2}{3});
bbox_max_lng = str2double(metadata{2}{4});

origin = [str2double(metadata{3}{7}), str2double(metadata{4}{7})];
z1 = utmzone(origin) % 18T for NYC

%% Obtain camera and UTM offset origins
[ellipsoid,estr] = utmgeoid(z1);
utmstruct = defaultm('utm'); 
utmstruct.zone = z1; 
utmstruct.geoid = ellipsoid; 
utmstruct = defaultm(utmstruct);
[origin_utm(1), origin_utm(2), origin_utm(3)] = mfwdtran(utmstruct, origin(1), origin(2));
[camera_utm(1), camera_utm(2), camera_utm(3)] = mfwdtran(utmstruct, str2double(tCPoses.ImageMetaData.ImagePoses.Pose{aerial_image_num+1}.Attributes.Latitude), str2double(tCPoses.ImageMetaData.ImagePoses.Pose{aerial_image_num+1}.Attributes.Longitude));

headerSpec = '%s %s %s %s %s %s %s %s %s %s %s %s';
formatSpec = '%d %d %d %f %f %f %f %f %f %f %f';

%sv_ip_header = textscan(sv_ip_file, headerSpec, 1);
%curr_sv_ip_block = textscan(sv_ip_file, formatSpec, 1);%1936*9);

camera_utm(3) = str2double(tCPoses.ImageMetaData.ImagePoses.Pose{aerial_image_num+1}.Attributes.Altitude);

%% Translation matrix
C_y = -1*(origin_utm(2) - camera_utm(2));
C_x = -1*(origin_utm(1) - camera_utm(1));
C_z = -1*(28.8673 - camera_utm(3));

C = [1 0 0 -C_x;
     0 1 0 -C_y;
     0 0 1 -C_z;
     0 0 0 1
    ];

%% Rotation matrix
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

%% Projective matrix
P = [f 0 o_x 0;
     0 f o_y 0;
     0 0 1 0
    ];
    

A = P*R*C*[in_x;in_y;in_z;1];
im_coords = A/A(3);
if display_result == 1 && im_coords(2) > 0 && im_coords(2) <= 5616 && im_coords(1) > 0 && im_coords(1) <= 3744
    close all
    I = imread(sprintf('../recur/data/%s/%s',city, tCPoses.ImageMetaData.ImagePoses.Pose{aerial_image_num+1}.Attributes.Filename));
    figure, imshow(I), hold on, plot(im_coords(2),im_coords(1), 'r*')
    
end
fclose(meta_file);
%fclose(sv_ip_file);

end