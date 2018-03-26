close all
clear all

city = 'nyc';
addpath('TransSymBased_ACCV10_Park64bJCbu');
currdir = cd;
for set = 0 : 5
    for segment = 0 : 5
        cd(currdir);
        original_dir = GTPathManager(city,'original_street',set,segment,0,0,0);
        highres_save_dir = GTPathManager(city,'highres_street',set,segment,0,0,0);
        save_dir =  GTPathManager(city,'blurred_street',set,segment,0,0,0);

        lattice_proposals = GTPathManager(city,'lattice_proposals', set, segment,0,0,0);
        lattice_output = GTPathManager(city,'lattice_info', set, segment,0,0,0);
        cd('TransSymBased_ACCV10_Park64bJCbu');
        if set == 0 && segment == 0
            offset = 1100;
        else
            offset = 1;
        end
        BatchAll(lattice_proposals, lattice_output, save_dir,offset);
    end
end