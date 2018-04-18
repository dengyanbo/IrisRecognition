clear;
clc;
% close all;

load('threshold.mat');
templatePath = 'C:\MATLABR2016a\bin\myworkspace\Biometrics\assignment2\LG2200_2008\';
imgDataPath = 'C:\MATLABR2016a\bin\myworkspace\Biometrics\assignment2\LG4000_2010\';
% imgDataPath = 'C:\MATLABR2016a\bin\myworkspace\Biometrics\assignment2\LG2200_2010\';
templateDir = dir([templatePath '/*.mat']);
dataDir = dir([imgDataPath '/*.mat']);
templateData = {};
maskData = {};
mapData = {};
nameData = {};
scales = 0;

TP = 0;
TN = 0;
FP = 0;
FN = 0;
Gscore = [];
Iscore = [];

for i = 1:length(templateDir) %load template data
    load(templateDir(i).name)
    templateData = [templateData, {template}];
    maskData = [maskData, {mask}];
    mapData = [mapData, {map}];
    nameData = [nameData, templateDir(i).name];
end

for i = 1:length(dataDir) %iterate all probes
    load(dataDir(i).name)
    display(dataDir(i).name);
    temkeys = keys(template);
    curName = dataDir(i).name;
    curID = temkeys{randi(length(temkeys))};
    curTem = template(curID);
    curMask = mask(curID);
    if ~isKey(map,curID)
        continue;
    end
    curLR = map(curID);
    
    for j = 1:length(templateData) %iterate all templates
        count = 0;
        temMap = templateData{j};
        maskMap = maskData{j};
        lrMap = mapData{j};
        IDs = keys(temMap);
        name = nameData{j};
        for x = 1:length(IDs) %iterate one subject's templates
            ID = IDs{x};
            if ~isKey(lrMap,ID)
                continue;
            end
            if ~strcmp(lrMap(ID),map(curID))
                continue;
            end
            score = gethammingdistance(curTem, curMask, temMap(ID), maskMap(ID), scales);
            if score <= threshold
                count = count + 1;
            end
            if strcmp(curName, name)
                Gscore = [Gscore score];
            else
                Iscore = [Iscore score];
            end
        end
        if count >=3 && strcmp(curName, name) % True Positives
            TP = TP + 1;
        elseif count >=3 % False Positives
            FP = FP + 1;
        elseif strcmp(curName, name) % False Negatives
            FN = FN + 1;
        else % True Negatives
            TN = TN + 1;
        end
        
    end
    
    
end
Gscore(isnan(Gscore))=[];
Iscore(isnan(Iscore))=[];
FPR = FP/(FP+TN);
TPR = TP/(TP+FN);
save('Gscore2200.mat','Gscore')
save('Iscore2200.mat','Iscore')

figure,
hGscore = histogram(Gscore,'Normalization','probability','faceColor','b','edgecolor','b','BinWidth',0.02);
hold on
hIscore = histogram(Iscore,'Normalization','probability','faceColor','r','edgecolor','r','BinWidth',0.02);
xlabel('Differetial Score');
ylabel('Probability');
title('Matching Score Distribution for LG2200 2010');
legend('Genuine Distribution', 'Imposter Distribution', 'location', 'Northeast');
hold off
save('hGscore2200.mat','hGscore')
save('hIscore2200.mat','hIscore')

    