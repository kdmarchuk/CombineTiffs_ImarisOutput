% Kyle Marchuk, April 2017
% This script is used to combine the .tif slices exported by Imaris

clear all
close all
clc

tic

% Store variables in a structure. Useful for sending into different
% functions
structParameters = struct(...
    'inpathdir','I:\20170202\ROI06Imaris2',...
    'outpathdir','I:\20170202\ROI06Imaris2',...
    'newFolder','\ImarisCombined',...
    'saveName','ROI06',...
    'numTime',100,...
    'numChannels',4,...
    'zerosT',3,...
    'zerosZ',3);
% Make the new saving directory
mkdir(structParameters.outpathdir,structParameters.newFolder);
% Prompt the user to give names for the channels
channelNames = [];
for pp = 1:structParameters.numChannels
    prompt = {strcat('What is the Name of channel ',int2str(pp-1),'?')};
    channelNames{pp} = inputdlg(prompt);
end % for
%Populate a list with all the .tifs in the folder
fnames = dir(fullfile(structParameters.inpathdir,'*tif'));
fnames = {fnames.name}.';
% Find function based on regular expressions
FIND = @(str) cellfun(@(c)~isempty(c),regexp(fnames,str,'once'));

% Main for loop
for cc = 0:structParameters.numChannels-1
    % Create a sub populations of files separated by channel
    regexp_channel = strcat('_C',int2str(cc));
    channel_subset = fnames(FIND(regexp_channel));
    
    if structParameters.numChannels == 1
        
        for tt = 0:structParameters.numTime-1
            % Create a second sub populations of file based on the time
            FIND2 = @(str) cellfun(@(c)~isempty(c),regexp(fnames,str,'once'));
            digits = strcat('%0',int2str(structParameters.zerosT),'d');
            regexp_time = strcat('_T',sprintf(digits,tt));
            time_subset = fnames(FIND2(regexp_time));
            % Combine all the files with the same time and channel stamp
            for ii = 1:length(time_subset)
                combinedFiles(:,:,ii) = imread(strcat(structParameters.inpathdir,'\',char(time_subset(ii))));
            end % for
            
            % Create the save name and save the .tif stack
            fileName = strcat(structParameters.outpathdir,structParameters.newFolder,'\',structParameters.saveName,'_',char(channelNames{cc+1}),'_C',int2str(cc),'_T',sprintf(digits,tt),'.tif');
            writeTiff(combinedFiles,fileName);
            
            % Displays for sanity
            disp(cc)
            disp(tt)
            toc
        end
        
        
    else
    
        for tt = 0:structParameters.numTime-1
            % Create a second sub populations of file based on the time
            FIND2 = @(str) cellfun(@(c)~isempty(c),regexp(channel_subset,str,'once'));
            digits = strcat('%0',int2str(structParameters.zerosT),'d');
            regexp_time = strcat('_T',sprintf(digits,tt),'_C',int2str(cc));
            time_subset = channel_subset(FIND2(regexp_time));
            % Combine all the files with the same time and channel stamp
            for ii = 1:length(time_subset)
                combinedFiles(:,:,ii) = imread(strcat(structParameters.inpathdir,'\',char(time_subset(ii))));
            end % for
            
            % Create the save name and save the .tif stack
            fileName = strcat(structParameters.outpathdir,structParameters.newFolder,'\',structParameters.saveName,'_',char(channelNames{cc+1}),'_C',int2str(cc),'_T',sprintf(digits,tt),'.tif');
            writeTiff(combinedFiles,fileName);
            
            % Displays for sanity
            disp(cc)
            disp(tt)
            toc
        end % for
    
    end

    
end % for



toc