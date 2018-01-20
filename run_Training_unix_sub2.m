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

path_img='/data/dataset/FBMS_Trainingset/Trainingset/cars7'
path_save='/data/dataset/homography_multi/FBMS_Trainingset/cars7'
detection_MultiHomo();

path_img='/data/dataset/FBMS_Trainingset/Trainingset/cars8'
path_save='/data/dataset/homography_multi/FBMS_Trainingset/cars8'
detection_MultiHomo();

path_img='/data/dataset/FBMS_Trainingset/Trainingset/cars9'
path_save='/data/dataset/homography_multi/FBMS_Trainingset/cars9'
detection_MultiHomo();

path_img='/data/dataset/FBMS_Trainingset/Trainingset/cats02'
path_save='/data/dataset/homography_multi/FBMS_Trainingset/cats02'
detection_MultiHomo();

path_img='/data/dataset/FBMS_Trainingset/Trainingset/cats04'
path_save='/data/dataset/homography_multi/FBMS_Trainingset/cats04'
detection_MultiHomo();

exit
