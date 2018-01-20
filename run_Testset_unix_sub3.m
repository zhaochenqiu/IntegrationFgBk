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

path_img='/data/dataset/FBMS_Testset/Testset/farm01'
path_save='/data/dataset/homography_multi/FBMS_Testset/farm01'
detection_MultiHomo();

path_img='/data/dataset/FBMS_Testset/Testset/giraffes01'
path_save='/data/dataset/homography_multi/FBMS_Testset/giraffes01'
detection_MultiHomo();

path_img='/data/dataset/FBMS_Testset/Testset/goats01'
path_save='/data/dataset/homography_multi/FBMS_Testset/goats01'
detection_MultiHomo();

path_img='/data/dataset/FBMS_Testset/Testset/horses02'
path_save='/data/dataset/homography_multi/FBMS_Testset/horses02'
detection_MultiHomo();

path_img='/data/dataset/FBMS_Testset/Testset/horses04'
path_save='/data/dataset/homography_multi/FBMS_Testset/horses04'
detection_MultiHomo();

exit
