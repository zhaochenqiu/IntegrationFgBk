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


path_img='/data/dataset/FBMS_Testset/Testset/marple6'
path_save='/data/dataset/homography_multi/FBMS_Testset/marple6'
detection_MultiHomo();

path_img='/data/dataset/FBMS_Testset/Testset/marple7'
path_save='/data/dataset/homography_multi/FBMS_Testset/marple7'
detection_MultiHomo();

path_img='/data/dataset/FBMS_Testset/Testset/marple9'
path_save='/data/dataset/homography_multi/FBMS_Testset/marple9'
detection_MultiHomo();

path_img='/data/dataset/FBMS_Testset/Testset/people03'
path_save='/data/dataset/homography_multi/FBMS_Testset/people03'
detection_MultiHomo();

path_img='/data/dataset/FBMS_Testset/Testset/people1'
path_save='/data/dataset/homography_multi/FBMS_Testset/people1'
detection_MultiHomo();

exit
