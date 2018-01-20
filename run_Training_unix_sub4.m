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


path_img='/data/dataset/FBMS_Trainingset/Trainingset/horses06'
path_save='/data/dataset/homography_multi/FBMS_Trainingset/horses06'
detection_MultiHomo();

path_img='/data/dataset/FBMS_Trainingset/Trainingset/lion02'
path_save='/data/dataset/homography_multi/FBMS_Trainingset/lion02'
detection_MultiHomo();

path_img='/data/dataset/FBMS_Trainingset/Trainingset/marple1'
path_save='/data/dataset/homography_multi/FBMS_Trainingset/marple1'
detection_MultiHomo();

path_img='/data/dataset/FBMS_Trainingset/Trainingset/marple10'
path_save='/data/dataset/homography_multi/FBMS_Trainingset/marple10'
detection_MultiHomo();

path_img='/data/dataset/FBMS_Trainingset/Trainingset/marple11'
path_save='/data/dataset/homography_multi/FBMS_Trainingset/marple11'
detection_MultiHomo();
exit
