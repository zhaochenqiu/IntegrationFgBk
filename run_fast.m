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
run('config/config_video_camel01');


% the parameter of algorithms is configured in config_para
run('config/config_para_test');

% start the function
%detection_MultiHomo();





path_img    = '/data/dataset/FBMS_Testset/Testset/camel01';
path_img    = './small/';
path_save   = '/data/dataset/homography_multi_test/camel01';

format_img  = 'png';



detection_MultiHomo_fast();








