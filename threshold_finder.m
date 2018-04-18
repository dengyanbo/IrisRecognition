clear;
clc;
close all;

load('hG.mat');
load('hI.mat');

min = 1;
G=hG.Values;
I=hI.Values;
for i=1:48
    f = sum(G(i:49))+sum(I(1:i));
    if min > f
        min = f;
        threshold = (i+1)*0.02;
    end
end
display(min);
display(threshold);