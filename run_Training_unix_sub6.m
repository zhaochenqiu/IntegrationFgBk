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


path_img='/data/dataset/FBMS_Trainingset/Trainingset/people04'
path_save='/data/dataset/homography_multi/FBMS_Trainingset/people04'
detection_MultiHomo();

path_img='/data/dataset/FBMS_Trainingset/Trainingset/people05'
path_save='/data/dataset/homography_multi/FBMS_Trainingset/people05'
detection_MultiHomo();

path_img='/data/dataset/FBMS_Trainingset/Trainingset/rabbits01'
path_save='/data/dataset/homography_multi/FBMS_Trainingset/rabbits01'
detection_MultiHomo();

path_img='/data/dataset/FBMS_Trainingset/Trainingset/rabbits05'
path_save='/data/dataset/homography_multi/FBMS_Trainingset/rabbits05'
detection_MultiHomo();
exit
