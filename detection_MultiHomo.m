function [] = detection_MultiHomo();

% rng('default')
rand('seed',0);


% the parameters are used in this file
global path_img path_save format_img;
global frame_begin frame_end;
global g_mdlUpdateFrame;
global g_rateIfUpdate;
global g_numMinSIFT;
global g_fgRate g_bkRate;
% load the video sequences
% [files_img data_img] = loadData_plus(path_img,format_img);
[files_img data_img] = loadData_files(path_img,format_img);
frame_img = max(size(files_img));

% [row_img column_img byte_img frame_img] = size(data_img);

% define the start and end of the video sequences.
frame_end   = frame_img;


% load the maskimg if there is
if_mask_exist = 0;

maskimg = [];
maskindex = [];
if exist([path_img '/maskimg.png']) ~= 0
    if_mask_exist = 1;

    maskimg = double(imread([path_img '/maskimg.png']));
    maskimg = maskimg(:,:,1);
    [re_left re_top re_right re_bottom] = getMaskInfo(maskimg);

    disp('the mask image exists')
end

% load the maskimg
% maskimg = double(imread([path_img '/maskimg.png']));
% maskindex = maskimg(:,:,1) ~= 255;

% initialize the background model
img = double(imread([path_img '/' files_img{frame_begin}]));
% img = imresize(img,0.5);


[row_img_src column_img_src byte_img_src] = size(img);


if if_mask_exist == 1
    img = img(re_top:re_bottom,re_left:re_right,:);
end



[row_img column_img byte_img] = size(img);


[mus sigmas weights] = initializeGMM(img);
model = {mus,sigmas,weights};

bkimg_forbkcues = getBestBkImage(mus,weights);

model_bk = model;


% create the save path
if systemJudge() == 1
    % the system is a linux system
    path_save_fgimg     = [path_save '/fgimg/'];
    path_save_simimg    = [path_save '/simimg/'];
    path_save_showcues  = [path_save '/showcues/'];
    path_save_bkim      = [path_save '/bkim/'];
else
    % the system is a windows system
    path_save_fgimg     = [path_save '\fgimg\'];
    path_save_simimg    = [path_save '\simimg\'];
    path_save_showcues  = [path_save '\showcues\'];
end

% define th parameter for showing the algorithms process 
global g_displayMatrixImage
g_displayMatrixImage = 1
%figure('NumberTitle','off','Name','detection_test_1')


framecnt = 1;
rate_alig = 0;

pixelsnum = row_img*column_img;
pixelsnum = max([pixelsnum 1]);

startmatlabpool(8);

for i = frame_begin:1:frame_end
    % extract the two consecutive frames
%    img_cur     = double(data_img(:,:,:,i));
    filename    = files_img{i};

    img_cur = double(imread([path_img '/' filename]));
%    img_cur = imresize(img_cur,0.5);

    if if_mask_exist == 1
        img_cur = img_cur(re_top:re_bottom,re_left:re_right,:);
    end

    % 获取足够的通用信息
    tic
    [re_convimg_cur re_grayimg_cur re_H re_X_pre re_X_cur re_features_cur re_matches re_index_full] = getComInfo(img_cur,bkimg_forbkcues);
    time1 = toc;


    % extract the foreground cues
    tic
    [fgcues model index]    = getFgCues(re_grayimg_cur,bkimg_forbkcues,model,re_H);
    time2_1 = toc;

    tic
    bkcues                  = getBkCues(re_convimg_cur,re_X_pre, re_X_cur,re_features_cur,re_matches);
    time2_2 = toc;

%    temprate = sum(sum(index))/pixelsnum;
%    rate_alig = rate_alig + temprate;

%    [temprate rate_alig temprate_pos]

    tic
    temprate_pos = getAligRate(re_H,img);
    rate_alig = rate_alig + temprate_pos;
    rate_alig
    time2_3 = toc;


    time2 = time2_1 + time2_2 + time2_3;
    %time2 = toc;

    % extract the background cues
    
    % creat the cues image for integration
    tic
%    index = index|maskindex;

    cuesimg = createCuesImg(fgcues,bkcues,index);
    [pvalue nvalue] = balanceCues_plus(cuesimg);

    nvalue = nvalue*g_bkRate;
    pvalue = pvalue*g_fgRate;
    index = cuesimg > 0;
    cuesimg(index) = pvalue;
    index = cuesimg < 0;
    cuesimg(index) = nvalue;
    time3 = toc;

    % integrate these cues
    tic
    [simimg simset] = inteFgBkCues(img_cur,cuesimg);
    time4 = toc;

    % segment foreground and update background image
    tic
    [bkimg_forbkcues fgimg] = updateBkImg_IFB(img_cur,bkimg_forbkcues,simimg,model,re_H);
    time5 = toc;

    
    % update the background part of model
    tic
    [row_t column_t] = size(bkcues);

    if max([row_t column_t]) < g_numMinSIFT
        simimg = abs(simimg - simimg);
        fgimg = abs(fgimg - fgimg);
        bkimg_forbkcues = re_grayimg_cur;
%        rate_alig = 0;

        disp('error to get SIFT');
    end

    bkimg_md = getBestBkImage(model{1},model{3});

    if rate_alig > g_rateIfUpdate
        model = updateBkMdl_IFB(model,re_grayimg_cur,simimg);
        bkimg_md = getBestBkImage(model{1},model{3});

        index = fgimg == 0;
        bkimg_forbkcues(index) = re_grayimg_cur(index);
        index = ~index;
        bkimg_forbkcues(index) = bkimg_md(index);

        rate_alig = rate_alig - g_rateIfUpdate;
%        rate_alig = 0;
        disp('replace the background part of model');
    end


    time6 = toc;


    tic
    showcues = resizeCuesImg(cuesimg);
    time7 = toc;


    tic
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % save the middle image                                     %
    filename = changeFileFormat(filename,'png');                %

    if if_mask_exist == 1
        [row_t column_t byte_t] = size(fgimg);
        
        tempimg = zeros(row_img_src,column_img_src,byte_t);
        tempimg(re_top:re_bottom,re_left:re_right,:) = fgimg;
        fgimg = tempimg;


        [row_t column_t byte_t] = size(simimg);
        
        tempimg = zeros(row_img_src,column_img_src,byte_t);
        tempimg(re_top:re_bottom,re_left:re_right,:) = simimg;
        simimg = tempimg;


        [row_t column_t byte_t] = size(showcues);
        
        tempimg = zeros(row_img_src,column_img_src,byte_t);
        tempimg(re_top:re_bottom,re_left:re_right,:) = showcues;
        showcues = tempimg;
    end

                                                                %
    saveImage(bkimg_forbkcues, path_save_bkim, filename);       %
    saveImage(fgimg,    path_save_fgimg,    filename);          %
    saveImage(simimg,   path_save_simimg,   filename);          %
    saveImage(showcues, path_save_showcues, filename);          %
                                                                %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    time8 = toc;

    displayMatrixImage(i,2,3,img_cur, showcues, simimg, bkimg_forbkcues, bkimg_md, fgimg )
%    displayMatrixImage(i,2,3,img_cur, bkimg_md, simimg, bkimg_forbkcues, re_grayimg_cur, fgimg )
    [time2_1 time2_2 time2_3]
    tempvec = [time1 time2 time3 time4 time5 time6 time7 time8];
    [tempvec sum(tempvec)]

%    input('pause for frames')
%    input('press any key to continue')
end
closematlabpool;
