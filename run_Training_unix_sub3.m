% Author: Q
% Date: 2016/04/02
% Description: NULL

clear all
close all
clc

% the parameter will changed in this file
global path_img path_save format_img;


% the tools used in algorithms are configured in the config_tool.m
run('config/config_tool');

% the parameter is configured in the config_video.m
% run('config/config_video_tennis');
run('config/config_video_people05');


% the parameter of algorithms is configured in config_para
run('config/config_para');

% start the function
%detection_MultiHomo();


path_img='/data/dataset/FBMS_Trainingset/Trainingset/cats05'
path_save='/data/dataset/homography_multi/FBMS_Trainingset/cats05'
detection_MultiHomo();

path_img='/data/dataset/FBMS_Trainingset/Trainingset/cats07'
path_save='/data/dataset/homography_multi/FBMS_Trainingset/cats07'
detection_MultiHomo();

path_img='/data/dataset/FBMS_Trainingset/Trainingset/ducks01'
path_save='/data/dataset/homography_multi/FBMS_Trainingset/ducks01'
detection_MultiHomo();

path_img='/data/dataset/FBMS_Trainingset/Trainingset/horses01'
path_save='/data/dataset/homography_multi/FBMS_Trainingset/horses01'
detection_MultiHomo();

path_img='/data/dataset/FBMS_Trainingset/Trainingset/horses03'
path_save='/data/dataset/homography_multi/FBMS_Trainingset/horses03'
detection_MultiHomo();

exit
