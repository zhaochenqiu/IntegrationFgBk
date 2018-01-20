%clear all
close all
clc


global g_judge

path = 'D:\dataset\dataset\baseline\highway\input'; %input('Path: ');  
format = 'jpg';                                     %input('Format: ');

g_judge = 1;

 data = loadData(path,format);

detection(data);