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

path_img='/data/dataset/FBMS_Testset/Testset/people2'
path_save='/data/dataset/homography_multi/FBMS_Testset/people2'
detection_MultiHomo();

path_img='/data/dataset/FBMS_Testset/Testset/rabbits02'
path_save='/data/dataset/homography_multi/FBMS_Testset/rabbits02'
detection_MultiHomo();

path_img='/data/dataset/FBMS_Testset/Testset/rabbits03'
path_save='/data/dataset/homography_multi/FBMS_Testset/rabbits03'
detection_MultiHomo();

path_img='/data/dataset/FBMS_Testset/Testset/rabbits04'
path_save='/data/dataset/homography_multi/FBMS_Testset/rabbits04'
detection_MultiHomo();

path_img='/data/dataset/FBMS_Testset/Testset/tennis'
path_save='/data/dataset/homography_multi/FBMS_Testset/tennis'
detection_MultiHomo();
exit
