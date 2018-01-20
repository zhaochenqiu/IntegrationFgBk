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

path_img='/data/dataset/FBMS_Testset/Testset/horses05'
path_save='/data/dataset/homography_multi/FBMS_Testset/horses05'
detection_MultiHomo();

path_img='/data/dataset/FBMS_Testset/Testset/lion01'
path_save='/data/dataset/homography_multi/FBMS_Testset/lion01'
detection_MultiHomo();

path_img='/data/dataset/FBMS_Testset/Testset/marple12'
path_save='/data/dataset/homography_multi/FBMS_Testset/marple12'
detection_MultiHomo();

path_img='/data/dataset/FBMS_Testset/Testset/marple2'
path_save='/data/dataset/homography_multi/FBMS_Testset/marple2'
detection_MultiHomo();

path_img='/data/dataset/FBMS_Testset/Testset/marple4'
path_save='/data/dataset/homography_multi/FBMS_Testset/marple4'
detection_MultiHomo();

exit
