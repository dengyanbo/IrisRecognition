close all;
clear;
clc;

imgDataPath = 'C:\MATLABR2016a\bin\myworkspace\Biometrics\assignment2\LG2200_2008\';
dataDir = dir([imgDataPath '/*.mat']);
scales = 0;

Gen = [];
Im = [];

for i = 1:length(dataDir)%iterate all .mat files
    load(dataDir(i).name)
    display(dataDir(i).name);
    curIDs = keys(map);
    for x = 1:length(curIDs)%iterate all IDs in one .mat file
        curID = curIDs{x};
        if ~isKey(template,curID)
            continue;
        end
        curTem = template(curID);
        curMask = mask(curID);
        curLR = map(curID);
        for y = (x+1):length(curIDs)%iterate rest IDs in one .mat file
            ID = curIDs{y};
            if ~isKey(template,ID)
                continue;
            end
            if strcmp(map(ID),map(curID)) %left-left or right-right matching
                score = gethammingdistance(curTem, curMask, template(ID), mask(ID), scales);
                Gen = [Gen score];
            end
        end
    end
end
Gen(Gen == 0) = [];
Gen(isnan(Gen)) = [];

%**************************************************************************
for i = 1:length(dataDir)%iterate all .mat files
    load(dataDir(i).name)
    display(dataDir(i).name);
    curIDs = keys(map);
    curID = curIDs{randi(length(curIDs))};
    while ~isKey(template,curID)
        curID = curIDs{randi(length(curIDs))};
    end
%     curIDL = [];
%     curIDR = [];
    if strcmp(map(curID),'Left')
        curIDL = curID;
        while strcmp(map(curID),'Left')
            curID = curIDs{randi(length(curIDs))};
            while ~isKey(template,curID)
                curID = curIDs{randi(length(curIDs))};
            end
        end
        curIDR = curID;
    else
        curIDR = curID;
        while strcmp(map(curID),'Right')
            curID = curIDs{randi(length(curIDs))};
            while ~isKey(template,curID)
                curID = curIDs{randi(length(curIDs))};
            end
        end
        curIDL = curID;
    end
    curTemL = template(curIDL);
    curMaskL = mask(curIDL);

    curTemR = template(curIDR);
    curMaskR = mask(curIDR);
    
    for j = 1:length(dataDir)
        if i==j
            continue;
        end
        load(dataDir(j).name)
        IDs = keys(map);
        ID = IDs{randi(length(IDs))};
        while ~isKey(template,ID)
            ID = IDs{randi(length(IDs))};
        end
%         IDL = [];
%         IDR = [];
        if strcmp(map(ID),'Left')
            IDL = ID;
            while strcmp(map(ID),'Left')
                ID = IDs{randi(length(IDs))};
                while ~isKey(template,ID)
                    ID = IDs{randi(length(IDs))};
                end
            end
            IDR = ID;
        else
            IDR = ID;
            while strcmp(map(ID),'Right')
                ID = IDs{randi(length(IDs))};
                while ~isKey(template,ID)
                    ID = IDs{randi(length(IDs))};
                end
            end
            IDL = ID;
        end
        scoreL = gethammingdistance(curTemL, curMaskL, template(IDL), mask(IDL), scales);
        scoreR = gethammingdistance(curTemR, curMaskR, template(IDR), mask(IDR), scales);
        Im = [Im scoreL scoreR];
    end
end
Im(Im == 0) = [];
Im(isnan(Im)) = [];

figure,
hG = histogram(Gen,'Normalization','probability','faceColor','b','edgecolor','b','BinWidth',0.02);
hold on
hI = histogram(Im,'Normalization','probability','faceColor','r','edgecolor','r','BinWidth',0.02);
xlabel('Differetial Score');
ylabel('Probability');
title('Matching Score Distribution for the gallery');
legend('Genuine Distribution', 'Imposter Distribution', 'location', 'Northeast');
hold off
save('hG.mat','hG')
save('hI.mat','hI')
