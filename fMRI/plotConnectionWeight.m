function plotConnectionWeight(inputFMRI, graphCell, startP, endP)

%% plotConnectionWeight
% Compares the edge weight of two regions for two groups

% Input Arguments
% inputFMRI and graphCell from mergeFMRIdata_input.m
% startP = First Region (as String)
% endP = Second Region (as String)

%% Example
% plotConnectionWeight(inputFMRI, graphCell, 'L DORpm', 'L MOp')

%% Do not modify the following lines

days = inputFMRI.days;
groups = inputFMRI.groups;
numOfDays = size(inputFMRI.days,2);
numOfGroups =  size(inputFMRI.groups,2);
tempFile = load('../Tools/infoData/acronyms_splitted.mat');
acronyms = tempFile.acronyms;
addpath('./rsfMRI_Processing/');

valuesGroup1 = nan(size(graphCell{1,1}.Nodes.allMatrix,3),numOfDays);
for day=1:numOfDays
    curGraph=graphCell{1,day};
    numOfAnimals=size(graphCell{1,day}.Nodes.allMatrix,3);
    for animal = 1:numOfAnimals
        c = graph(curGraph.Nodes.allMatrix(:,:,animal) , cellstr(acronyms),'lower');
        edge = findedge(c,{startP},{endP});
        % rows = animals, columns = days
        if edge>0
            valuesGroup1(animal,day)=c.Edges.Weight(edge);
        else
            valuesGroup1(animal,day)=-1;
        end
    end
end
valuesGroup1(valuesGroup1==0)=nan;
valuesGroup1(valuesGroup1==-1)=0;

tableGroup1 = array2table(valuesGroup1);
for day = 1:numOfDays
    tableGroup1.Properties.VariableNames(day) = inputFMRI.days(day);
end
disp(strcat("Edge Weight from ",startP," to ",endP," in group ",inputFMRI.groups(1),':'));
disp(tableGroup1);

valuesGroup2 = nan(size(graphCell{2,1}.Nodes.allMatrix,3),numOfDays);
for day=1:numOfDays
    curGraph=graphCell{2,day};
    numOfAnimals=size(graphCell{2,day}.Nodes.allMatrix,3);
    for animal = 1:numOfAnimals
        c = graph(curGraph.Nodes.allMatrix(:,:,animal) , cellstr(acronyms),'lower');
        edge = findedge(c,{startP},{endP});
        % rows = animals, columns = days
        if edge>0
            valuesGroup2(animal,day)=c.Edges.Weight(edge);
        else
            valuesGroup2(animal,day)=-1;
        end
    end
end
valuesGroup2(valuesGroup2==0)=nan;
valuesGroup2(valuesGroup2==-1)=0;

tableGroup2 = array2table(valuesGroup2);
for day = 1:numOfDays
    tableGroup2.Properties.VariableNames(day) = inputFMRI.days(day);
end
disp(strcat("Edge Weight from ",startP," to ",endP," in group ",inputFMRI.groups(2),':'));
disp(tableGroup2);

valuesGroup = {valuesGroup1, valuesGroup2};
plotFigure('Connection Weight', days, groups, valuesGroup);
title([startP '  <->  ' endP]);
ylabel('Edge Weight');