
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 基本的参数                                                %
global frame_begin frame_end;                               %
                                                            %
frame_begin = 1;                                            %
frame_end = -1;                                             %
                                                            %
global g_template;                                          %
g_template = [1 2 1                                         %
			2 8 2                                           %
			1 2 1];                                         %
g_template = g_template/sum(sum(g_template));               %

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 高斯函数的参数                                            %
global num_model;                                           %
num_model = 3;                                              %
                                                            %
global gmm_fgrate gmm_uprate;                               %
gmm_fgrate = 1.6;                                           %
gmm_uprate = 10;                                            %
                                                            %
global update_mus update_sig update_wei;                    %
update_mus = 0.99;                                          %
update_sig = 0.99;                                          %
update_wei = 1.05;                                          %
                                                            %
global g_gmmFgThreshold;                                    %
g_gmmFgThreshold = 0.3;                                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 前景背景聚合的参数                                        %
global g_spBkCuesNum g_spBkCuesFactor;                      %
g_spBkCuesNum = 16;                                          %
g_spBkCuesFactor = 10;                                       %
                                                            %
global g_superMatrix g_superFactor;                         %
g_superMatrix = [16
                32
                64
                128
                256
                512
                1024
                2048];

g_superMatrix = [8
                16
                32
                64
                128
                256
                512
                1024];
g_superMatrix = [16
                32
                64
                128
                256
                512
                1024
                2048];


g_superFactor = 5;


global g_rateScale;
g_rateScale = 5;

global g_fgValue g_bkValue;                                 %
g_fgValue = 255;                                            %
g_bkValue = -255;                                           %

global g_fgRate g_bkRate;
g_fgRate = 1.0;
g_bkRate = 2.0;

% g_bkRate = 2.0;

                                                            %
global g_disRscBkCues g_disRscFgCues;                       %
g_disRscBkCues = 16;                                         %
g_disRscFgCues = 1;                                         %
                                                            %
global g_rangeAligFg g_rangeAligBk;                         %
g_rangeAligFg = 0;                                          %
g_rangeAligBk = 0;                                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 前景分割的参数                                            %
global g_thrFgSeg g_thrBkUpd;                               %
g_thrFgSeg = 0.3;                                           %
g_thrBkUpd = 0.3;                                           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 测试参数                                                  %
global g_rateIfUpdate g_numMinSIFT;
g_rateIfUpdate = 0.005;
g_numMinSIFT = 10;

global g_mdlUpdateFrame;
g_mdlUpdateFrame = 1;                                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
