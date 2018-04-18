close all;
clear;
clc;

imgDataPath = 'C:\MATLABR2016a\bin\myworkspace\Biometrics\assignment2\LG4000_2010\';
imgDataDir  = dir(imgDataPath);             
for i = 1:length(imgDataDir)
    display(imgDataDir(i).name);
    map = containers.Map;%map ID with left or right
    %skip non-folders******************************************************
    if(isequal(imgDataDir(i).name,'.')||... 
       isequal(imgDataDir(i).name,'..')||...
       ~imgDataDir(i).isdir)                
           continue;
    end
    %end skip non-folders**************************************************
     
    %read meta data from txt file******************************************
    txtDir = dir([imgDataPath imgDataDir(i).name '/*.txt']);
    fidin=fopen(txtDir(1).name); % open txt
    ID='';
    LR='';
    while ~feof(fidin) % if reached the end
        tline=fgetl(fidin); % read a line
        str = strsplit(tline);
        if strcmp(char(str(1)),'sequenceid') &&...
                strcmp(char(str(2)),'string') % find ID
            ID = char(str(3)); 
            continue 
        end
        if strcmp(char(str(1)),'eye') &&...
                strcmp(char(str(2)),'string') % find left or right
            LR = char(str(3)); 
            map(ID) = LR;
            continue 
        end
        
    end
    fclose(fidin);
    %end read meta data from txt file**************************************
    
    imgDir = dir([imgDataPath imgDataDir(i).name '/*.tiff']); 
    template = containers.Map;%cell(1,length(imgDir));
    mask = containers.Map;%cell(1,length(imgDir));
    for j =1:length(imgDir)
        display(imgDir(j).name);
        [t,m] = createiristemplate([imgDataPath imgDataDir(i).name '\' imgDir(j).name]);
        imgID = strsplit(imgDir(j).name,'.');
        template(char(imgID(1))) = t;
        mask(char(imgID(1))) = m;
%         template{j}= t;
%         mask{j} = m;
    end
    save([imgDataPath imgDataDir(i).name '.mat'], 'map', 'template', 'mask');
end