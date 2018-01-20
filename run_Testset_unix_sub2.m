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


path_img='/data/dataset/FBMS_Testset/Testset/cats01'
path_save='/data/dataset/homography_multi/FBMS_Testset/cats01'
detection_MultiHomo();

path_img='/data/dataset/FBMS_Testset/Testset/cats03'
path_save='/data/dataset/homography_multi/FBMS_Testset/cats03'
detection_MultiHomo();

path_img='/data/dataset/FBMS_Testset/Testset/cats06'
path_save='/data/dataset/homography_multi/FBMS_Testset/cats06'
detection_MultiHomo();

path_img='/data/dataset/FBMS_Testset/Testset/dogs01'
path_save='/data/dataset/homography_multi/FBMS_Testset/dogs01'
detection_MultiHomo();

path_img='/data/dataset/FBMS_Testset/Testset/dogs02'
path_save='/data/dataset/homography_multi/FBMS_Testset/dogs02'
detection_MultiHomo();
exit
